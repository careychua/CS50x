import os

from cs50 import SQL
from flask import Flask, flash, jsonify, redirect, render_template, request, session
from flask_session import Session
from tempfile import mkdtemp
from werkzeug.exceptions import default_exceptions, HTTPException, InternalServerError
from werkzeug.security import check_password_hash, generate_password_hash

from helpers import apology, login_required, lookup, usd


# Configure application
app = Flask(__name__)

# Ensure templates are auto-reloaded
app.config["TEMPLATES_AUTO_RELOAD"] = True

# Ensure responses aren't cached
@app.after_request
def after_request(response):
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


# Custom filter
app.jinja_env.filters["usd"] = usd
# enable use of python function in jinja
app.jinja_env.globals.update(lookup=lookup)

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_FILE_DIR"] = mkdtemp()
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# Configure CS50 Library to use SQLite database
db = SQL("sqlite:///finance.db")

# Make sure API key is set
if not os.environ.get("API_KEY"):
    raise RuntimeError("API_KEY not set")


@app.route("/")
@login_required
def index():
    """Show portfolio of stocks"""

    title = "Portfolio"

    # get details from database
    user_id = session.get("user_id")
    cash = db.execute("SELECT cash FROM users WHERE id=:user_id", user_id=user_id)[0]["cash"]
    transactions = db.execute("SELECT symbols.symbol, symbolname, SUM(shares) AS shares, price FROM transactions JOIN symbols ON transactions.symbol=symbols.symbol WHERE user_id=:user_id GROUP BY transactions.symbol;", user_id=user_id)

    # display table of user info
    return render_template("index.html", title=title, transactions=transactions, cash=cash)


@app.route("/buy", methods=["GET", "POST"])
@login_required
def buy():
    """Buy shares of stock"""

    #  # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # get user input
        symbol = request.form.get("symbol").lower()
        shares = int(request.form.get("shares"))
        quote = lookup(symbol)

        # Ensure symbol submitted
        if not symbol:
            return apology("must provide symbol")

        # check symbol exists
        quote = lookup(symbol)
        print(quote)
        if not quote:
            return apology("symbol does not exist")

        # check shares positive integer
        if shares <= 0:
            return apology("numbers of shares must be more than 0")

        # check finances of user
        user_id = session.get("user_id")
        price = float(quote["price"])
        symbolname = quote["name"]
        total_cost = price * shares
        user_cash = float(db.execute("SELECT cash FROM users WHERE id=:user_id", user_id=user_id)[0]["cash"])

        if user_cash < total_cost:
            return apology("not enough cash for purchase")

        # check whether symbols exists in symbols table, if not, then insert
        if int(db.execute("SELECT COUNT(symbol) AS count FROM symbols WHERE symbol=:symbol", symbol=symbol)[0]["count"]) == 0:
            db.execute("INSERT INTO symbols (symbol, symbolname) VALUES (:symbol, :symbolname)", symbol=symbol, symbolname=symbolname)

        # insert shares bought by user into transactions table
        db.execute("INSERT INTO transactions (user_id, symbol, shares, price, timestamp) VALUES (:user_id, :symbol, :shares, :price, CURRENT_TIMESTAMP)", user_id=user_id, symbol=symbol, shares=shares, price=price)

        # update cash of user in users table
        user_cash -= total_cost
        db.execute("UPDATE users SET cash=:user_cash WHERE id=:user_id", user_cash=user_cash, user_id=user_id)

        # Redirect user to index page
        flash("Bought!")
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        default_share = ""
        index_operation = request.args.get("index_operation")
        if index_operation:
            default_share = index_operation

        title = "BUY"
        return render_template("buy.html", title=title, default_share=default_share)


@app.route("/history")
@login_required
def history():
    """Show history of transactions"""

    title = "History"

    # get details from database
    user_id = session.get("user_id")
    transactions = db.execute("SELECT symbol, shares, price, timestamp FROM transactions WHERE user_id=:user_id ;", user_id=user_id)

    # display table of user info
    return render_template("history.html", title=title, transactions=transactions)


@app.route("/login", methods=["GET", "POST"])
def login():
    """Log user in"""

    # Forget any user_id
    session.clear()

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Ensure username was submitted
        if not request.form.get("username"):
            return apology("must provide username", 403)

        # Ensure password was submitted
        elif not request.form.get("password"):
            return apology("must provide password", 403)

        # Query database for username
        rows = db.execute("SELECT * FROM users WHERE username = :username",
                          username=request.form.get("username"))

        # Ensure username exists and password is correct
        if len(rows) != 1 or not check_password_hash(rows[0]["hash"], request.form.get("password")):
            return apology("invalid username and/or password", 403)

        # Remember which user has logged in
        session["user_id"] = rows[0]["id"]

        # Redirect user to home page
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        title = "Log In"
        return render_template("login.html", title=title)


@app.route("/logout")
def logout():
    """Log user out"""

    # Forget any user_id
    session.clear()

    # Redirect user to login form
    return redirect("/")


@app.route("/quote", methods=["GET", "POST"])
@login_required
def quote():
    """Get stock quote."""

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        symbol = request.form.get("symbol")

        # lookup symbol
        quote = lookup(symbol)

        # Redirect user to quoted
        title = "Quoted"
        return render_template("quoted.html", title=title, quote=quote)

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        title = "Quote"
        return render_template("quote.html", title=title)


@app.route("/register", methods=["GET", "POST"])
def register():
    """Register user"""

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        username = request.form.get("username")
        password = request.form.get("password")
        confirmation = request.form.get("confirmation")

        # Ensure username was submitted
        if not username:
            return apology("must provide username", 403)

        # Ensure password was submitted
        elif not password:
            return apology("must provide password", 403)

        # Ensure confirmation was submitted
        elif not confirmation:
            return apology("must provide password confirmation", 403)

        # Ensure password and confirmation matches
        elif password != confirmation:
            return apology("password and confirmation does not match", 403)

        # Query database for username
        rows = db.execute("SELECT * FROM users WHERE username = :username", username=username)

        # Ensure username does not exists
        if len(rows) == 1:
            return apology("username exists", 403)

        # register new user, by inserting user into database
        db.execute("INSERT INTO users (username, hash) VALUES (:username, :password)", username=username, password=generate_password_hash(password))

        # Remember which user has logged in
        rows = db.execute("SELECT id FROM users WHERE username = :username", username=username)
        session["user_id"] = rows[0]["id"]

        # Redirect user to index page
        flash("Registered!")
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        title = "Register"
        return render_template("register.html", title=title)


@app.route("/change_password", methods=["GET", "POST"])
@login_required
def change_password():
    """Change user password"""

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        current_password = request.form.get("current_password")
        new_password = request.form.get("new_password")
        confirmation = request.form.get("confirmation")
        user_id = session.get("user_id")

        # Ensure current password was submitted
        if not current_password:
            return apology("must provide current password", 403)

        # Ensure new password was submitted
        elif not new_password:
            return apology("must provide new password", 403)

        # Ensure confirmation was submitted
        elif not confirmation:
            return apology("must provide password confirmation", 403)

        # Ensure new password and confirmation matches
        elif new_password != confirmation:
            return apology("new password and confirmation does not match", 403)

        # Ensure current password is correct
        password_hash = db.execute("SELECT hash FROM users WHERE id=:user_id", user_id=user_id)[0]["hash"]
        if len(password_hash) == 0 or not check_password_hash(password_hash, current_password):
            return apology("current password is incorrect", 403)

        # Ensure current password and new password are not the same
        elif current_password == new_password:
            return apology("current password and new password are the same", 403)

        # Update new password into database
        db.execute("UPDATE users SET hash=:password WHERE id=:user_id", password=generate_password_hash(new_password), user_id=user_id)

        # Redirect user to index page
        flash("Password Changed!")
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        title = "Change Password"
        return render_template("change_password.html", title=title)


@app.route("/sell", methods=["GET", "POST"])
@login_required
def sell():
    """Sell shares of stock"""

    # Get user id
    user_id = session.get("user_id")
    # Get symbols to populate drop-down list
    symbols = db.execute("SELECT DISTINCT(symbol) FROM transactions WHERE user_id=:user_id ORDER BY symbol", user_id=user_id)

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        symbol = request.form.get("symbol")
        shares = int(request.form.get("shares"))

        # Check if user select symbol
        if len(symbol) == 0:
            return apology("symbol not selected")

        # Check if user entered positive integer for shares
        if shares <= 0:
            return apology("numbers of shares must be more than 0")

        # Check if user owns shares
        num_shares = int(db.execute("SELECT SUM(shares) AS sum FROM transactions WHERE user_id=:user_id AND symbol=:symbol;", user_id=user_id, symbol=symbol)[0]["sum"])
        if num_shares <= 0:
            return apology("shares not owned")

        # Check if user has enough shares to sell
        if num_shares < shares:
            return apology("shares owned not sufficient")

        # insert shares sold by user into transactions table
        price = lookup(symbol)["price"]
        db.execute("INSERT INTO transactions (user_id, symbol, shares, price, timestamp) VALUES (:user_id, :symbol, :shares, :price, CURRENT_TIMESTAMP)", user_id=user_id, symbol=symbol, shares=shares * -1, price=price)

        # update cash of user in users table
        user_cash = float(db.execute("SELECT cash FROM users WHERE id=:user_id", user_id=user_id)[0]["cash"])
        user_cash += price * shares
        db.execute("UPDATE users SET cash=:user_cash WHERE id=:user_id", user_cash=user_cash, user_id=user_id)

        flash("Sold!")
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        default_share = ""
        index_operation = request.args.get("index_operation")
        if index_operation:
            default_share = index_operation

        title = "Sell"
        return render_template("sell.html", title=title, symbols=symbols, default_share=default_share)


@app.route("/update_cash", methods=["GET", "POST"])
@login_required
def update_cash():
    """Update user's cash amount"""

    # Get user id
    user_id = session.get("user_id")

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        cash_operation = request.form.get("cash_operation")
        cash_amount = request.form.get("cash_amount")
        print(cash_operation)

        # Check if user selected operation
        if not cash_operation:
            return apology("operation not selected")

        # Check if user input amount
        if not cash_amount:
            return apology("must input amount")

        # Check if user input positive amount
        cash_amount = int(cash_amount)
        if cash_amount <= 0:
            return apology("amount should be more than 0")

        user_cash = float(db.execute("SELECT cash FROM users WHERE id=:user_id", user_id=user_id)[0]["cash"])
        # Update user's cash in database
        if cash_operation == "add":
            user_cash += cash_amount
            operation_string = "Cash Added!"

        # Check user's cash enough in database if withdraw
        elif cash_operation == "withdraw" and user_cash >= cash_amount:
            user_cash -= cash_amount
            operation_string = "Cash Withdrawn!"
        else:
            return apology("not enough cash for withdrawal")

        db.execute("UPDATE users SET cash=:user_cash WHERE id=:user_id", user_cash=user_cash, user_id=user_id)

        flash(operation_string)
        return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        title = "Update Cash"
        return render_template("update_cash.html", title=title)


def errorhandler(e):
    """Handle error"""
    if not isinstance(e, HTTPException):
        e = InternalServerError()
    return apology(e.name, e.code)


# Listen for errors
for code in default_exceptions:
    app.errorhandler(code)(errorhandler)

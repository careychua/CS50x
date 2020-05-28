# CS50x Project
## Web (Flask, SQLite3): Finance


## Project Requirements
Web application to manage portfolio of stocks

---
### Register
Allows a user to register for an account via a form.
  ![Finance Register](README/Finance%20Register.png)
1. Require that a user input a username, implemented as a text field whose ```name``` is ```username```. Render an apology if the user’s input is blank or the username already exists.

2. Require that a user input a password, implemented as a text field whose ```name``` is ```password```, and then that same password again, implemented as a text field whose ```name``` is ```confirmation```. Render an apology if either input is blank or the passwords do not match.

3. Submit the user’s input via ```POST``` to ```/register```.
   
4. ```INSERT``` the new user into ```users```, storing a hash of the user’s password, not the password itself. Hash the user’s password with ```generate_password_hash```.

---
### Quote
Allows a user to look up a stock’s current price.
  ![Finance Quote](README/Finance%20Quote.png)
1. Require that a user input a stock’s symbol, implemented as a text field whose ```name``` is ```symbol```.

2. Submit the user’s input via ```POST``` to ```/quote```.

---
### Buy
  Enables a user to buy stocks.
  ![Finance Buy](README/Finance%20Buy.png)
1. Require that a user input a stock’s symbol, implemented as a text field whose ```name``` is ```symbol```. Render an apology if the input is blank or the symbol does not exist (as per the return value of ``lookup``).

2. Require that a user input a number of shares, implemented as a text field whose ```name``` is ```shares```. Render an apology if the input is not a positive integer.

3. Submit the user’s input via ```POST``` to ```/buy```.
4. Render an apology, without completing a purchase, if the user cannot afford the number of shares at the current price.

---
### Index
  Displays a HTML table summary for the user currently logged in.
  ![Finance Index](README/Finance%20Portfolio.png)
1. Stocks the user owns 
2. The numbers of shares owned
3. The current price of each stock
4. The total value of each holding
5. The user’s current cash balance along with a grand total

---
### Sell
  Enables a user to sell shares of a stock owned.
  ![Finance Sell](README/Finance%20Sell.png)
1. Require that a user input a stock’s symbol, implemented as a ```select``` menu whose ```name``` is ```symbol```. Render an apology if the user fails to select a stock or if (somehow, once submitted) the user does not own any shares of that stock.

2. Require that a user input a number of shares, implemented as a text field whose ```name``` is ```shares```. Render an apology if the input is not a positive integer or if the user does not own that many shares of the stock.

3. Submit the user’s input via ```POST``` to ```/sell```.

---
### History
  Displays a HTML table summarizing all of a user’s transactions.
  ![Finance History](README/Finance%20History.png)
1. For each row, make clear whether a stock was bought or sold and include the stock’s symbol, the (purchase or sale) price, the number of shares bought or sold, and the date and time at which the transaction occurred.

---
### Additional Features
1. Log in page
    ![Finance Log In](README/Finance%20Log%20In.png)
2. Allow users to change their passwords.
    ![Finance Change Password](README/Finance%20Change%20Password.png)
3. Allow users to add cash to or withdraw cash from their account.
    ![Finance Update Cash](README/Finance%20Update%20Cash.png)
4. Allow users to buy more shares or sell shares of stocks they already own via index itself, without having to type stocks’ symbols manually.
5. Require users’ passwords to have some number of letters, numbers, and/or symbols.
   
---

package app.pokedex;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.Serializable;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import app.pokedex.R;

public class PokemonActivity extends AppCompatActivity implements Serializable {
    // declare variables
    private ImageView imageView;
    private TextView nameTextView;
    private TextView numberTextView;
    private TextView type1TextView;
    private TextView type2TextView;
    private TextView descriptionTextView;
    private Button catchButton;
    private Pokemon pokemon;
    private List<Pokemon> pokemonList;
    private int listPosition;
    private String url;
    private String imageUrl;
    private String speciesUrl;
    private String pokemonDescription;
    private Boolean caught;
    private RequestQueue requestQueue;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_pokemon);
        requestQueue = Volley.newRequestQueue(getApplicationContext());

        // get the values from the class using intent
        // get the intent that started the activity and get the data passed
        pokemonList =  (List<Pokemon>) getIntent().getSerializableExtra("pokemonList");
        listPosition = (int) getIntent().getSerializableExtra("listPosition");
        pokemon = pokemonList.get(listPosition);
        url = pokemon.getUrl();
        caught = pokemon.getCaught();

        updateActivityResults();

        // assign variables to the corresponding fields
        imageView = findViewById(R.id.pokemon_image);
        nameTextView = findViewById(R.id.pokemon_name);
        numberTextView = findViewById(R.id.pokemon_number);
        type1TextView = findViewById(R.id.pokemon_type1);
        type2TextView = findViewById(R.id.pokemon_type2);
        descriptionTextView = findViewById(R.id.pokemon_description);
        catchButton = findViewById(R.id.catch_button);

        // set values of the text views to display on screen
        load();
    }

    // load in data from API
    public void load() {
        type1TextView.setText("");
        type2TextView.setText("");

        if (caught) {
            catchButton.setText("Release");
        }
        else {
            catchButton.setText("Catch");
        }
        // JSON request that will handle JSON response
        JsonObjectRequest request = new JsonObjectRequest(Request.Method.GET, url, null, new Response.Listener<JSONObject>() {
            // method auto called when data finishes loading
            @Override
            public void onResponse(JSONObject response) {
                try {
                    nameTextView.setText(response.getString("name"));
                    numberTextView.setText(String.format("#%03d", response.getInt("id")));
                    JSONArray typeEntries = response.getJSONArray("types");
                    JSONObject sprites = response.getJSONObject("sprites");
                    JSONObject species = response.getJSONObject("species");

                    for (int i = 0; i < typeEntries.length(); i++) {
                        JSONObject typeEntry = typeEntries.getJSONObject(i);
                        int slot = typeEntry.getInt("slot");
                        String type = typeEntry.getJSONObject("type").getString("name");

                        if (slot == 1) {
                            type1TextView.setText(type);
                        }
                        else if (slot == 2) {
                            type2TextView.setText(type);
                        }
                    }

                    // get image URL
                    imageUrl = sprites.getString("front_default");
                    // show imageUrl in imageView
                    new DownloadSpriteTask().execute(imageUrl);

                    // get species URL
                    speciesUrl = species.getString("url");
                    setPokemonDescription();

                } catch (JSONException e) {
                    // when there is no such key, or wrong return type
                    Log.e("cs50", "Pokemon JSON error", e);
                }
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Log.e("cs50", "Pokemon details error");
            }
        });

        requestQueue.add(request);
    }


    private void setPokemonDescription() {
        // JSON request that will handle JSON response
        JsonObjectRequest request2 = new JsonObjectRequest(Request.Method.GET, speciesUrl, null, new Response.Listener<JSONObject>() {
            // method auto called when data finishes loading
            @Override
            public void onResponse(JSONObject response) {
                try {
                    JSONArray flavourTextEntries = response.getJSONArray("flavor_text_entries");

                    for (int i = 0; i < flavourTextEntries.length(); i++) {
                        JSONObject flavorTextEntry = flavourTextEntries.getJSONObject(i);

                        if (flavorTextEntry.getJSONObject("language").getString("name").equals("en")) {
                            pokemonDescription = (flavorTextEntry.getString("flavor_text")).replaceAll("\\n", " ");
                            descriptionTextView.setText(pokemonDescription);
                            break;
                        }
                    }
                } catch (JSONException e) {
                    // when there is no such key, or wrong return type
                    Log.e("cs50", "Pokemon JSON error in flavour", e);
                }
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Log.e("cs50", "Pokemon details error in flavour");
            }
        });

        requestQueue.add(request2);
    }


    public void toggleCatch(View view) {
        if (caught) {
            catchButton.setText("Catch");
            caught = false;
        }
        else {
            catchButton.setText("Release");
            caught = true;
        }

        updateActivityResults();
    }


    public void updateActivityResults() {
        pokemon.setCaught(caught);
        pokemonList.set(listPosition, pokemon);

        Intent resultIntent = new Intent();
        resultIntent.putExtra("pokemonList", (Serializable) pokemonList);
        setResult(Activity.RESULT_OK, resultIntent);
    }

    // Start: class DownloadSpriteTask
    private class DownloadSpriteTask extends AsyncTask<String, Void, Bitmap> {
        @Override
        protected Bitmap doInBackground(String... strings) {
            try {
                URL url = new URL(strings[0]);
                return BitmapFactory.decodeStream(url.openStream());
            }
            catch (IOException e) {
                Log.e("cs50", "Download sprite error", e);
                return null;
            }
        }

        @Override
        protected void onPostExecute(Bitmap bitmap) {
            imageView.setImageBitmap(bitmap);
        }
    }
    // End: class DownloadSpriteTask
}

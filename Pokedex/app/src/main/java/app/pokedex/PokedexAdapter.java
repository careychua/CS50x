package app.pokedex;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

// represent all data inside of recyclerView
// base class from recyclerView
public class PokedexAdapter extends RecyclerView.Adapter<PokedexAdapter.PokedexViewHolder> implements Filterable, Serializable {
//  Start: Callback interface
        // declare variables
    private CallbackInterface mCallback;

    public interface CallbackInterface {
        // callback invoke when clicked
        void onHandleSelection(List<Pokemon> pokemonList, int listPosition);
    }

    // constructor
    public PokedexAdapter(Context context){
        // Attach the interface
        try{
            mCallback = (CallbackInterface) context;
        }catch(ClassCastException ex){
            Log.e("PokedexAdapterERR","Must implement the CallbackInterface in the Activity", ex);
        }

        requestQueue = Volley.newRequestQueue(context);
        //make call to retrieve and load data
        loadPokemon();
    }
//  End: Callback interface


//  Start: PokedexAdapter Class
        // declare variables
    private List<Pokemon> pokemon = new ArrayList<>();
    private List<Pokemon> rawPokemon = new ArrayList<>();
    private Set<String> pokemonCaughtSet = new HashSet<>();
    private Boolean pokemonCaught;
    private RequestQueue requestQueue;

    // holds all views in recyclerView
    public class PokedexViewHolder extends RecyclerView.ViewHolder implements Serializable {

        // elements in recyclerView
        public LinearLayout containerView;
        public TextView textView;

        // constructor for views to be in recycler view
        PokedexViewHolder(View view) {
            super(view);
            containerView = view.findViewById(R.id.pokedex_row);
            textView = view.findViewById(R.id.pokedex_row_text_view);


            // set eventHandler for when row is tapped
            // define Class that has only 1 method
            containerView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    // retrieve from the tag set in onBindHolder
                    List<Pokemon> pokemonList = (List<Pokemon>) containerView.getTag(R.id.intent_pokemon);
                    int listPosition = (int) containerView.getTag(R.id.intent_position);

                    if(mCallback != null){
                        mCallback.onHandleSelection(pokemonList, listPosition);
                    }
                }
            });

        }
    }
//  End: PokedexViewHolder class


//  Start: PokemonFilter class
    @Override
    public Filter getFilter() {
        return new PokemonFilter();
    }

    private class PokemonFilter extends Filter implements Serializable{
        List<Pokemon> filteredPokemon = new ArrayList<>();

        PokemonFilter() {
            super();
        }

        @Override
        protected FilterResults performFiltering(CharSequence constraint) {
            String search = (constraint).toString().toLowerCase();

            if (constraint.length() != 0) {
                for (Pokemon poke : rawPokemon) {
                    if (poke.getName().toLowerCase().contains(search)) {
                        filteredPokemon.add(poke);
                    }
                }
            }
            else {
                filteredPokemon = rawPokemon;
            }

            FilterResults results = new FilterResults();
            results.values = filteredPokemon; // you need to create this variable!
            results.count = filteredPokemon.size();
            return results;
        }


        @Override
        protected void publishResults(CharSequence constraint, FilterResults results) {
            pokemon = (List<Pokemon>) results.values;

            notifyDataSetChanged();
        }
    }
//  End: PokemonFilter class


    // create new viewHolder
    @NonNull
    @Override
    public PokedexViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        // get layout file, sinflate -> go from XML file to Java view
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.pokedex_row, parent, false);

        return new PokedexViewHolder(view);
    }


    // get number of rows in list to display
    @Override
    public int getItemCount() {
        return pokemon.size();
    }


    // for when view scrolls into screen, set the values inside the row
    // set the properties for the view created
    @Override
    public void onBindViewHolder(@NonNull PokedexViewHolder holder, int position) {
        Pokemon current = pokemon.get(position);

        holder.textView.setText(current.getName());
        // can set anything that needs to be sent
        // viewHolder has access to current pokemon
        holder.containerView.setTag(R.id.intent_pokemon, pokemon);
        holder.containerView.setTag(R.id.intent_position, position);
    }


    // load data from API into list
    public void loadPokemon() {
        String url = "https://pokeapi.co/api/v2/pokemon?limit=151";
        // JSON request that will handle JSON response
        JsonObjectRequest request = new JsonObjectRequest(Request.Method.GET, url, null, new Response.Listener<JSONObject>() {
            // method auto called when data finishes loading
            @Override
            public void onResponse(JSONObject response) {
                try {
                    // get JSON data from response
                    JSONArray results = response.getJSONArray("results");
                    // add JSON results to pokemon list
                    for (int i = 0; i < results.length(); i++) {
                        JSONObject result = results.getJSONObject(i);
                        String name = result.getString("name");
                        if (pokemonCaughtSet.contains(name)) {
                            pokemonCaught = true;
                        }
                        else {
                            pokemonCaught = false;
                        }

                        rawPokemon.add(new Pokemon(name.substring(0, 1).toUpperCase() + name.substring(1), result.getString("url"), pokemonCaught));
                        pokemon = rawPokemon;
                    }
                    // reload new data into view
                    notifyDataSetChanged();
                } catch (JSONException e) {
                    // when there is no such key, or wrong return type
                    Log.e("cs50", "JSON error", e);
                }
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Log.e("cs50", "Pokemon List error");
            }
        });

        // kick off/make request
        requestQueue.add(request);
    }


    public void reloadPokemon(List<Pokemon> pokemonList) {
        pokemon = pokemonList;
        notifyDataSetChanged();
    }


    // get set of caught pokemons
    public void setPokemonCaughtSet(Set<String> pokeCaughtSet) {
        pokemonCaughtSet = pokeCaughtSet;
    }
}
// End: PokedexAdapter class






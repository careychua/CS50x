package app.pokedex;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.SearchView;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class MainActivity extends AppCompatActivity implements SearchView.OnQueryTextListener, Serializable, PokedexAdapter.CallbackInterface {
    // declare and initialise variables
    private static final int POKEMON_ACTIVITY = 1001;
    private static String sharedPrefFile = "app.pokedex";
    private static String POKEMON_CAUGHT_LIST = "pokemonCaughtList";

    //declare variables
    private RecyclerView recyclerView;
    private RecyclerView.LayoutManager layoutManager;
    private PokedexAdapter adapter;
    private SharedPreferences sharedPref;
    private List<Pokemon> pokemonList = new ArrayList<>();
    private Set<String> pokemonCaughtSet = new HashSet<>();


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // instantiate
        recyclerView = findViewById(R.id.recycler_view);
        sharedPref = getSharedPreferences(sharedPrefFile, MODE_PRIVATE);
        adapter = new PokedexAdapter(this);
        layoutManager = new LinearLayoutManager(this);

        // get user's saved settings
        pokemonCaughtSet = sharedPref.getStringSet(POKEMON_CAUGHT_LIST, null);
        adapter.setPokemonCaughtSet(pokemonCaughtSet);

        // connect MVC, so that it knows what data to display using what layout
        recyclerView.setAdapter(adapter);
        recyclerView.setLayoutManager(layoutManager);
    }


    // auto called when user types into SearchView
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        super.onCreateOptionsMenu(menu);

        getMenuInflater().inflate(R.menu.main_menu, menu);
        MenuItem searchItem = menu.findItem(R.id.action_search);
        SearchView searchView = (SearchView) searchItem.getActionView();
        searchView.setOnQueryTextListener(this);

        return true;
    }


    @Override
    public boolean onQueryTextSubmit(String newText) {
        adapter.getFilter().filter(newText);
        return false;
    }


    @Override
    public boolean onQueryTextChange(String newText) {
        adapter.getFilter().filter(newText);
        return false;
    }


    // interface method which communicates with next activity
    @Override
    public void onHandleSelection(List<Pokemon> pokemonList, int listPosition) {
        // start new activity and use intent
        Intent intent = new Intent(MainActivity.this, PokemonActivity.class);
        intent.putExtra("pokemonList", (Serializable) pokemonList);
        intent.putExtra("listPosition", listPosition);
        startActivityForResult(intent, POKEMON_ACTIVITY);
    }


    // auto call when exit from previous view
    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (resultCode) {
            case Activity.RESULT_OK:
                if (requestCode == POKEMON_ACTIVITY) {
                    pokemonList = (List<Pokemon>) data.getSerializableExtra("pokemonList");
                }
                break;
            case Activity.RESULT_CANCELED:
                System.out.println("RESULT_CANCELED");
        }

        adapter.reloadPokemon(pokemonList);
    }

    @Override
    protected void onResume() {
        super.onResume();
        SharedPreferences.Editor sharedPrefEditor = sharedPref.edit();
        sharedPrefEditor.clear();
        sharedPrefEditor.apply();

        if (pokemonList != null) {
            for (Pokemon poke : pokemonList) {
                String pokemonName = poke.getName().toLowerCase();
                Boolean pokeCaught = poke.getCaught();

                if (pokeCaught) {
                    pokemonCaughtSet.add(pokemonName);
                }
                else {
                    pokemonCaughtSet.remove(pokemonName);
                }
            }
        }
        else {
            System.out.println("pokemonList is null");
        }

        sharedPrefEditor.putStringSet(POKEMON_CAUGHT_LIST, pokemonCaughtSet);
        sharedPrefEditor.apply();
    }
}

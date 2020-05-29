//
//  PokemonListViewController.swift
//  Pokédex
//
//  Created by Carey Chua on 12/4/20.
//  Copyright © 2020 Carey Chua. All rights reserved.
//

import UIKit

class PokemonListViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet var searchBar: UISearchBar!
    
    var status: Bool!
    var searchActive: Bool = false
    var pokemonCaught: PokemonCaught!
    var pokemonPrevious: PokemonCaught!
    var pokemon: [Pokemon] = []
    var pokemonSearchList: [PokemonCaught] = []
    var pokemonList: [PokemonCaught] = []
    
    func capitalise(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let pokemonList = try JSONDecoder().decode(PokemonList.self, from: data)
                self.pokemon = pokemonList.results
                
                // populate status table to set all to false
                for poke in self.pokemon {
                    // check whether in UserDefaults
                    
                    self.status = UserDefaults.standard.bool(forKey: poke.name)
                    if self.status == nil {
                        self.status = false
                    }
                    
                    self.pokemonCaught = PokemonCaught(poke: poke, status: self.status)
                    self.pokemonList.append(self.pokemonCaught)
                }
                self.pokemonSearchList = self.pokemonList
                
                // reload data on table view
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch let error {
                print("\(error)")
            }
        }.resume()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pokemonSearchList.removeAll()
        
        if searchText.count > 0 {
            for pokemon in self.pokemonList {
                if pokemon.poke.name.range(of: searchText, options: .caseInsensitive) != nil {
                    self.pokemonSearchList.append(pokemon)
                }
            }
            searchActive = true;
        }
        else {
            self.pokemonSearchList = self.pokemonList
        }
        
        // reload data on table view
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonSearchList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        
        cell.textLabel?.text = capitalise(text: pokemonSearchList[indexPath.row].poke.name)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonSegue" {
            // cast UIViewController as type PokemonViewController, returns null, if fail
            if let destination = segue.destination as? PokemonViewController {
                destination.pokemonCaught = pokemonSearchList[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
    @IBAction func myUnwindAction(_ unwindSegue: UIStoryboardSegue) {
        if let destination = unwindSegue.source as? PokemonViewController {
            if pokemonPrevious != nil {
                for row in 0..<self.pokemonList.count {
                    if pokemonList[row].poke.name == pokemonPrevious.poke.name {
                        pokemonList[row].status = self.pokemonPrevious.status
                    }
                }
                
                for row in 0..<self.pokemonSearchList.count {
                    if pokemonSearchList[row].poke.name == pokemonPrevious.poke.name {
                        pokemonSearchList[row].status = self.pokemonPrevious.status
                    }
                }
            }
        }
    }
}


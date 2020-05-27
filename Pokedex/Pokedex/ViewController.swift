//
//  ViewController.swift
//  Pokédex
//
//  Created by Carey Chua on 11/4/20.
//  Copyright © 2020 Carey Chua. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var pokemon: [Pokemon] = []
    
    func capitalise(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let pokemonList = try JSONDecoder().decode(PokemonList.self, from: data)
                self.pokemon = pokemonList.results
                
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
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemon.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        
        cell.textLabel?.text = capitalise(text: pokemon[indexPath.row].name)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonSegue" {
            // cast UIViewController as type PokemonViewController, returns null, if fail
            if let destination = segue.destination as? PokemonViewController {
                destination.pokemon = pokemon[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
}

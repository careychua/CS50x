//
//  PokemonViewController.swift
//  Pokédex
//
//  Created by Carey Chua on 11/4/20.
//  Copyright © 2020 Carey Chua. All rights reserved.
//

import UIKit

class PokemonViewController: UIViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet var catchButton: BorderedButton!
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var pokemonImage: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    
    var pokemon: Pokemon!
    var pokemonCaught: PokemonCaught!
    var pokemonPrevious: PokemonCaught!
    var buttonTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        type1Label.text = ""
        type2Label.text = ""
        
        let url = URL(string: pokemonCaught.poke.url)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let pokemonData = try JSONDecoder().decode(PokemonData.self, from: data)
                self.getPokemonDescription(speciesUrl: pokemonData.species.url)
                // get image from URL
                let imageUrl = URL(string: pokemonData.sprites.frontDefault)
                guard let imageData = try? Data(contentsOf: imageUrl!) else {
                    return
                }
                
                // reload data on view
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData)
                    self.pokemonImage.image = image
                    
                    self.nameLabel.text = self.pokemonCaught.poke.name
                    self.numberLabel.text = String(format: "#%03d", pokemonData.id)
                    
                    for typeEntry in pokemonData.types {
                        if typeEntry.slot == 1 {
                            self.type1Label.text = typeEntry.type.name
                        }
                        else if typeEntry.slot == 2 {
                            self.type2Label.text = typeEntry.type.name
                        }
                    }
                    
                    if (self.pokemonCaught.status) {
                        self.buttonTitle = "Release"
                    }
                    else {
                        self.buttonTitle = "Catch"
                    }
                    self.catchButton.setTitle(self.buttonTitle, for: .normal)
                }
            }
            catch let error {
                print("\(error)")
            }
        }.resume()
    }
    
    //get species data from URL
    func getPokemonDescription(speciesUrl: String) {
        let url = URL(string: speciesUrl)
        var tempString: String!
        var returnString: [Character] = []

        
        URLSession.shared.dataTask(with: url!){ (data, response, error) in
            guard let speciesData = data else {
                return
            }
            
            do {
                let pokemonSpeciesData = try JSONDecoder().decode(PokemonSpeciesData.self, from: speciesData)
                for row in pokemonSpeciesData.flavourTextEntries {
                    if row.language.name == "en" {
                        tempString = row.flavourText
                        break
                    }
                }
                
                for c in tempString {
                    if c == "\n" {
                        returnString.append(" ")
                    }
                    else {
                        returnString.append(c)
                    }
                }
                
                DispatchQueue.main.async {
                    self.descriptionLabel.text = String(returnString)
                }
            }
            catch let error {
                print("\(error)")
            }
        }.resume()
    }
    
    @IBAction func toggleCatch() {
        if pokemonCaught.status == true {
            pokemonCaught.status = false
            UserDefaults.standard.set(false, forKey: pokemonCaught.poke.name)
            self.buttonTitle = "Catch"
        }
        else {
            pokemonCaught.status = true
            UserDefaults.standard.set(true, forKey: pokemonCaught.poke.name)
            self.buttonTitle = "Release"
        }
        
        DispatchQueue.main.async {
            self.catchButton.setTitle(self.buttonTitle, for: .normal)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        performSegue(withIdentifier: "unwind", sender:self)
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwind" {
            if let destination = segue.destination as? PokemonListViewController {
                destination.pokemonPrevious = pokemonCaught
            }
        }
    }
}

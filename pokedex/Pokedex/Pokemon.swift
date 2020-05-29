//
//  Pokemon.swift
//  Pokédex
//
//  Created by Carey Chua on 11/4/20.
//  Copyright © 2020 Carey Chua. All rights reserved.
//

import Foundation

struct Pokemon: Codable{
    let name: String
    let url: String
}

struct PokemonCaught {
    let poke: Pokemon
    var status: Bool
}

struct PokemonList: Codable {
    let results: [Pokemon]
}

struct PokemonData: Codable {
    let id: Int
    let types: [PokemonTypeEntry]
    let sprites: PokemonSprite
    let species: PokemonSpecies
}

struct PokemonTypeEntry: Codable {
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
    let url: String
}

struct PokemonSprite: Codable {
    let frontDefault: String
    
    enum CodingKeys: CodingKey, String {
        case frontDefault = "front_default"
        
    }
}

struct PokemonSpecies: Codable {
    let name: String
    let url: String
}

struct PokemonSpeciesData: Codable {
    let flavourTextEntries: [PokemonFlavourTextEntry]
    
    enum CodingKeys: CodingKey, String {
        case flavourTextEntries = "flavor_text_entries"
    }
}

struct PokemonFlavourTextEntry: Codable {
    let flavourText: String
    let language: PokemonFlavourTextEntryLanguage
    
    enum CodingKeys: String, CodingKey {
        case flavourText = "flavor_text"
        case language
    }
}

struct PokemonFlavourTextEntryLanguage: Codable {
    let name: String
    let url: String
}






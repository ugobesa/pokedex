//
//  Pokemon.swift
//  Pokedex
//
//  Created by Ugo Besa on 08/02/2016.
//  Copyright © 2016 Ugo Besa. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name:String!
    private var _pokedexId:Int!
    private var _description:String!
    private var _type:String!
    private var _defense:String!
    private var _height:String!
    private var _weight:String!
    private var _attack:String!
    private var _nextEvoTxt:String!
    private var _nextEvolutionId:String!
    private var _nextEvolutionLevel:String!
    private var _pokemonUrl:String!
    
    var name:String {
        return _name
    }
    
    var pokedexId:Int{
        return _pokedexId
    }
    
    var description:String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type:String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense:String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height:String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight:String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack:String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var nextEvoTxt:String {
        if _nextEvoTxt == nil {
            _nextEvoTxt = ""
        }
        return _nextEvoTxt
    }
    
    var nextEvolutionId:String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLevel:String {
        if _nextEvolutionLevel == nil {
            _nextEvolutionLevel = ""
        }
        return _nextEvolutionLevel
    }
    
    
    
    init(name:String, pokedexId:Int){
        _name = name
        _pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(_pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        let url = NSURL(string:_pokemonUrl)!
        
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String,AnyObject> {
                //Weight
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                //Height
                if let height = dict["height"] as? String {
                    self._height = height
                }
                //ATK
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                //DEF
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                //TYPES
                if let types = dict["types"] as? [Dictionary<String,String>] where types.count > 0 {
                    if let name1 = types[0]["name"] {
                        self._type = name1.capitalizedString
                        
                        if types.count > 1 {
                            for var x = 1 ; x < types.count ; x++ { // useless to me because only two types max
                                if let name2 = types[x]["name"] {
                                    self._type! += "/\(name2.capitalizedString)"
                                }
                            }
                        }
                    }
                    else{
                        self._type = ""
                    }
                }
                //Description
                if let descArr = dict["descriptions"] as? [Dictionary<String,String>] where descArr.count > 0{
                    if let url = descArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            let result = response.result
                            
                            if let descDict = result.value as? Dictionary<String,AnyObject> {
                                if let desc = descDict["description"] as? String {
                                    self._description = desc.stringByReplacingOccurrencesOfString("POKMON", withString: "pokemon")
                                    print(self._description)
                                }
                            }
                            completed() // like the parameter. it's here the block ends (2 async task)
                        }
                    }
                }
                else{
                    self._description = "NO DESCRIPTION"
                    print(self._description)
                }
                //Evolution
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>] where evolutions.count > 0 {
                    if let to = evolutions[0]["to"] as? String{
                        if to.rangeOfString("mega") == nil { // don't want mega
                            self._nextEvoTxt = to
                            if let uri = evolutions[0]["resource_uri"] as?String {
                                let newStr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "") // To get the id of the evolution
                                self._nextEvolutionId = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLevel = "\(lvl)"
                                    print(self._nextEvolutionLevel)
                                    print(self._nextEvolutionId)
                                    print(self._nextEvoTxt)
                                }
                            }
                        }
                    }
                }
            }
            else{
                print("Error Downloading pokemon data")
            }
        
        }
        
    }
    
}

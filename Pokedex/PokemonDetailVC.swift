//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Ugo Besa on 09/02/2016.
//  Copyright © 2016 Ugo Besa. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var evoLbl: UILabel!
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mainStackView: UIStackView!
    

    
    var pokemon: Pokemon!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        nameLabel.text = pokemon.name
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        
        pokemon.downloadPokemonDetails { () -> () in
            // this will be called after donwload is done
            self.updateUI()
        }
    }
    
    func updateUI() {
        descriptionLbl.text = pokemon.description
        typeLbl.text = pokemon.type
        defenseLbl.text = pokemon.defense
        heightLbl.text = pokemon.height
        weightLbl.text = pokemon.weight
        pokedexLbl.text = "\(pokemon.pokedexId)"
        attackLbl.text = pokemon.attack
        
        if pokemon.nextEvolutionId == "" {
            evoLbl.text = "NO EVOLUTION"
            nextEvoImg.hidden = true
            currentEvoImg.hidden = true
        }
        else{
            currentEvoImg.hidden = false
            nextEvoImg.hidden = false
            currentEvoImg.image = UIImage(named: "\(pokemon.pokedexId)")
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            var str = "Next Evolution \(pokemon.nextEvoTxt)"
            if pokemon.nextEvolutionLevel != "" {  // For those which envolve by level up
                str += " - LVL \(pokemon.nextEvolutionLevel)"
                evoLbl.text = str
            }
        }
    }

    
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func segmentControlPressed(sender: AnyObject) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            mainStackView.hidden = false
        case 1:
            mainStackView.hidden = true
        default:
            break; 
        }
    }


}

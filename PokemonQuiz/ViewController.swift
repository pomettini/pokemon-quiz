//
//  ViewController.swift
//  PokemonQuiz
//
//  Created by Giorgio Pomettini on 17/08/17.
//  Copyright © 2017 Giorgio Pomettini. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var startGenLabel: UILabel!
    @IBOutlet weak var endGenLabel: UILabel!
    @IBOutlet weak var startGenSlider: UISlider!
    @IBOutlet weak var endGenSlider: UISlider!
    @IBOutlet weak var pokemonCountLabel: UILabel!
    
    @IBAction func sliderMove(_ sender: Any)
    {
        updateGenerationLabels()
    }
    
    let defaults = UserDefaults.standard
    
    var generations: [Int] = [0, 0]
    var generationLabels = [String]()
    var generationPokemonNumbers: [Int] = [0, 151, 100, 135, 107, 156, 72]
    
    var startCountingPokemonIngameFrom: Int = 0
    var pokemonIngameCount: Int = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        generationLabels += ["first", "second", "third", "fourth", "fifth", "sixth"]
        
        getSavedData()
        
        updateGenerationLabels()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getSavedData()
    {
        guard defaults.object(forKey: "startCountPos") != nil else { return }
        guard defaults.object(forKey: "endCountPos") != nil else { return }
        
        startGenSlider.value = Float(defaults.object(forKey: "startCountPos") as! Int)
        endGenSlider.value = Float(defaults.object(forKey: "endCountPos") as! Int)
    }
    
    func updateGenerationLabels()
    {
        // If you select a bigger start generation than end generation
        if(startGenSlider.value > endGenSlider.value)
        {
            startGenSlider.value = endGenSlider.value
        }
        
        // Round slider value to nearest Int
        generations[0] = Int(startGenSlider.value.rounded())
        generations[1] = Int(endGenSlider.value.rounded())
        
        // Save sliders positions to defaults
        defaults.set(generations[0], forKey: "startCountPos")
        defaults.set(generations[1], forKey: "endCountPos")
        
        // Calculate the starting position for counting Pokemons
        startCountingPokemonIngameFrom = 0
        for i in 0 ..< generations[0]
        {
            startCountingPokemonIngameFrom += generationPokemonNumbers[i]
        }
        
        // Calculate Pokemon count amount
        pokemonIngameCount = 0
        for i in 0 ..< generations[1]
        {
            pokemonIngameCount += generationPokemonNumbers[i + 1]
        }
        
        if(generations[0] == generations[1])
        {
            // Same generation
            startGenLabel.text = "Just \(generationLabels[generations[0] - 1]) gen"
            endGenLabel.text = ""
        }
        else
        {
            // Different generations
            startGenLabel.text = "From \(generationLabels[generations[0] - 1]) gen"
            endGenLabel.text = "To \(generationLabels[generations[1] - 1]) gen"
        }
        
        pokemonCountLabel.text = "A total of \(pokemonIngameCount - startCountingPokemonIngameFrom) Pokémons"
        
        
        // Save counting position to defaults
        defaults.set(startCountingPokemonIngameFrom, forKey: "startCountNum")
        defaults.set(pokemonIngameCount, forKey: "endCountNum")
        
        print(startCountingPokemonIngameFrom, pokemonIngameCount)
    }
}

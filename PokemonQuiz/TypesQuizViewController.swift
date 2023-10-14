//
//  TypesQuizViewController.swift
//  PokemonQuiz
//
//  Created by Giorgio Pomettini on 17/08/17.
//  Copyright © 2017 Giorgio Pomettini. All rights reserved.
//

import UIKit
import GameplayKit

// TODO: Fare in modo che si ripetano le combinazioni

class TypesQuizViewController: UIViewController
{
    var pokemons : Int = 719
    
    var pokemonNames = [String]()
    var pokemonType1 = [String]()
    var pokemonType2 = [String]()
    
    var types = [String]()
    var actualTypes: [String] = ["", ""]
    
    @IBOutlet weak var firstType: UILabel!
    @IBOutlet weak var secondType: UILabel!
    @IBOutlet weak var pokemonName: UITextField!
    
    @IBAction func Confirm(_ sender: Any)
    {
        var foundPokemon = false
        let pokemonList = getPokemonListOfTypes(firstType: types[0], secondType: types[1])
        var pokemonListAsString: String = ""
        
        for i in 0 ..< pokemonList.count
        {
            pokemonListAsString += "\(pokemonList[i]), "
        }
        
        // I'm so fucking lazy
        pokemonListAsString = String(pokemonListAsString.dropLast())
        pokemonListAsString = String(pokemonListAsString.dropLast())
        
        for i in 0 ..< pokemonList.count
        {
            if(pokemonName.text?.lowercased() == pokemonList[i].lowercased())
            {
                foundPokemon = true
            }
        }
        
        if(foundPokemon)
        {
            let ac = UIAlertController(title: title, message: "CORRECT! \(actualTypes[0])/\(actualTypes[1]) Pokemons are: \(pokemonListAsString)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: reset))
            present(ac, animated: true)
        }
        else
        {
            let ac = UIAlertController(title: title, message: "WRONG! \(actualTypes[0])/\(actualTypes[1]) Pokemons are: \(pokemonListAsString)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: reset))
            present(ac, animated: true)
        }
    }
    
    @IBAction func Skip(_ sender: Any)
    {
        let pokemonList = getPokemonListOfTypes(firstType: types[0], secondType: types[1])
        var pokemonListAsString: String = ""
        
        for i in 0 ..< pokemonList.count
        {
            pokemonListAsString += "\(pokemonList[i]), "
        }
        
        // I'm so fucking lazy
        pokemonListAsString = String(pokemonListAsString.dropLast())
        pokemonListAsString = String(pokemonListAsString.dropLast())
        
        let ac = UIAlertController(title: title, message: "\(actualTypes[0])/\(actualTypes[1]) Pokemons are: \(pokemonListAsString)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: reset))
        present(ac, animated: true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "Guess the Type"
        
        types +=
        [
            "Normal",
            "Fire",
            "Fighting",
            "Water",
            "Flying",
            "Grass",
            "Poison",
            "Electric",
            "Ground",
            "Psychic",
            "Rock",
            "Ice",
            "Bug",
            "Dragon",
            "Ghost",
            "Dark",
            "Steel",
            "Fairy"
        ]

        if let levelFilePath = Bundle.main.path(forResource: "PokemonNames", ofType: "txt")
        {
            if let levelContents = try? String(contentsOfFile: levelFilePath)
            {
                let lines = levelContents.components(separatedBy: "\n")
                pokemonNames = lines
            }
        }
        
        if let levelFilePath = Bundle.main.path(forResource: "PokemonFirstType", ofType: "txt")
        {
            if let levelContents = try? String(contentsOfFile: levelFilePath)
            {
                let lines = levelContents.components(separatedBy: "\n")
                pokemonType1 = lines
            }
        }
        
        if let levelFilePath = Bundle.main.path(forResource: "PokemonSecondType", ofType: "txt")
        {
            if let levelContents = try? String(contentsOfFile: levelFilePath)
            {
                let lines = levelContents.components(separatedBy: "\n")
                pokemonType2 = lines
            }
        }
        
        reset()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getNewPokemonTypes()
    {
        var foundType = false
        
        while foundType == false
        {
            types = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: types) as! [String]
            actualTypes[0] = types[0]
            actualTypes[1] = types[1]
            
            print(actualTypes)
            
            for i in 0 ..< pokemons
            {
                if(pokemonType1[i] == actualTypes[0] && pokemonType2[i] == actualTypes[1])
                {
                    print(pokemonNames[i])
                    foundType = true
                    break
                }
                
                if(pokemonType1[i] == actualTypes[1] && pokemonType2[i] == actualTypes[0])
                {
                    print(pokemonNames[i])
                    foundType = true
                    break
                }
            }
        }
    }
    
    func getPokemonListOfTypes(firstType: String, secondType: String) -> [String]
    {
        var pokemonList = [String]()
        
        for i in 0 ..< pokemons
        {
            if(pokemonType1[i] == firstType && pokemonType2[i] == secondType)
            {
                pokemonList.append(pokemonNames[i])
            }
            
            if(pokemonType1[i] == secondType && pokemonType2[i] == firstType)
            {
                pokemonList.append(pokemonNames[i])
            }
        }
        
        print(pokemonList)
        
        return pokemonList
    }
    
    func reset(action: UIAlertAction! = nil)
    {
        getNewPokemonTypes()
        firstType.text = actualTypes[0]
        secondType.text = actualTypes[1]
        pokemonName.text = ""
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

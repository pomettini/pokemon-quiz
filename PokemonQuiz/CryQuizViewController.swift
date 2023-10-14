//
//  CryQuizViewController.swift
//  PokemonQuiz
//
//  Created by Giorgio Pomettini on 17/08/17.
//  Copyright © 2017 Giorgio Pomettini. All rights reserved.
//

import UIKit
import GameplayKit
import Foundation
import AVFoundation

// TODO: Quando pokemonIdList è vuoto non deve crashare
// TODO: Fix per pokemon con caratteri speciali (Nidoran)

class CryQuizViewController: UIViewController
{
    let defaults = UserDefaults.standard
    
    var startCountingPokemonFrom: Int = 0
    var pokemonToCount: Int = 0
    
    var avPlayer: AVAudioPlayer?
    
    var pokemonIdList = [Int]()
    var pokemonNames = [String]()
    var actualPokemonId: Int = 0
    
    @IBOutlet weak var pokemonName: UITextField!
    
    @IBAction func Confirm(_ sender: Any)
    {
        if(pokemonName.text?.lowercased() == getPokemonName(id: actualPokemonId).lowercased())
        {
            let ac = UIAlertController(title: title, message: "CORRECT! It was \(getPokemonName(id: actualPokemonId))!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: generateNewPokemon))
            present(ac, animated: true)
        }
        else
        {
            let ac = UIAlertController(title: title, message: "WRONG! It was \(getPokemonName(id: actualPokemonId))!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: generateNewPokemon))
            present(ac, animated: true)
        }
    }
    
    @IBAction func Hint(_ sender: Any)
    {
        let ac = UIAlertController(title: title, message: "It starts with \(getPokemonName(id: actualPokemonId).first!)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac, animated: true)
    }
    
    @IBAction func Replay(_ sender: Any)
    {
        playCry()
    }
    
    @IBAction func Skip(_ sender: Any)
    {
        let ac = UIAlertController(title: title, message: "It was \(getPokemonName(id: actualPokemonId))!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: generateNewPokemon))
        present(ac, animated: true)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "Guess the Cry"
        
        getSavedData()
        
        if let levelFilePath = Bundle.main.path(forResource: "PokemonNames", ofType: "txt")
        {
            if let levelContents = try? String(contentsOfFile: levelFilePath)
            {
                let lines = levelContents.components(separatedBy: "\n")
                pokemonNames = lines
            }
        }
        
        print(startCountingPokemonFrom, pokemonToCount)
        
        for i in startCountingPokemonFrom ..< pokemonToCount
        {
            pokemonIdList.append(i)
        }
        
        shuffleList()
        
        actualPokemonId = pokemonIdList[0]
        
        playCry()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getSavedData()
    {
        startCountingPokemonFrom = defaults.object(forKey: "startCountNum") as! Int
        pokemonToCount = defaults.object(forKey: "endCountNum") as! Int
    }
    
    func shuffleList()
    {
        pokemonIdList = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: pokemonIdList) as! [Int]
        actualPokemonId = pokemonIdList[0]
    }
    
    func playCry()
    {
        let cryToPlay = String(format: "%03d", arguments: [actualPokemonId])
                
        guard let url = Bundle.main.url(forResource: "cries/\(cryToPlay)", withExtension: "wav") else { return }
        
        do
        {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            avPlayer = try AVAudioPlayer(contentsOf: url)
            guard let avPlayer = avPlayer else { return }
            
            avPlayer.play()
        }
        catch let error
        {
            print(error.localizedDescription)
        }
    }
    
    func getPokemonName(id: Int) -> String
    {
        return pokemonNames[id - 1];
    }
    
    func generateNewPokemon(action: UIAlertAction)
    {
        pokemonName.text = ""
        
        pokemonIdList.remove(at: 0)
        actualPokemonId = pokemonIdList[0]
        
        playCry()
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

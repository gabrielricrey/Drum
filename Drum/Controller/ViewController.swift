//
//  ViewController.swift
//  Drum
//
//  Created by Gabriel Richter Reynoso on 2019-01-07.
//  Copyright © 2019 Gabriel Richter Reynoso. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    
    @IBOutlet var kickArray: [UIButton]!
    @IBOutlet var snareArray: [UIButton]!
    @IBOutlet var hatArray: [UIButton]!
    var audioPlayer:AVAudioPlayer!
    var BPM = 120
    var timer:Timer?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
    
    
    @IBAction func buttonPressed1(_ sender: UIButton) {
        
        fillSoundButtonImages(sender)
        
        
        
    }
    
    @IBAction func playPausePressed(_ sender: UIButton) {
        
        changePlayButtonImage(sender)
        // play()
        // pause()
    }
    
    func fillSoundButtonImages(_ sender:UIButton) {
        
            sender.isSelected = !sender.isSelected
        }
        
    
    
    
    func changePlayButtonImage(_ sender:UIButton) {
        
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func bassSound(_ sender: UIButton) {
        
        let soundUrl = Bundle.main.url(forResource: "kick1", withExtension: "aif")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundUrl!)
        }
            
        catch {
            print(error)
        }
        
        audioPlayer.play()
        
    }
    
    @IBAction func snareSound(_ sender: UIButton) {
        
        let soundUrl = Bundle.main.url(forResource: "snare1", withExtension: "aif")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundUrl!)
        }
            
        catch {
            print(error)
        }
        
        audioPlayer.play()
        
    }
    
    @IBAction func hihatSound(_ sender: UIButton) {
        
        let soundUrl = Bundle.main.url(forResource: "hihat1", withExtension: "aif")
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundUrl!)
        }
            
        catch {
            print(error)
        }
        
        audioPlayer.play()
        
    }
}


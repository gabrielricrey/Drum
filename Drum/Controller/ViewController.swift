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
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var soundPropertiesView: UIView!
    @IBOutlet weak var bpmDisplay: UIView!
    @IBOutlet weak var volumeSlider: UISlider!
    
    let soundUrl1 = Bundle.main.url(forResource: "kick", withExtension: "wav")
    let soundUrl2 = Bundle.main.url(forResource: "snare", withExtension: "wav")
    let soundUrl3 = Bundle.main.url(forResource: "hihat", withExtension: "wav")
    
    var audioPlayer1: AVAudioPlayer!
    var audioPlayer2:AVAudioPlayer!
    var audioPlayer3:AVAudioPlayer!
    var volumeAudioPlayer1:Float = 0.5
    var volumeAudioPlayer2:Float = 0.5
    var volumeAudioPlayer3:Float = 0.5
    var index = 0
    var bpm = 120
    var timer:Timer?
    var i:Timer?
    
    var savedBeats = [String: [Bool]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        soundPropertiesView.isHidden = true
        soundPropertiesView.layer.cornerRadius = 20
        soundPropertiesView.layer.borderWidth = 1.0
        soundPropertiesView.layer.borderColor = UIColor.black.cgColor
        
        bpmDisplay.layer.borderWidth = 2
        bpmDisplay.layer.cornerRadius = 20
        
        bpmDisplay.backgroundColor = UIColor.red
        
        for i in 0 ... 15 {
            kickArray[i].layer.borderWidth = 2
            snareArray[i].layer.borderWidth = 2
            hatArray[i].layer.borderWidth = 2
        }
        
        if let b = audioPlayer1 {
            print(b.volume)
        }
        
    }
    
    @IBAction func decreaseBpmByOne(_ sender: UIButton) {
        
        if bpm > 60 {
            bpm -= 1
            bpmLabel.text = String(bpm)
        }
        
    }
    @IBAction func increaseBpmByOne(_ sender: UIButton) {
        if bpm < 150 {
            bpm += 1
            bpmLabel.text = String(bpm)
        }
        
    }
    @IBAction func increaseBpm(_ sender: UILongPressGestureRecognizer) {
        
        switch sender.state {
        case .began:
            i = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(ViewController.increaseBpmFast), userInfo: nil, repeats: true)
        case .ended:
            i?.invalidate()
        default:
            return
            
        }
    }
    
    @IBAction func decreaseBpm(_ sender: UILongPressGestureRecognizer) {
        
        switch sender.state {
        case .began:
            i = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(ViewController.decreaseBpmFast), userInfo: nil, repeats: true)
        case .ended:
            i?.invalidate()
        default:
            return
        }
    }
    
    @objc func increaseBpmFast() {
        if bpm < 150 {
            bpm += 1
            bpmLabel.text = String(bpm)
        }
    }
    @objc func decreaseBpmFast() {
        if bpm > 60 {
            bpm -= 1
            bpmLabel.text = String(bpm)
        }
    }
    
    @IBAction func buttonPressed1(_ sender: UIButton) {
        fillSoundButtonImages(sender)
    }
    
    @IBAction func playPausePressed(_ sender: UIButton) {
        changePlayButtonImage(sender)
        if sender.isSelected {
            play()
        } else {
            pause()
        }
    }
    
    func fillSoundButtonImages(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    func changePlayButtonImage(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func bassSound(_ sender: UIButton) {
        
        audioPlayer1.play()
    }
    
    @IBAction func snareSound(_ sender: UIButton) {
        
        audioPlayer2.play()
    }
    
    @IBAction func hihatSound(_ sender: UIButton) {
        
        audioPlayer3.play()
    }
    
    func play() {
        checkFilled()
    }
    
    func pause() {
        timer?.invalidate()
        if index > 0 {
            progressBarRestoreColor(index - 1)
        } else {
            progressBarRestoreColor(kickArray.count - 1)
        }
        index = 0
    }
    
    @objc func checkFilled() {
        timer?.invalidate()
        var lastIndex = 0
        
        if index > 0 {
            lastIndex = index - 1
        } else if index == 0 {
            lastIndex = kickArray.count - 1
        }
        
        progressBarRestoreColor(lastIndex)
        progressBarSetColor(index)
        
        
        if kickArray[index].isSelected {
            do {
                audioPlayer1 = try AVAudioPlayer(contentsOf: soundUrl1!)
                audioPlayer1.setVolume(volumeAudioPlayer1, fadeDuration: 0)
            }
            catch {
                print(error)
            }
            audioPlayer1.play()
            
        }
        
        if snareArray[index].isSelected {
            do {
                audioPlayer2 = try AVAudioPlayer(contentsOf: soundUrl2!)
                audioPlayer2.setVolume(volumeAudioPlayer2, fadeDuration: 0)
            }
            catch {
                print(error)
            }
            audioPlayer2.play()
        }
        
        if hatArray[index].isSelected {
            do {
                audioPlayer3 = try AVAudioPlayer(contentsOf: soundUrl3!)
                audioPlayer3.setVolume(volumeAudioPlayer3, fadeDuration: 0)
            }
            catch {
                print(error)
            }
            audioPlayer3.play()
        }
        
        if index < hatArray.count - 1 {
            index += 1
        } else {
            index = 0
        }
        
        timer = Timer.scheduledTimer(timeInterval: ((1.0/(Double(bpm)/60)) / 4), target: self, selector: #selector(ViewController.checkFilled), userInfo: nil, repeats: false)
        
    }
    
    func progressBarSetColor(_ index:Int) {
        
        kickArray[index].layer.borderColor = UIColor.red.cgColor
        snareArray[index].layer.borderColor = UIColor.red.cgColor
        hatArray[index].layer.borderColor = UIColor.red.cgColor
    }
    
    func progressBarRestoreColor(_ index:Int) {
        
        kickArray[index].layer.borderColor = UIColor.black.cgColor
        snareArray[index].layer.borderColor = UIColor.black.cgColor
        hatArray[index].layer.borderColor = UIColor.black.cgColor
    }
    
    var track:Int = 0
    @IBAction func showSoundPropertiesView(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            soundPropertiesView.isHidden = !soundPropertiesView.isHidden
        }
        
        if let b = sender.view?.tag {
            track = b
        }
        
    }
    
    @IBAction func hideSoundPropertiesView(_ sender: UITapGestureRecognizer) {
        soundPropertiesView.isHidden = true
    }
    
    
    @IBAction func changeVolume(_ sender: Any) {
        print(track)
        print(volumeSlider.value)
        switch track {
        case 50:
            
            volumeAudioPlayer1 = volumeSlider.value
            print("volume: \( audioPlayer1.volume)")
        case 51:
            
            volumeAudioPlayer2 = volumeSlider.value
        case 52:
            
            volumeAudioPlayer3 = volumeSlider.value
        default: return
        }
        
        
    }
    
    @IBAction func saveBeat(_ sender: UIButton) {
        var beats = [Bool]()
        
        
        for i in 0...47 {
            if i < 16 {
                if kickArray[i].isSelected {
                    beats.append(true)
                } else {
                    beats.append(false)
                }
            } else if i < 32 {
                if snareArray[i - 16].isSelected {
                    beats.append(true)
                } else {
                    beats.append(false)
                }
            } else {
                if hatArray[i - 32].isSelected {
                    beats.append(true)
                } else {
                    beats.append(false)
                }
            }
        }
        
        savedBeats["Test"] = beats
        UserDefaults.standard.set(savedBeats, forKey: "1")
        UserDefaults.standard.synchronize()
    }
    
    @IBAction func loadBeat(_ sender: UIButton) {
        reset(nil)
        let b = UserDefaults.standard.object(forKey: "1") as? [String:[Bool]]
        
        if let b = b {
            let beatsArray = b["Test"]
            if let beatsArray = beatsArray {
                
                
                
                for i in 0...47 {
                    if i < 16 {
                        if beatsArray[i] == true {
                            kickArray[i].isSelected = true
                        }
                    } else if i < 32 {
                        if beatsArray[i] == true {
                            snareArray[i - 16].isSelected = true
                        }
                        
                    } else {
                        if beatsArray[i] == true {
                            hatArray[i - 32].isSelected = true
                        }
                    }
                }
            }
        }
        
    }
    
    
    
    @IBAction func reset(_ sender: UIButton?) {
        for i in 0 ... 15 {
            kickArray[i].isSelected = false
            snareArray[i].isSelected = false
            hatArray[i].isSelected = false
        }
    }
    
}


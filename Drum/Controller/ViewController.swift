//
//  ViewController.swift
//  Drum
//
//  Created by Gabriel Richter Reynoso on 2019-01-07.
//  Copyright © 2019 Gabriel Richter Reynoso. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet var kickArray: [UIButton]!
    @IBOutlet var snareArray: [UIButton]!
    @IBOutlet var hatArray: [UIButton]!
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var volumeView: UIView!
    @IBOutlet weak var bpmDisplay: UIView!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var kickButton: UIButton!
    @IBOutlet weak var snareButton: UIButton!
    @IBOutlet weak var hatButton: UIButton!
    @IBOutlet weak var pickerViewView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    let soundUrl1 = Bundle.main.url(forResource: "kick", withExtension: "wav")
    let soundUrl2 = Bundle.main.url(forResource: "snare", withExtension: "wav")
    let soundUrl3 = Bundle.main.url(forResource: "hihat", withExtension: "wav")
    
    let nameString = NSLocalizedString("enter_beat_name", comment: "")
    let cancelString = NSLocalizedString("cancel", comment: "")
    
    var beatNameField:UITextField?
    var savedBeatsList = [String]()
    var audioPlayer1: AVAudioPlayer!
    var audioPlayer2:AVAudioPlayer!
    var audioPlayer3:AVAudioPlayer!
    
    var volumeAudioPlayer1:Float = 0.5
    var volumeAudioPlayer2:Float = 0.5
    var volumeAudioPlayer3:Float = 0.5
    var index = 0
    var bpm = 120
    var track:Int = 0
    var timer:Timer?
    var i:Timer?
    
    var savedBeats: [String: [Bool]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedBeats = UserDefaults.standard.object(forKey: "1") as? [String:[Bool]]
        if savedBeats == nil {
            savedBeats = [String: [Bool]]()
        }
        savedBeatsList = Array(savedBeats!.keys)
        print(savedBeatsList)
        
        
        volumeView.isHidden = true
        volumeView.layer.cornerRadius = 20
        volumeView.layer.borderWidth = 1.0
        volumeView.layer.borderColor = UIColor.black.cgColor
        
        pickerViewView.layer.borderWidth = 1.0
        pickerViewView.layer.borderColor = UIColor.black.cgColor
        
        bpmDisplay.layer.borderWidth = 2
        bpmDisplay.layer.cornerRadius = 20
        bpmDisplay.backgroundColor = UIColor.red
        
        for i in 0 ... 15 {
            kickArray[i].layer.borderWidth = 2
            snareArray[i].layer.borderWidth = 2
            hatArray[i].layer.borderWidth = 2
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
    
    @IBAction func volumeView(_ sender: UIButton) {
        volumeView.isHidden = !volumeView.isHidden
        addOrRemoveBorderFromChosenTrack(sender)
        track = sender.tag
        setSliderValueToAudioPlayerVolume()
        
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
    
    @IBAction func hideVolumeViewWhenTapAnyWhere(_ sender: UITapGestureRecognizer) {
        volumeView.isHidden = true
        removeBorderChosenTrack()
    }
    
    
    @IBAction func changeVolume(_ sender: Any) {
        
        switch track {
        case 50:
            volumeAudioPlayer1 = volumeSlider.value
        case 51:
            volumeAudioPlayer2 = volumeSlider.value
        case 52:
            volumeAudioPlayer3 = volumeSlider.value
        default: return
        }
    }
    
    @IBAction func displaySaveAlert(_ sender: UIButton) {
        
        
        
        let saveAlert = UIAlertController(title: nameString, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: self.saveBeat)
        let cancelAction = UIAlertAction(title: cancelString, style: .cancel, handler: nil)
        saveAlert.addTextField(configurationHandler: beatTextField)
        saveAlert.addAction(okAction)
        saveAlert.addAction(cancelAction)
        self.present(saveAlert, animated: true)
        
    }
    
    func saveBeat(alert: UIAlertAction) {
        
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
        
        if let beatNameField = beatNameField {
            if let beatNameField = beatNameField.text {
                savedBeats![beatNameField] = beats
                savedBeatsList = Array(savedBeats!.keys)
                 print("\(beatNameField)")
            }
        }
        

        UserDefaults.standard.set(savedBeats, forKey: "1")
        UserDefaults.standard.synchronize()
        
    }
    
    func beatTextField(textfield: UITextField) {
        beatNameField = textfield
        // beatNameField?.placeholder = "..."
    }
    
    @IBAction func displayLoadPickerView(_ sender: UIButton) {
        pickerViewView.isHidden = false
        pickerView.delegate = self

    }
    
    @IBAction func hidePickerView(_ sender: UIBarButtonItem) {
        pickerViewView.isHidden = true
    }
    
    
    @IBAction func reset(_ sender: Any) {
        for i in 0 ... 15 {
            kickArray[i].isSelected = false
            snareArray[i].isSelected = false
            hatArray[i].isSelected = false
        }
    }
    func addOrRemoveBorderFromChosenTrack(_ sender:UIButton) {
        if volumeView.isHidden == false {
            addBorderChosenTrack(sender)
        } else {
            removeBorderChosenTrack()
        }
    }
    func addBorderChosenTrack(_ sender:UIButton) {
        sender.layer.borderWidth = 2
        sender.layer.cornerRadius = 14
        sender.layer.borderColor = UIColor.red.cgColor
    }
    
    func removeBorderChosenTrack() {
        kickButton.layer.borderWidth = 0
        snareButton.layer.borderWidth = 0
        hatButton.layer.borderWidth = 0
        
    }
    
    func setSliderValueToAudioPlayerVolume() {
        
        switch track {
        case 50:
            do {
                audioPlayer1 = try AVAudioPlayer(contentsOf: soundUrl1!)
                audioPlayer1.setVolume(volumeAudioPlayer1, fadeDuration: 0)
            }
            catch {
                print(error)
            }
            volumeSlider.value = audioPlayer1.volume
        case 51:
            do {
                audioPlayer2 = try AVAudioPlayer(contentsOf: soundUrl2!)
                audioPlayer2.setVolume(volumeAudioPlayer2, fadeDuration: 0)
            }
            catch {
                print(error)
            }
            volumeSlider.value = audioPlayer2.volume
        case 52:
            do {
                audioPlayer3 = try AVAudioPlayer(contentsOf: soundUrl3!)
                audioPlayer3.setVolume(volumeAudioPlayer3, fadeDuration: 0)
            }
            catch {
                print(error)
            }
            volumeSlider.value = audioPlayer3.volume
        default: return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return savedBeatsList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return savedBeatsList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        reset(pickerView)
        let b = savedBeats
        
        if let b = b {
            let beatsArray = b[savedBeatsList[row]]
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
    
}


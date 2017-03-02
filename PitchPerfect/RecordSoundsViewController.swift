//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Nikko on 2/28/17.
//  Copyright © 2017 Nikko Sanchez. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController {

    let toPlaySoundsViewController = "toPlaySoundsViewController"
    
    var audioRecorder: AVAudioRecorder?
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    @IBAction func recordAudio(_ sender: UIButton) {
        recordingLabel.text = "Recording in Progress"
        stopRecordingButton.isEnabled = true
        recordingButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        guard let filePath = URL(string: pathArray.joined(separator: "/")) else { return }
        print(filePath)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath, settings: [:])
        audioRecorder?.delegate = self
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.prepareToRecord()
        audioRecorder?.record()
    }

    @IBAction func stopRecording(_ sender: UIButton) {
        recordingLabel.text = "Tap To Record"
        stopRecordingButton.isEnabled = false
        recordingButton.isEnabled = true
        audioRecorder?.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    func setupUI() {
        stopRecordingButton.isEnabled = false
        recordingButton.layer.cornerRadius = recordingButton.bounds.width / 2
        recordingButton.clipsToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == toPlaySoundsViewController {
            guard let controller = segue.destination as? PlaySoundsViewController else { return }
            controller.recordedAudioURL = audioRecorder?.url
        }
    }
}

extension RecordSoundsViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: toPlaySoundsViewController, sender: audioRecorder?.url)
        } else {
            print("recording failed")
        }
    }
}


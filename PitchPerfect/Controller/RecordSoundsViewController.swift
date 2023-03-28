//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by João Ponte on 25/03/2023.
//

////Remember that protocols act as a kind of contract. AVAudioRecorder does not know what classes you have in your app. However, if you say that your class conforms to the AVAudioRecorderDelegate protocol, then it knows it can call a specific function in your class.
//
//The specific function has been defined in the protocol (in this case, the AVAudioRecorderDelegate protocol). This way your class and the AVAudioRecorder are loosely coupled, and they can work together without having to know much about each other.
//
//Loose coupling of classes is really useful in building interchangeable pieces of code, and used quite a lot in iOS.

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        stopRecordingButton.alpha = 0.5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stopRecordingButton.isEnabled = false
        stopRecordingButton.alpha = 0.5
        
    }
    func configureUI(isRecording: Bool) {
        recordingLabel.text = isRecording ? "Recording in Progress" : "Tap to Record"
        recordButton.isEnabled = !isRecording
        stopRecordingButton.isEnabled = isRecording
        recordButton.alpha = isRecording ? 0.5 : 1
        stopRecordingButton.alpha = isRecording ? 1 : 0.5
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(isRecording: true)

        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(isRecording: false)

        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
            
        } else {
            print("recording was not successful")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

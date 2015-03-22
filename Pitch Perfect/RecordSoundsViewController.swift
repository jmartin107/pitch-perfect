//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jeffrey Martin on 3/5/15.
//  Copyright (c) 2015 Jeffrey Martin. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var isRecordingPaused = false

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        recordButton.enabled = true
        pauseRecordingButton.hidden = true
        
        setPauseButtonImage("pause")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pauseButton(sender: UIButton) {
        // If the recording is paused and this button is tapped we want to resume the recording
        //setRecordingState()
        
        if(isRecordingPaused) {
            isRecordingPaused = false
            recordingInProgress.text = "Recording In Progress"
            audioRecorder.record()
            
            setPauseButtonImage("pause")
        } else {
            isRecordingPaused = true
            recordingInProgress.text = "Recording Paused"
            audioRecorder.pause()
            
            setPauseButtonImage("resume")
        }
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        println("in recordAudio")
        
        toggleRecordingInProgressText(true)
        
        stopButton.hidden = false
        pauseRecordingButton.hidden = false
        recordButton.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error:nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings:nil, error:nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
       
    }
    
    func setRecordingState() {
        
        if(isRecordingPaused) {
            pauseRecordingButton.setTitle("Resume", forState: .Normal)
            audioRecorder.pause()
        } else {
            pauseRecordingButton.setTitle("Pause", forState: .Normal)
            audioRecorder.record()
        }
        
        isRecordingPaused = !isRecordingPaused
    }
    
    
    func setPauseButtonImage(image: String) {
        var buttonImage = UIImage(named:image)
        pauseRecordingButton.setImage(buttonImage, forState: .Normal)

    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    @IBAction func stopRecording(sender: UIButton) {
        toggleRecordingInProgressText(false)
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false,error: nil)
    }
    
    func toggleRecordingInProgressText(isRecording: Bool) {
        let recordingText = "Recording in Progress"
        let idleText = "Tap to Record"
        
        recordingInProgress.text = isRecording ? recordingText : idleText
    }
}


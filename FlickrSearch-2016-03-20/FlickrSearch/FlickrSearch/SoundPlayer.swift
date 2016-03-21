//
//  SoundPlayer.swift
//  FlickrSearch
//
//  Created by Aravind Ashok kumar on 11/8/15.
//  Copyright (c) 2015 ISS. All rights reserved.
//

import Foundation

import AVFoundation

class SoundPlayer {
    
    // Singleton in order to access the player from 'everywhere'
    class var sharedInstance : SoundPlayer {
        struct Static {
            static let instance : SoundPlayer = SoundPlayer()
        }
        return Static.instance
    }
    
    // Properties
    var error:NSError?
    var audioPlayer = AVAudioPlayer()
    let soundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("RelaxingPiano", ofType: "mp3")!) // Working
    //let soundURL = NSURL(string:"/System/Library/Audio/UISounds/sms-received1.caf") // Working too
    
    init() {
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        audioPlayer = AVAudioPlayer(contentsOfURL: soundURL, error: &error)
        audioPlayer.volume=0.5
        if (error != nil) {
            println("[SoundPlayer] There was an error: \(error)")
        }
        //        else {
        //            audioPlayer.prepareToPlay()
        //        }
    }
    
    func playSound() {
        if (audioPlayer.playing) {
            audioPlayer.stop()
        }
        audioPlayer.play()
    }
    func stopPlaying()
    {
        if (audioPlayer.playing) {
            audioPlayer.stop()
        }
        
    }
}
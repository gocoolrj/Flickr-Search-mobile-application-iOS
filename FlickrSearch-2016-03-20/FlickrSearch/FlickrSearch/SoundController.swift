//
//  SoundController.swift
//  FlickrSearch
//
//  Created by Aravind Ashok kumar on 12/8/15.
//  Copyright (c) 2015 ISS. All rights reserved.
//

import UIKit


class SoundController: UIViewController{

    
    @IBAction func playMusic(sender: AnyObject)
    {
        SoundPlayer.sharedInstance.playSound()
    }
    @IBOutlet weak var sliderSoundValue: UISlider!
    
    @IBAction func adjustVolume(sender: AnyObject)
    {
        let valueofVolume:Float = Float(sliderSoundValue.value)
        SoundPlayer.sharedInstance.audioPlayer.volume = valueofVolume;
        
    }
    
    @IBAction func stopMusic(sender: AnyObject)
    {
        SoundPlayer.sharedInstance.stopPlaying()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

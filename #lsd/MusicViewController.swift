//
//  FirstViewController.swift
//  #lsd
//
//  Created by Manu Chopra on 3/1/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation
import LocalAuthentication

class FirstViewController: UIViewController,
MPMediaPickerControllerDelegate, AVAudioPlayerDelegate, UIAlertViewDelegate {
    
    var swipeRecognizer1: UISwipeGestureRecognizer!
    var swipeRecognizer2: UISwipeGestureRecognizer!
    var className = ""

    required init(coder aDecoder: NSCoder) { //Initializes the 2 swipe recognizers and their relevant action.
        super.init(coder: aDecoder)
        swipeRecognizer1 = UISwipeGestureRecognizer(target: self,
            action: "handleSwipes:")
        swipeRecognizer2 = UISwipeGestureRecognizer(target: self,
            action: "handleSwipes:")
    }

    var moviePlayer:MPMoviePlayerController!
    var myMusicPlayer: MPMusicPlayerController?
    var buttonPickAndPlay: UIButton?
    var buttonStopPlaying: UIButton?
    var mediaPicker: MPMediaPickerController?
    var teamName = ""
    
    func authenticateUser() { //This function is called to authenticate the user
        let context = LAContext()
        var error: NSError?
        
        var reasonString = "Your fingerprint will be mapped to a unique password."
        
        //USING TOUCH ID API
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            [context .evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
                
                if success {
                }
                else{ //failure case
                    switch evalPolicyError!.code {
                        
                    case LAError.UserFallback.rawValue://user decides to type the password again
                        self.showPasswordAlert()
                        
                    default:
                        self.showPasswordAlert()
                    }
                }
                
            })]
        }
        else{ //This option is to be used for non- Touch ID hardware or simulators
            
            self.showPasswordAlert()
        }
    }
    
    func showPasswordAlert() { //This is the fallback option if TouchId doesn't work.
        let login = LoginViewController()
        if login.isNew() { //if user is a dancer
            var passwordAlert : UIAlertView = UIAlertView(title: "Larkin Silent Dance", message: "Create a team name", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Okay")
            passwordAlert.alertViewStyle = UIAlertViewStyle.SecureTextInput
            passwordAlert.show()
        } else { //if user is an RA
            var passwordAlert : UIAlertView = UIAlertView(title: "Larkin Silent Dance", message: "Enter your team name. If you don't have one - Ask your RA. If you are an RA or a CS 193P TA, create a new team name.", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Okay")
            passwordAlert.alertViewStyle = UIAlertViewStyle.SecureTextInput
            passwordAlert.show()
        }
    }

    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {// This function describes the alert view and pushes the name of the class to Parse.
        if buttonIndex == 1 {
            if !alertView.textFieldAtIndex(0)!.text.isEmpty { //check if entered class is not empty
                className = alertView.textFieldAtIndex(0)!.text
            var object = PFObject(className: alertView.textFieldAtIndex(0)!.text)
            object.saveInBackground()
            }
        }
    }
    
    @IBOutlet weak var pause: UIButton! //PauseUI button

    @IBOutlet weak var play: UIButton! //Play UI button
    
    @IBAction func choose(sender: UIButton) { //Choose your song list.
        displayMedia()
        view.addSubview(sender)
        play.hidden = true //hides the play button
        pause.hidden = false //shows the pause button
    }
    
    @IBAction func clickedPlay(sender: UIButton) { //Called when user hits the play button
        view.addSubview(sender)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        if let player = myMusicPlayer{
            player.play()
        }

        play.hidden = true
        pause.hidden = false
    }
    
    func handleSwipes(sender: UISwipeGestureRecognizer){ // Called when user swipes. If you swipe left, decreases volume else increases volume
        
        if sender.direction == .Left{ //Left Swipe
            println("Swiped Left")
            if let player = myMusicPlayer{
                var volumeView = MPVolumeView()
                self.view.addSubview(volumeView)
            }
        }
        if sender.direction == .Right{ //Right Swipe
            println("Swiped Right")
        }
    }
    
    @IBAction func clickedPause(sender: UIButton) { //Pause is clicked
        pause.hidden = true
        play.hidden = false
        NSNotificationCenter.defaultCenter().removeObserver(self)
        if let player = myMusicPlayer{
            player.pause()
        }
        view.addSubview(sender)
    }
    
    
    func mediaPicker(mediaPicker: MPMediaPickerController!,
        didPickMediaItems mediaItemCollection: MPMediaItemCollection!){
            
            myMusicPlayer = MPMusicPlayerController()
            
            if let player = myMusicPlayer{
                player.beginGeneratingPlaybackNotifications()
                player.setQueueWithItemCollection(mediaItemCollection) //play items in chosen collection
                player.play()
                
                mediaPicker.dismissViewControllerAnimated(true, completion: nil) //dismiss
                
            }
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController!) { //Canceling the media picker
        mediaPicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
        
    func displayMedia(){ //This function displays the media
        
        mediaPicker = MPMediaPickerController(mediaTypes: .AnyAudio)
        
        if let picker = mediaPicker{
            
            picker.delegate = self
            picker.allowsPickingMultipleItems = true
            view.addSubview(picker.view)
            presentViewController(picker, animated: true, completion: nil)
            
        } else {
            println("Error - Could not build the media picker")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateUser()
        //Swipes that are performed from right to
        //left are to be detected
        swipeRecognizer1.direction = .Left
        swipeRecognizer2.direction = .Right
        
        swipeRecognizer1.numberOfTouchesRequired = 1
        swipeRecognizer2.numberOfTouchesRequired = 1
        
        // Add it to the view 
        view.addGestureRecognizer(swipeRecognizer1)
        view.addGestureRecognizer(swipeRecognizer2)

        self.navigationController!.navigationBar.topItem!.title = "Login"
        pause.hidden = true
        title = "Play"
        UITabBar.appearance().barTintColor = UIColor.blackColor()
    }
}

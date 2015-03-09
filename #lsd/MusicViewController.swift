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
    
    required init(coder aDecoder: NSCoder) {
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
    
    
    func authenticateUser() {
        // Get the local authentication context.
        let context = LAContext()
        
        // Declare a NSError variable.
        var error: NSError?
        
        // Set the reason string that will appear on the authentication alert.
        var reasonString = "Authentication is needed to access your notes."
        
        // Check if the device can evaluate the policy.
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            [context .evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
                
                if success {
                    println("Success")
                }
                else{
                    // If authentication failed then show a message to the console with a short description.
                    // In case that the error is a user fallback, then show the password alert view.
                    println(evalPolicyError?.localizedDescription)
                    
                    switch evalPolicyError!.code {
                        
                    case LAError.SystemCancel.rawValue:
                        println("Authentication was cancelled by the system")
                        
                    case LAError.UserCancel.rawValue:
                        println("Authentication was cancelled by the user")
                        
                    case LAError.UserFallback.rawValue:
                        println("User selected to enter custom password")
                        self.showPasswordAlert()
                        
                    default:
                        println("Authentication failed")
                        self.showPasswordAlert()
                    }
                }
                
            })]
        }
        else{
            // If the security policy cannot be evaluated then show a short message depending on the error.
            switch error!.code{
                
            case LAError.TouchIDNotEnrolled.rawValue:
                println("TouchID is not enrolled")
                
            case LAError.PasscodeNotSet.rawValue:
                println("A passcode has not been set")
                
            default:
                // The LAError.TouchIDNotAvailable case.
                println("TouchID not available")
            }
            
            // Optionally the error description can be displayed on the console.
            println(error?.localizedDescription)
            
            // Show the custom alert view to allow users to enter the password.
            self.showPasswordAlert()
        }
    }
    
    func showPasswordAlert() {
        var passwordAlert : UIAlertView = UIAlertView(title: "Larkin Silent Dance", message: "Please type your password", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Okay")
        passwordAlert.alertViewStyle = UIAlertViewStyle.SecureTextInput
        passwordAlert.show()
    }

    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            if !alertView.textFieldAtIndex(0)!.text.isEmpty {
                if alertView.textFieldAtIndex(0)!.text == "appcoda" {
                    
                }
                else{
                    showPasswordAlert()
                }
            }
            else{
                showPasswordAlert()
            }
        }
    }

    
    @IBOutlet weak var pause: UIButton!

    @IBOutlet weak var play: UIButton!
    
    @IBAction func choose(sender: UIButton) {
        displayMediaPickerAndPlayItem()
        view.addSubview(sender)
        play.hidden = true
        pause.hidden = false
    }
    
    @IBAction func clickedPlay(sender: UIButton) {
        println("Clicked Play")
        view.addSubview(sender)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        if let player = myMusicPlayer{
            player.play()
        }

        play.hidden = true
        pause.hidden = false
        // add video from instagram
        
        var screenWidth = self.view.frame.width
        var screenHeight = view.frame.height
}
    
    
    func handleSwipes(sender: UISwipeGestureRecognizer){
        
        if sender.direction  == .Down{
            println("Swiped Down")
        }
        if sender.direction == .Left{
            println("Swiped Left")
            if let player = myMusicPlayer{
//                var volumeView = MPVolumeView(frame : CGRect(origin:CGPoint(x: 0.0, y: 0.0), size: view.frame.size))
//                self.view.addSubview(volumeView)
            }

        }
        if sender.direction == .Right{
            println("Swiped Right")
        }
        if sender.direction == .Up{
            println("Swiped Up")
        }
        
    }
    

    @IBAction func clickedPause(sender: UIButton) {
        println("Clicked Pause")
        pause.hidden = true
        play.hidden = false
        stopPlayingAudio()
        view.addSubview(sender)
    }
    
    func musicPlayerStateChanged(notification: NSNotification){
        
        /* Let's get the state of the player */
        let stateAsObject =
        notification.userInfo!["MPMusicPlayerControllerPlaybackStateKey"]
            as? NSNumber
        
        if let state = stateAsObject{
            
            /* Make your decision based on the state of the player */
            switch MPMusicPlaybackState(rawValue: state.integerValue)!{
            case .Stopped:
                /* Here the media player has stopped playing the queue. */
                println("Stopped")
            case .Playing:
                /* The media player is playing the queue. Perhaps you
                can reduce some processing that your application
                that is using to give more processing power
                to the media player */
                println("Played")
            case .Paused:
                /* The media playback is paused here. You might want
                to indicate by showing graphics to the user */
                println("Paused")
            case .Interrupted:
                /* An interruption stopped the playback of the media queue */
                println("Interrupted")
            case .SeekingForward:
                /* The user is seeking forward in the queue */
                println("Seeking Forward")
            case .SeekingBackward:
                /* The user is seeking backward in the queue */
                println("Seeking Backward")
            }
            
        }
    }
    
    func nowPlayingItemIsChanged(notification: NSNotification){
        
        println("Playing Item Is Changed")
        
        let key = "MPMusicPlayerControllerNowPlayingItemPersistentIDKey"
        
        let persistentID =
        notification.userInfo![key] as? NSString
        
        if let id = persistentID{
            /* Do something with Persistent ID */
            println("Persistent ID = \(id)")
        }
        
    }
    
    func volumeIsChanged(notification: NSNotification){
        println("Volume Is Changed")
        /* The userInfo dictionary of this notification is normally empty */
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController!,
        didPickMediaItems mediaItemCollection: MPMediaItemCollection!){
            
            println("Media Picker returned")
            
            /* Instantiate the music player */
            
            myMusicPlayer = MPMusicPlayerController()
            
            if let player = myMusicPlayer{
                player.beginGeneratingPlaybackNotifications()
                
                /* Get notified when the state of the playback changes */
                NSNotificationCenter.defaultCenter().addObserver(self,
                    selector: "musicPlayerStateChanged:",
                    name: MPMusicPlayerControllerPlaybackStateDidChangeNotification,
                    object: nil)
                
                /* Get notified when the playback moves from one item
                to the other. In this recipe, we are only going to allow
                our user to pick one music file */
                NSNotificationCenter.defaultCenter().addObserver(self,
                    selector: "nowPlayingItemIsChanged:",
                    name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification,
                    object: nil)
                
                /* And also get notified when the volume of the
                music player is changed */
                NSNotificationCenter.defaultCenter().addObserver(self,
                    selector: "volumeIsChanged:",
                    name: MPMusicPlayerControllerVolumeDidChangeNotification,
                    object: nil)
                
                /* Start playing the items in the collection */
                player.setQueueWithItemCollection(mediaItemCollection)
                player.play()
                
                /* Finally dismiss the media picker controller */
                mediaPicker.dismissViewControllerAnimated(true, completion: nil)
                
            }
            
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController!) {
        /* The media picker was cancelled */
        println("Media Picker was cancelled")
        mediaPicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func stopPlayingAudio(){
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        if let player = myMusicPlayer{
            player.pause()
        }
        
    }
    
    func displayMediaPickerAndPlayItem(){
        
        mediaPicker = MPMediaPickerController(mediaTypes: .AnyAudio)
        
        if let picker = mediaPicker{
            
            println("Successfully instantiated a media picker")
            picker.delegate = self
            picker.allowsPickingMultipleItems = true
            view.addSubview(picker.view)
            presentViewController(picker, animated: true, completion: nil)
            
        } else {
            println("Could not instantiate a media picker")
        }
    }
    
    func createTeam(){
        var inputTextField: UITextField?
        let alertController = UIAlertController(title: "Larkin Silent Dance", message: "Give your dance party a name.", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            // Do whatever you want with inputTextField?.text
            self.teamName = "\(inputTextField!.text)"
            println(self.teamName)
        })
        alertController.addAction(ok)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            inputTextField = textField
        }
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  createTeam()
        /* Swipes that are performed from right to
        left are to be detected */
        swipeRecognizer1.direction = .Left
        swipeRecognizer2.direction = .Right
        
        /* Just one finger needed */
        swipeRecognizer1.numberOfTouchesRequired = 1
        swipeRecognizer2.numberOfTouchesRequired = 1
        
        /* Add it to the view */
        view.addGestureRecognizer(swipeRecognizer1)
        view.addGestureRecognizer(swipeRecognizer2)

        self.navigationController!.navigationBar.topItem!.title = "Login"
        pause.hidden = true
        title = "Play"
        UITabBar.appearance().barTintColor = UIColor.blackColor()
    }
}

//
//  WallViewController.swift
//  #lsd
//
//  Created by Manu Chopra on 3/9/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MediaPlayer
import MobileCoreServices


class WallViewController : UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var moviePlayer:MPMoviePlayerController!
    var activityViewController:UIActivityViewController!
    var buttonShare:UIButton!

    @IBOutlet weak var camera: UIBarButtonItem!
    var string2:String = "http://manuchopra.in/video.mp4"
    var url:NSURL? = NSURL(string: "http://manuchopra.in/video.mp4")
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBAction func videoAction(sender: UIButton) { //This function is called when user decides to take a new video
        
        if isCameraAvailable() { //check if camera is available
            
            controller = UIImagePickerController()
            
            if let video = controller{
                video.sourceType = .Camera
                video.mediaTypes = [kUTTypeMovie as String]
                video.delegate = self
                video.videoMaximumDuration = 6 //It's the Vine generation - Only 6 sec videos allowed.
                presentViewController(video, animated: true, completion: nil)
            }
            
        } else {
            println("No cameraaa, No videeeeooo")
        }
        
    }
    
    var controller: UIImagePickerController?
    
    func isCameraAvailable() -> Bool{ //checks if camera is available
        return UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){ //Called to save the shot image to camera roll automatically
            
        let mediaType:AnyObject? = info[UIImagePickerControllerMediaType]
        if let type:AnyObject = mediaType{
            
            if type is String{
                let stringType = type as String
                if stringType == kUTTypeImage as String{
                    var theImage: UIImage!
                    theImage = info[UIImagePickerControllerOriginalImage] as UIImage
                    let selectorToCall = Selector("imageWasSavedSuccessfully:didFinishSavingWithError:context:")
                    UIImageWriteToSavedPhotosAlbum(theImage,self,selectorToCall,nil)
                }
            }
        }
            picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func photoAction(sender: UIButton) { //Called when user clicks camera button
        
        if isCameraAvailable(){
            
            controller = UIImagePickerController()
            
            if let pic = controller{
                pic.sourceType = .Camera
                pic.mediaTypes = [kUTTypeImage as String]
                pic.delegate = self
                
                presentViewController(pic, animated: true, completion: nil)
            }
            
        } else {
            println("Camera is not available")
        }
        
    }
    
    @IBAction func shareAction(sender: UIButton) { //Brings up the share sheet
        var string2:String = "http://manuchopra.in/video.mp4"
        var url:NSURL? = NSURL(string: "http://manuchopra.in/video.mp4")
        
        var urlString = "OMG! #lsd was so much fun. Just look at this - " + "\(string2)"
        
        activityViewController = UIActivityViewController(
            activityItems: [urlString as NSString],
            applicationActivities: nil)
        
        presentViewController(activityViewController,
            animated: true,
            completion: {
        })

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var screenWidth = self.view.frame.width
        var screenHeight = view.frame.height
 
        moviePlayer = MPMoviePlayerController(contentURL: url)
        moviePlayer.view.frame = CGRectMake(0, 0, screenWidth, screenHeight/3)
        self.view.addSubview(moviePlayer.view)
        moviePlayer.fullscreen = true
        moviePlayer.allowsAirPlay = true
        moviePlayer.controlStyle = MPMovieControlStyle.Embedded
        moviePlayer.scalingMode = MPMovieScalingMode.None
        moviePlayer.repeatMode = MPMovieRepeatMode.One
        moviePlayer.shouldAutoplay = true
        moviePlayer.view.alpha = 0.8
    }
    
}
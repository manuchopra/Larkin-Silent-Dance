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
    
    @IBAction func videoAction(sender: UIButton) {
        
        if isCameraAvailable() {
            
            controller = UIImagePickerController()
            
            if let theController = controller{
                theController.sourceType = .Camera
                theController.mediaTypes = [kUTTypeMovie as String]
                theController.allowsEditing = true
                theController.delegate = self
                theController.videoMaximumDuration = 6
                presentViewController(theController, animated: true, completion: nil)
            }
            
        } else {
            println("Camera is not available")
        }
        
    }
    
    var controller: UIImagePickerController?
    
    func isCameraAvailable() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
            
        let mediaType:AnyObject? = info[UIImagePickerControllerMediaType]
        if let type:AnyObject = mediaType{
            
            if type is String{
                let stringType = type as String
                if stringType == kUTTypeImage as String{
                    var theImage: UIImage!
                    if picker.allowsEditing{
                        theImage = info[UIImagePickerControllerEditedImage] as UIImage
                    } else {
                        theImage = info[UIImagePickerControllerOriginalImage] as UIImage
                    }
                    let selectorAsString =
                    "imageWasSavedSuccessfully:didFinishSavingWithError:context:"
                    let selectorToCall = Selector(selectorAsString)
                    UIImageWriteToSavedPhotosAlbum(theImage,self,selectorToCall,nil)
                }
            }
        }
            picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func photoAction(sender: UIButton) {
        
        if isCameraAvailable(){
            
            controller = UIImagePickerController()
            
            if let theController = controller{
                theController.sourceType = .Camera
                theController.mediaTypes = [kUTTypeImage as String]
                theController.allowsEditing = true
                theController.delegate = self
                
                presentViewController(theController, animated: true, completion: nil)
            }
            
        } else {
            println("Camera is not available")
        }
        
    }
    
    @IBAction func shareAction(sender: UIButton) {
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
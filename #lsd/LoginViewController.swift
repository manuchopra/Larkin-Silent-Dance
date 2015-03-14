//
//  LoginViewController.swift
//  #lsd
//
//  Created by Manu Chopra on 3/4/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation


class LoginViewController : UIViewController {

    @IBOutlet weak var button2: UIButton!
    var player : AVAudioPlayer! = nil
    var newLSD : Bool = false
        
    @IBOutlet weak var button1: UIButton!
    @IBAction func button2clicked(sender: UIButton) {
        newLSD = true
        println("true")
    }
    
    func isNew() -> Bool {
        println("returning " + "\(newLSD)")
        return newLSD
    }
    
    override func viewDidLoad() {
        let path = NSBundle.mainBundle().pathForResource("music", ofType:"mp3")
        let fileURL = NSURL(fileURLWithPath: path!)
        player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
        player.prepareToPlay()
        player.play()
        
        var filePath = NSBundle.mainBundle().pathForResource("gif3", ofType: "gif")
        var gif = NSData(contentsOfFile: filePath!)
        
        var webViewBG = UIWebView(frame: CGRect(origin:CGPoint(x: 0.0, y: 0.0), size: view.frame.size))
        webViewBG.loadData(gif, MIMEType: "image/gif", textEncodingName: nil, baseURL: nil)
        webViewBG.userInteractionEnabled = false;
        self.view.addSubview(webViewBG)
        
        var filter = UIView()
        filter.frame = self.view.frame
        filter.backgroundColor = UIColor.blackColor()
        filter.alpha = 0.05
        self.view.addSubview(filter)

       view.bringSubviewToFront(button1)
        view.bringSubviewToFront(button2)
    }

}
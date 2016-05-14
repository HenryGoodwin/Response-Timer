//
//  ResponceTimerVC.swift
//  Reflexes
//
//  Created by Henry Goodwin on 1/05/2016.
//  Copyright © 2016 Henry Goodwin. All rights reserved.
//

import UIKit
import iAd

class ResponceTimerVC: UIViewController, ADBannerViewDelegate {

    var timer:NSTimer = NSTimer()
    var startTime = NSTimeInterval()
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    
    var high: Int! = 6000
    var seconds: Int!
    var fraction: Int!
    
    var strSeconds: String!
    var strFraction: String!
    
    var strSecs: String!
    var strFrac: String!
    
    var score: Int!
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var startStopBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var FlashView: UIView!
    @IBOutlet var adBannerView: ADBannerView?
    @IBOutlet weak var highscoreLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.canDisplayBannerAds = true
        self.adBannerView?.delegate = self
        self.adBannerView?.hidden = true
        
        
        clearBtn.alpha = DIM_ALPHA
        clearBtn.enabled = false
        
        FlashView.hidden = true
        FlashView.backgroundColor = UIColor.GrayBG()
        
        label.hidden = true
        
        let fractionDefults = NSUserDefaults.standardUserDefaults()
        let secondDefults = NSUserDefaults.standardUserDefaults()
        let highscoreDefults = NSUserDefaults.standardUserDefaults()
        
        if (fractionDefults.valueForKey("Mil") != nil){
            
            high = highscoreDefults.valueForKey("HighScore") as! Int!
            strSecs = secondDefults.valueForKey("Seconds") as! String
            strFrac = fractionDefults.valueForKey("Miliseconds") as! String
            highscoreLbl.text = "Highscore: \(strSecs):\(strFrac)"
        }

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startFlash() {
        
        FlashView.backgroundColor = UIColor.Orange()
        
        startStopBtn.enabled = true
        startStopBtn.alpha = OPAQUE
        
        let aSelector : Selector = #selector(ResponceTimerVC.updateTime)
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
        startTime = NSDate.timeIntervalSinceReferenceDate()
        
        clearBtn.enabled = false
        clearBtn.alpha = DIM_ALPHA

        
    }
    
    @IBAction func alertBtn(sender: UIButton) {
        
        let alertView = UIAlertController(title: "Responce Timer", message: "Press Stop When the Orange Flash Appears", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertView, animated: true, completion: nil)
        
    }
    
    
    @IBAction func startStopTimer(sender: UIButton) {
        
            let random = Double(arc4random_uniform(9))
        
        if (!timer.valid) {
            
            
            FlashView.hidden = false
            FlashView.backgroundColor = UIColor.GrayBG()
            
            startStopBtn.setTitle("Stop", forState: UIControlState.Normal)
            
            startStopBtn.alpha = DIM_ALPHA
            startStopBtn.enabled = false
            
            if FlashView.backgroundColor == UIColor.GrayBG() {
                
                delay(random, closure: { () -> () in
                    self.startFlash()
                })
            }
            
        } else if (timer.valid) {
            
            invalidate()
            
    }
    }
    
    func invalidate() {
        
        startStopBtn.setTitle("Start", forState: UIControlState.Normal)
        timer.invalidate()
        
        label.hidden = false
        
        FlashView.hidden = true
        
        startStopBtn.enabled = false
        clearBtn.enabled = true
        
        clearBtn.alpha = OPAQUE
        startStopBtn.alpha = DIM_ALPHA
        
        if (score < high) {
            
            high = score
            strSecs = strSeconds
            strFrac = strFraction
            
            highscoreLbl.text = "Highscore: \(strSecs):\(strFrac)"
            
            let secondsDefults = NSUserDefaults.standardUserDefaults()
            secondsDefults.setValue(strSecs, forKey: "Seconds")
            secondsDefults.synchronize()
            
            let highscoreDefults = NSUserDefaults.standardUserDefaults()
            highscoreDefults.setValue(high, forKey: "HighScore")
            highscoreDefults.synchronize()
            
            let minutesDefults = NSUserDefaults.standardUserDefaults()
            minutesDefults.setValue(strFrac, forKey: "Miliseconds")
            minutesDefults.synchronize()
        }
        
        

        
    }
    
    @IBAction func clear(sender: UIButton) {
        
        label.text = "00:00"
        startStopBtn.enabled = true
        startStopBtn.alpha = OPAQUE
        
        clearBtn.enabled = false
        clearBtn.alpha = DIM_ALPHA
        
        label.hidden = true
        
    }

    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        //calculate the minutes in elapsed time.
        
        
        //calculate the seconds in elapsed time.
        seconds = Int(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        fraction = Int(elapsedTime * 10000)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        
        strSeconds = String(format: "%02d", seconds)
        strFraction = String(format: "%04d", fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        label.text = "\(strSeconds):\(strFraction)"
        
        score = ((seconds * 10000) + Int(fraction))
        
        if label.text == "59:59" {
            
            invalidate()
            
        }
    }
    
    func bannerViewWillLoadAd(banner: ADBannerView!) {
        NSLog("bannerViewWillLoadAd")
    }
    
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        NSLog("bannerViewDidLoadAd")
        self.adBannerView?.hidden = false //now show banner as ad is loaded
    }
    
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        NSLog("bannerViewDidLoadAd")
        
    }
    
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        NSLog("bannerViewActionShouldBegin")
        
        return true
    }
    
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        NSLog("bannerView")
    }
}



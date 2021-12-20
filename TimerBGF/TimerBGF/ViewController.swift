//
//  ViewController.swift
//  TimerBGF
//
//  Created by Ankitha Kamath on 20/12/21.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    
    
    @IBOutlet weak var labelStopWatch: UILabel!
    
    
    var timer = Timer()
    var hrs = 0
    var min = 0
    var sec = 0
    var milliSecs = 0
    var diffHrs = 0
    var diffMins = 0
    var diffSecs = 0
    var diffMilliSecs = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground(noti:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(noti:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @IBAction func startPressed(_ sender: UIButton) {
        self.removeSavedDate()
        self.timer = Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: (#selector(ViewController.updateLabels(t:))), userInfo: nil, repeats: true)
    }
    
    @IBAction func resetPressed(_ sender: UIButton) {
        self.removeSavedDate()
        self.resetContent()
    }
    
    
    @IBAction func pausePressed(_ sender: UIButton) {
        
        self.timer.invalidate()
    }
    
    @objc func pauseWhenBackground(noti: Notification) {
        self.timer.invalidate()
        let shared = UserDefaults.standard
        shared.set(Date(), forKey: "savedTime")
    }
    
    @objc func willEnterForeground(noti: Notification) {
        if let savedDate = UserDefaults.standard.object(forKey: "savedTime") as? Date {
            (diffHrs, diffMins, diffSecs) = ViewController.getTimeDifference(startDate: savedDate)
            
            self.refresh(hours: diffHrs, mins: diffMins, secs: diffSecs)
        }
    }
    
    func resetContent() {
        timer.invalidate()
        self.labelStopWatch.text = "00 : 00 : 00 : 00"
        self.milliSecs = 0
        self.sec = 0
        self.min = 0
        self.hrs = 0
    }
    
    @objc func updateLabels(t: Timer) {
        if(self.milliSecs >= 59) {
            self.sec += 1
            self.milliSecs = 0
            if (self.sec >= 60) {
                self.min += self.sec/60
                self.sec = self.sec % 60
                if (self.min >= 60) {
                    self.hrs += self.min/60
                    self.min = self.min % 60
                }
            }
        } else {
            self.milliSecs += 1
        }
        self.labelStopWatch.text = String(format: "%02d : %02d : %02d : %02d", self.hrs, self.min, self.sec, self.milliSecs)
    }
    
    static func getTimeDifference(startDate: Date) -> (Int, Int, Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: Date())
        return(components.hour!, components.minute!, components.second!)
    }
    
    func refresh (hours: Int, mins: Int, secs: Int) {
        self.hrs += hours
        self.min += mins
        self.sec += secs
        self.labelStopWatch.text = String(format: "%02d : %02d : %02d : %02d", self.hrs, self.min, self.sec, self.milliSecs)
        self.timer = Timer.scheduledTimer(timeInterval: 1/60, target: self, selector: (#selector(updateLabels(t:))), userInfo: nil, repeats: true)
        
    }
    
    func removeSavedDate() {
        if (UserDefaults.standard.object(forKey: "savedTime") as? Date) != nil {
            UserDefaults.standard.removeObject(forKey: "savedTime")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


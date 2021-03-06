//
//  NetworkViewController.swift
//  170304 IP Calculator
//
//  Created by Anders Pedersen on 05/03/17.
//  Copyright © 2017 Anders Pedersen. All rights reserved.
//

import UIKit

class NetworkViewController: UIViewController {
    
    @IBOutlet weak var ipAddressLabel: UILabel!
    @IBOutlet weak var prefixLengthLabel: UILabel!
    @IBOutlet weak var gamesLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var nextButtonLabel: UIButton!
    @IBOutlet weak var resetLabel: UIButton!
    @IBOutlet var buttonArray: Array<UIButton>!
    
    var ipNetworkTuple = IpNetworkTuple()
    
    var games = 0
    var score = 0
    var isPrefixPressed = false
    let prefs = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFontSize()
        games = prefs.integer(forKey: "nGames")
        score = prefs.integer(forKey: "nScore")
        gamesPrint()
        nGenSet()        
    }

    @IBAction func networkButtonPressed(_ sender: AnyObject) {
        if (!isPrefixPressed) {
            let funcValue = sender.tag
            if (ipNetworkTuple.networkTuple.networks[funcValue!].dotted()) == (ipNetworkTuple.networkTuple.networks[ipNetworkTuple.prefixTuple.right].dotted()) {
                score += 1
                setButtonColor(buttonNumber: funcValue!, correct: 1)
            } else {
                setButtonColor(buttonNumber: funcValue!, correct: 0)
                setButtonColor(buttonNumber: ipNetworkTuple.prefixTuple.right, correct: 1)
            }
            games += 1
            if games == 10 {
                triggerAlert(gms: (games), scr: score)
            }
            isPrefixPressed = true
            nextButtonLabel.setTitleColor(UIColor.black, for: UIControlState.normal)
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        nextQuestion()
    }
    
    @IBAction func swipeLeft(_ sender: Any) {
        nextQuestion()
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        games = 0
        score = 0
        gamesPrint()
        nGenSet()
    }
    
    func nGenSet() {
        nextButtonLabel.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        isPrefixPressed = false
        for i in 0 ... 3 { setButtonColor(buttonNumber: i, correct: 2) }
        ipNetworkTuple.genSet()
        ipAddressLabel.text = "IP address: \(ipNetworkTuple.ipAddress.dotted())"
        prefixLengthLabel.text = "Prefix size: /\(ipNetworkTuple.prefix.length)"        
        for i in 0 ... 3 {
            buttonArray[i].setTitle("\(ipNetworkTuple.networkTuple.networks[i].dotted())", for: UIControlState.normal)
        }
    }
    
    func setButtonColor(buttonNumber: Int, correct: Int) {
        let greenColor = UIColor(red: CGFloat(128)/255, green: CGFloat(255)/255, blue: CGFloat(0)/255, alpha: 1.0)
        let redColor = UIColor(red: CGFloat(255)/255, green: CGFloat(102)/255, blue: CGFloat(102)/255, alpha: 1.0)
        let button = buttonArray[buttonNumber]
        if correct == 1 {
            button.backgroundColor = greenColor
        } else  if correct == 0 {
            button.backgroundColor = redColor
        } else {
            button.backgroundColor = UIColor.groupTableViewBackground
        }
    }
    
    func setFontSize() {
        let myFontSize = fontsize()
        ipAddressLabel.font = UIFont.systemFont(ofSize: myFontSize)
        prefixLengthLabel.font = UIFont.systemFont(ofSize: myFontSize)
        for i in 0 ... 3 {
            buttonArray[i].titleLabel?.font = UIFont.systemFont(ofSize: myFontSize)
        }
        gamesLabel.font = UIFont.systemFont(ofSize: myFontSize)
        scoreLabel.font = UIFont.systemFont(ofSize: myFontSize)
        nextButtonLabel.titleLabel?.font = UIFont.systemFont(ofSize: myFontSize)
        resetLabel.titleLabel?.font = UIFont.systemFont(ofSize: myFontSize)
    }
    
    func animateTransition() {
        
        UIView.animate(withDuration: 0.2, delay: 0.0, animations: {
            () -> Void in
            for i in 0 ... 3 { self.buttonArray[i].isHidden = true }
            self.view.backgroundColor = UIColor.lightGray
        }, completion: { (finished: Bool) -> Void in
            self.view.backgroundColor = UIColor.groupTableViewBackground
            for i in 0 ... 3 { self.buttonArray[i].isHidden = false }
            self.gamesLabel.isHidden = false
            self.scoreLabel.isHidden = false
        })
    }
    
    func gamesPrint() {
        if games > 9 {
            games = 0
            score = 0
        }
        var percent:Float = 0
        if games == 0 { percent = 0 } else { percent = (Float(score) / Float(games) * 100) }
        gamesLabel.text = "Rounds played: \(games)"
        scoreLabel.text = "Score:  " + String.localizedStringWithFormat("%.0f", percent) + "%"
    }
    
    func triggerAlert(gms: Int, scr: Int) {
        self.gamesLabel.isHidden = true
        self.scoreLabel.isHidden = true
        var percent:Float = 0
        percent = (Float(scr) / Float(gms) * 100)
        let completeString = "\(scr)/\(gms) correct rounds = \(percent)%"
        let completeAlert = UIAlertController(title: completeString, message: "", preferredStyle: .alert)
        completeAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(completeAlert, animated: true, completion: nil)
    }
    
    func nextQuestion() {
        if isPrefixPressed {
            animateTransition()
            gamesPrint()
            nGenSet()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let prefs = UserDefaults.standard
        prefs.setValue(games, forKey: "nGames")
        prefs.setValue(score, forKey: "nScore")
    }

}

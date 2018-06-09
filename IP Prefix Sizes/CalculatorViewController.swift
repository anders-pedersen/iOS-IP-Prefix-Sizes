//
//  CalculatorViewController.swift
//  170304 IP Calculator
//
//  Created by Anders Pedersen on 05/03/17.
//  Copyright © 2017 Anders Pedersen. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var prefixLabel: UILabel!
    @IBOutlet weak var subnetLabel: UILabel!
    @IBOutlet weak var sliderOutlet: UISlider!
    
    var cPrefix = Prefix()
    var sliderValue = 28
    let prefs = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFontSize()
        sliderValue = prefs.integer(forKey: "sliderValue")
        if sliderValue == 0 { sliderValue = 28 }
        sliderOutlet.value = Float(sliderValue)
        drawView()

    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        sliderValue = Int(sender.value)
        drawView()
    }
    
    func setFontSize() {
        let myFontSize = fontsize()
        prefixLabel.font = UIFont.systemFont(ofSize: myFontSize)
        subnetLabel.font = UIFont.systemFont(ofSize: myFontSize)
    }
    
    func drawView() {
        prefixLabel.text = "Prefix size: /\(sliderValue)"
        cPrefix.length = sliderValue
        let cInt = cPrefix.SubnetMask()
        let funcAddress = int64ToAddress(funcInt64: cInt)
        subnetLabel.text = "Subnet mask: \(funcAddress.dotted())"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let prefs = UserDefaults.standard
        prefs.setValue(sliderValue, forKey: "sliderValue")
    }

}

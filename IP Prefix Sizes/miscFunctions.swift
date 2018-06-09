//
//  miscClasses.swift
//  170304 IP Calculator
//
//  Created by Anders Pedersen on 06/03/17.
//  Copyright © 2017 Anders Pedersen. All rights reserved.
//

import Foundation
import UIKit


func fontsize() -> CGFloat {
    let maxLength = max(UIScreen.main.bounds.size.width , UIScreen.main.bounds.size.height)
    // case 568: iPhone SE
    // case 667: iPhone 6/6s
    if maxLength < 667 {
        return 18
    } else {
        return 24
    }
}







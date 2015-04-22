//
//  Utility.swift
//  SharpShopper
//
//  Created by Patrick Sheehan on 4/22/15.
//  Copyright (c) 2015 ABRAID. All rights reserved.
//

import UIKit

class Utility: NSObject {
   
    class func stripped(string: String?) -> String {
        if let newString = string?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) {
            return newString
        }
        
        return ""
    }
    
}

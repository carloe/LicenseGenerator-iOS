//
//  NSBundle+LoadPlist.swift
//  LicenseViewController
//
//  Created by Carlo Eugster on 03/04/16.
//  Copyright © 2016 relaunch. All rights reserved.
//

import Foundation

// MARK: - NSBundle + Plist

extension Bundle {
  
  /**
   Loads a plist file from the bundle and returns it's contents as a NSDictionary
   
   - parameter resourceName: The name of the plist.
   
   - returns: A NSDictionary representation of the plist.
   */
  func loadPlist(_ resourceName: String) -> NSDictionary? {
    var plistDict: NSDictionary?
    if let path = path(forResource: resourceName, ofType: "plist") {
      plistDict = NSDictionary(contentsOfFile: path)
    }
    return plistDict
  }
}

//
//  NSDictionary+LicenseItems.swift
//  LicenseViewController
//
//  Created by Carlo Eugster on 03/04/16.
//  Copyright © 2016 relaunch. All rights reserved.
//

import Foundation

// MARK: - :NSDictionary + CreditItem

extension NSDictionary {
  
  func toLicenseItems() -> Array<LicenseItem> {
    var resultArray = Array<LicenseItem>()
    if let licensesDicts = self["PreferenceSpecifiers"] as? NSArray {
      for license in (licensesDicts as NSArray as! [NSDictionary]) {
        if let title = license["Title"] as? String, body = license["FooterText"] as? String {
          let model = LicenseItem(title: title, body: body)
          resultArray.append(model)
        }
      }
    }
    return resultArray
  }
}
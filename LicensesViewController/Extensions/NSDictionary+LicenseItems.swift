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
    guard let licensesDicts = self["PreferenceSpecifiers"] as? NSArray else {
        return resultArray
    }
    
    for license in (licensesDicts as NSArray as! [NSDictionary]) {
        guard let title = license["Title"] as? String, let body = license["FooterText"] as? String else {
            continue
        }
        resultArray.append(LicenseItem(title: title, body: body))
    }
    return resultArray
  }
}

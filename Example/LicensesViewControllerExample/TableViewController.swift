//
//  TableViewController.swift
//  LicenseViewControllerExample
//
//  Created by Carlo Eugster on 03/04/16.
//  Copyright © 2016 relaunch. All rights reserved.
//

import UIKit
import LicensesViewController

class TableViewController: UITableViewController {
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "AknowledgementSegue" {
      if let destinationVC = segue.destinationViewController as? LicensesViewController {
        destinationVC.loadPlist(NSBundle.mainBundle(), resourceName: "Credits")
      }
    }
  }
}

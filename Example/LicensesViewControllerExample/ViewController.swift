//
//  ViewController.swift
//  LicenseViewControllerExample
//
//  Created by Carlo Eugster on 03/04/16.
//  Copyright © 2016 relaunch. All rights reserved.
//

import UIKit
import LicensesViewController

class ExampleTableViewController: UITableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AknowledgementSegue" {
            if let destinationVC = segue.destination as? LicensesViewController {
                destinationVC.loadPlist(Bundle.main, resourceName: "Credits")
            }
        }
    }
}

class ExampleViewController: UIViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AknowledgementSegue" {
      if let destinationVC = segue.destination as? LicensesViewController {
        destinationVC.loadPlist(Bundle.main, resourceName: "Credits")
      }
    }
  }
}

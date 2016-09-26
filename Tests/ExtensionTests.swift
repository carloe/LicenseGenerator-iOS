//
//  ExtensionTests.swift
//  LicenseViewController
//
//  Created by Carlo Eugster on 03/04/16.
//  Copyright © 2016 relaunch. All rights reserved.
//

import XCTest
@testable import LicensesViewController

/**
 This test case tests the NSBundle extentions for loading and parsing plist files
 */
class PlistTests: XCTestCase {
  
  // MARK: - Loading plist dicts
  
  /**
   Test that plists are loaded as dicts.
   */
  func testDictionaryLoading () {
    let dictionary = Bundle(for: type(of: self)).loadPlist("Credits")
    XCTAssert((dictionary as Any) is NSDictionary)
    XCTAssert(dictionary!.allKeys.count == 2)
    XCTAssertNotNil(dictionary!["StringsTable"])
    XCTAssertNotNil(dictionary!["PreferenceSpecifiers"])
  }
  
  func testLoadingNonexistentPlists() {
    let dictionary = Bundle(for: type(of: self)).loadPlist("FooPlist")
    debugPrint(dictionary)
    XCTAssertEqual(dictionary, nil)
  }
  
  
  // MARK: - Transforming plist dicts
  
  /**
   Test that valid NSDictionary structures get transformed into CreditItem arrays.
   */
  func testTransformingDictToCreditItems() {
    let dictionary = Bundle(for: type(of: self)).loadPlist("Credits")!
    let items = dictionary.toLicenseItems()
    XCTAssert((items as Any) is Array<LicenseItem>)
    XCTAssert(items.count == 3)
    XCTAssertEqual(items[0].title, "TestLibFoo1")
    XCTAssertEqual(items[2].title, "TestLibFoo3")
  }
  
  /**
   Test that unexpected NSDictionary structures return empty CreditItem arrays.
   */
  func testTransformingEmptyDicts() {
    let dictionary = NSDictionary(dictionary: ["foo" : "fooValue", "bar": "barValue"])
    let items = dictionary.toLicenseItems()
    XCTAssertEqual(items.count, 0)
  }
}

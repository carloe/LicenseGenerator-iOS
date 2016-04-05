//
//  LicenseViewControllerTests.swift
//  LicenseViewControllerTests
//
//  Created by Carlo Eugster on 03/04/16.
//  Copyright © 2016 relaunch. All rights reserved.
//

import XCTest
@testable import LicensesViewController

/**
 This test case tests the UITableViewDataSource.
 */
class DataSourceTests: XCTestCase {
  
  // MARK: - Properties
  
  /// The test credit items
  var testItems: Array<LicenseItem>!
  
  // MARK: - Setup and Teardown
  
  override func setUp() {
    super.setUp()
    let testItemsDict = NSBundle(forClass: self.dynamicType).loadPlist("Credits")
    if let dict = testItemsDict {
      testItems = dict.toLicenseItems()
    }
  }
  
  
  // MARK: - Section & Row Counts
  
  /**
   Tests that the `dataSource` only returns 1 row per section.
   */
  func testNumberOfRowsInSection() {
    let dataSource = LicensesDataSource(reuseIdentifier: "identifier", items: testItems) { _ in }
    let rows = dataSource.tableView(UITableView(), numberOfRowsInSection: 0)
    XCTAssertEqual(rows, 1)
  }
  
  
  /**
   Tests that the `dataSource` contains the correct number of sections.
   */
  func testNumbersOfSectionsInTableView() {
    let dataSource = LicensesDataSource(reuseIdentifier: "identifier", items: testItems) { _ in }
    let sections = dataSource.numberOfSectionsInTableView(UITableView())
    XCTAssertEqual(sections, 3)
  }
  
  
  // MARK: - Cell Configuration
  
  /**
   Test that cells are configured correctly.
   */
  func testCellConfiguration() {
    let indexPath = NSIndexPath(forRow: 0, inSection: 1)
    let reuseIdentifier = "TestCell"
    let tableView = UITableView()
    
    var configuredCell: UITableViewCell?
    var configuredItem: LicenseItem?
    
    let dataSource = LicensesDataSource(reuseIdentifier: reuseIdentifier, items: self.testItems, configureCell: {
      (cell: LicenseCell, item: LicenseItem) in
      configuredCell = cell
      configuredItem = item
    })
    
    tableView.registerClass(LicenseCell.classForCoder(), forCellReuseIdentifier: reuseIdentifier)
    tableView.dataSource = dataSource
    
    let result = dataSource.tableView(tableView, cellForRowAtIndexPath: indexPath)
    
    XCTAssertEqual(result, configuredCell)
    XCTAssertEqual(testItems[indexPath.section].title, configuredItem?.title)
    XCTAssertEqual(testItems[indexPath.section].body, configuredItem?.body)
  }
  
  // MARK: - Get Items
  
  /**
   Test that `itemAtIndexPath:` returns the correct item.
   */
  func testItemAtIndexPath() {
    let dataSource = LicensesDataSource(reuseIdentifier: "identifier", items: testItems) { _ in }
    let firstItem = dataSource.itemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
    let secondItem = dataSource.itemAtIndexPath(NSIndexPath(forRow: 0, inSection: 1))
    let thirdItem = dataSource.itemAtIndexPath(NSIndexPath(forRow: 0, inSection: 2))
    
    XCTAssertEqual(firstItem.title, "TestLibFoo1")
    XCTAssertEqual(secondItem.title, "TestLibFoo2")
    XCTAssertEqual(thirdItem.title, "TestLibFoo3")
  }
}
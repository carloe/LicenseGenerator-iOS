//
//  LicensesViewController.swift
//  LicensesViewController
//
//  Created by Carlo Eugster on 03/04/16.
//  Copyright © 2016 relaunch. All rights reserved.
//

import UIKit

// MARK: - LicensesViewController

/// ViewController that displays Settings.bundle style credist.
public class LicensesViewController : UIViewController {
  
  /// The tableView
  let tableView = UITableView(frame: CGRect.zero, style: .Grouped)
  
  /// The tableView's UITableViewDataSource.
  var dataSource: LicensesDataSource!
  
  /// Boolean tracking if the constrains have been setup.
  private var didSetupConstraints = false
  
  private let reuseIdentifier = "LicenseCell"
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    title = NSLocalizedString("Acknowledgements", comment: "Acknowledgements")
    
    tableView.registerClass(LicenseCell.classForCoder(), forCellReuseIdentifier: reuseIdentifier)
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 68.0
    tableView.frame = view.bounds
    
    view.addSubview(tableView)
  }
  
  public override func updateViewConstraints() {
    if(!didSetupConstraints) {
      view.addConstraints(
        NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: nil,
          views: ["tableView" : tableView]
        )
      )
      view.addConstraints(
        NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: nil,
          views: ["tableView" : tableView]
        )
      )
      
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  /**
   Loads the contents of a Settings.bundle style plist into the tableView
   
   - parameter bundle:       The bundle containing the plist
   - parameter resourceName: The resource name of the plist
   */
  public func loadPlist(bundle: NSBundle, resourceName: String) {
    if let plistDict = bundle.loadPlist(resourceName) {
      loadPlist(plistDict)
    }
  }
  
  /**
   Loads the contents of a Settings.bundle style plist dictionary into the tableView
   
   - parameter dictionary: A Settings.bundle style NSDictionary
   */
  public func loadPlist(dictionary: NSDictionary) {
    let items = dictionary.toLicenseItems()
    setDataSource(items)
  }
  
  /**
   Initializes the tableView's dataSource.
   */
  func setDataSource(licenseItems: Array<LicenseItem>) {
    dataSource = LicensesDataSource(reuseIdentifier: reuseIdentifier, items: licenseItems, configureCell: {
      (cell: LicenseCell, item: LicenseItem) in
      cell.titleLabel.text = item.title
      cell.bodyLabel.text = item.body
    });
    tableView.dataSource = dataSource
  }
}

// MARK: - LicenseCell

class LicenseCell : UITableViewCell {
  
  /// The title label of the cell.
  let titleLabel = UILabel()
  
  /// The body label of the cell.
  let bodyLabel = UILabel()
  
  /// Boolean tracking if the constrains have been setup.
  private var didSetupConstraints = false
  
  /**
   Initializes a new LicenseCell
   
   - parameter style:           This property is ignoed.
   - parameter reuseIdentifier: A string used to identify the cell object if it is to be reused
   for drawing multiple rows of a table view. Pass nil if the cell object is not to
   be reused. You should use the same reuse identifier for all cells of the same form.
   
   - returns: An initialized UITableViewCell object or nil if the object could not be created.
   */
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    selectionStyle = .None
    
    titleLabel.textColor = UIColor.blackColor()
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
    titleLabel.lineBreakMode = .ByTruncatingTail
    titleLabel.numberOfLines = 1
    contentView.addSubview(titleLabel)
    
    bodyLabel.textColor = UIColor.darkGrayColor()
    bodyLabel.translatesAutoresizingMaskIntoConstraints = false
    bodyLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleFootnote)
    bodyLabel.lineBreakMode = .ByWordWrapping
    bodyLabel.numberOfLines = 0
    contentView.addSubview(bodyLabel)
    
    setNeedsUpdateConstraints()
    updateConstraintsIfNeeded()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func updateConstraints() {
    if(!didSetupConstraints) {
      let noLayoutOption = NSLayoutFormatOptions(rawValue: 0)
      let views: [String: AnyObject] = [
        "titleLabel" : titleLabel,
        "bodyLabel" : bodyLabel
      ]
      
      contentView.addConstraints(
        NSLayoutConstraint.constraintsWithVisualFormat("H:|-[titleLabel]-|",
          options: noLayoutOption,
          metrics: nil,
          views: views)
      )
      contentView.addConstraints(
        NSLayoutConstraint.constraintsWithVisualFormat("H:|-[bodyLabel]-|",
          options: noLayoutOption,
          metrics: nil,
          views: views)
      )
      contentView.addConstraints(
        NSLayoutConstraint.constraintsWithVisualFormat("V:|-[titleLabel]-[bodyLabel]-|",
          options: noLayoutOption,
          metrics: nil,
          views: views)
      )
      didSetupConstraints = true
    }
    
    super.updateConstraints()
  }
}

// MARK: - LicensesDataSource

/// A wrapper around `UITableViewDataSource`
class LicensesDataSource: NSObject, UITableViewDataSource {
  
  /// A closure for configuring cells.
  typealias LicenseCellConfigClosure = (cell: LicenseCell, item: LicenseItem) -> ()
  
  /// Closure that is called to configure cells.
  let configureCell: LicenseCellConfigClosure!
  
  /// The reuse identifier of the tableView's cells.
  let reuseIdentifier: String!
  
  /// The models represented by the dataSource.
  let items: Array<LicenseItem>
  
  /**
   Initializes a new `dataSource` with items and a configuration closure.
   
   - parameter reuseIdentifier: The `reuseIdentifier` of cells in the tableView.
   - parameter items:           The license items representing the data in the tableView.
   - parameter config:          The closure that will be called to configure cells.
   
   - returns: An initialized `dataSource` object.
   */
  init(reuseIdentifier: String, items: Array<LicenseItem>, configureCell: LicenseCellConfigClosure) {
    self.configureCell = configureCell
    self.reuseIdentifier = reuseIdentifier
    self.items = items;
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return items.count
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as? LicenseCell
    
    let item = items[indexPath.section]
    configureCell(cell: cell!, item: item)
    return cell!
  }
  
  /**
   Returns a `LicenseItem` at an `indexPath`.
   
   - parameter indexPath: The `indexPath` of the item.
   
   - returns: The `LicenseItem` at the given `indexPath`.
   */
  func itemAtIndexPath(indexPath: NSIndexPath) -> LicenseItem {
    return items[indexPath.section]
  }
}

// MARK: - LicenseItem

/**
 * A license item
 */
struct LicenseItem {
  var title: String?
  var body: String?
}

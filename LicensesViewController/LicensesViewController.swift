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
open class LicensesViewController : UIViewController {

  /// The tableView
  open let tableView = UITableView(frame: CGRect.zero, style: .grouped)

  /// The tableView's UITableViewDataSource.
  var dataSource: LicensesDataSource!

  /// Boolean tracking if the constrains have been setup.
  fileprivate var didSetupConstraints = false

  fileprivate let reuseIdentifier = "LicenseCell"

  open override func viewDidLoad() {
    super.viewDidLoad()

    title = NSLocalizedString("Acknowledgements", comment: "Acknowledgements")

    tableView.register(LicenseCell.classForCoder(), forCellReuseIdentifier: reuseIdentifier)
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 68.0
    tableView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(tableView)
    view.setNeedsUpdateConstraints()
  }

  open override func updateViewConstraints() {
    if(!didSetupConstraints) {
      view.addConstraints(
        NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|",
          options: NSLayoutFormatOptions(rawValue: 0),
          metrics: nil,
          views: ["tableView" : tableView]
        )
      )
      view.addConstraints(
        NSLayoutConstraint.constraints(withVisualFormat: "V:|[tableView]|",
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
  @objc open func loadPlist(_ bundle: Bundle, resourceName: String) {
    if let plistDict = bundle.loadPlist(resourceName) {
      loadPlist(plistDict)
    }
  }

  /**
   Loads the contents of a Settings.bundle style plist dictionary into the tableView

   - parameter dictionary: A Settings.bundle style NSDictionary
   */
  @objc open func loadPlist(_ dictionary: NSDictionary) {
    let items = dictionary.toLicenseItems()
    setDataSource(items)
  }

  /**
   Initializes the tableView's dataSource.
   */
  func setDataSource(_ licenseItems: Array<LicenseItem>) {
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
  fileprivate var didSetupConstraints = false

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

    selectionStyle = .none

    titleLabel.textColor = UIColor.black
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
    titleLabel.lineBreakMode = .byTruncatingTail
    titleLabel.numberOfLines = 1
    contentView.addSubview(titleLabel)

    bodyLabel.textColor = UIColor.darkGray
    bodyLabel.translatesAutoresizingMaskIntoConstraints = false
    bodyLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote)
    bodyLabel.lineBreakMode = .byWordWrapping
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
        NSLayoutConstraint.constraints(withVisualFormat: "H:|-[titleLabel]-|",
          options: noLayoutOption,
          metrics: nil,
          views: views)
      )
      contentView.addConstraints(
        NSLayoutConstraint.constraints(withVisualFormat: "H:|-[bodyLabel]-|",
          options: noLayoutOption,
          metrics: nil,
          views: views)
      )
      contentView.addConstraints(
        NSLayoutConstraint.constraints(withVisualFormat: "V:|-[titleLabel]-[bodyLabel]-|",
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
@objc class LicensesDataSource: NSObject, UITableViewDataSource {

  /// A closure for configuring cells.
  typealias LicenseCellConfigClosure = (_ cell: LicenseCell, _ item: LicenseItem) -> ()

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
  init(reuseIdentifier: String, items: Array<LicenseItem>, configureCell: @escaping LicenseCellConfigClosure) {
    self.configureCell = configureCell
    self.reuseIdentifier = reuseIdentifier
    self.items = items;
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return items.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? LicenseCell

    let item = items[(indexPath as NSIndexPath).section]
    configureCell?(cell!, item)
    return cell!
  }

  /**
   Returns a `LicenseItem` at an `indexPath`.

   - parameter indexPath: The `indexPath` of the item.

   - returns: The `LicenseItem` at the given `indexPath`.
   */
  func itemAtIndexPath(_ indexPath: IndexPath) -> LicenseItem {
    return items[(indexPath as NSIndexPath).section]
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

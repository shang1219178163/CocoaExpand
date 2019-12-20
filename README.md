# CocoaExpand

[![CI Status](https://img.shields.io/travis/shang1219178163@gmail.com/CocoaExpand.svg?style=flat)](https://travis-ci.org/shang1219178163@gmail.com/CocoaExpand)
[![Version](https://img.shields.io/cocoapods/v/CocoaExpand.svg?style=flat)](https://cocoapods.org/pods/CocoaExpand)
[![License](https://img.shields.io/cocoapods/l/CocoaExpand.svg?style=flat)](https://cocoapods.org/pods/CocoaExpand)
[![Platform](https://img.shields.io/cocoapods/p/CocoaExpand.svg?style=flat)](https://cocoapods.org/pods/CocoaExpand)

## Usage

Swift
```
// custom CellView
class NSTableCellViewOne: NSTableCellView { ... }
// use
let cell = tableView.makeView(for: NSTableCellViewOne.self)

public extension NSTableView {
    /// makeView
    final func makeView<T: NSTableCellView>(for cellType: T.Type, identifier: String = String(describing: T.self), style: NSTableView.RowSizeStyle = .default) -> T {
        if let view: NSTableCellView = makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), owner: T.self) as? T {
            return view as! T;
        }
        let cellView = T.init()
        cellView.identifier = NSUserInterfaceItemIdentifier(rawValue: identifier);
        cellView.wantsLayer = true;
        return cellView;
    }
}
```

Objective-C && Swift
```
// custom CellView
class NSTableCellViewOne: NSTableCellView { ... }
// use
let cell = NSTableCellViewOne.makeView(tableView: tableView, identifier: identifier, owner: self)

@objc public extension NSTableCellView {

    /// 复用NSTableCellView
    static func makeView(tableView: NSTableView, identifier: String = String(describing: self), owner: Any) -> Self {
        if let view: NSTableCellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: identifier), owner: owner) as? NSTableCellView {
            return view as! Self;
        }
        let cellView = self.init()
        cellView.identifier = NSUserInterfaceItemIdentifier(rawValue: identifier);
        cellView.wantsLayer = true;
        return cellView;
    }
}
```
## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

```
s.osx.deployment_target = "10.12"
s.swift_version = "5.0"
```

## Installation

CocoaExpand is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CocoaExpand'
```

## Author

shang1219178163, shang1219178163@gmail.com

## License

CocoaExpand is available under the MIT license. See the LICENSE file for more info.

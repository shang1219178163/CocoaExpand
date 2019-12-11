//
//  ViewController.swift
//  CocoaExpand
//
//  Created by shang1219178163@gmail.com on 12/03/2019.
//  Copyright (c) 2019 shang1219178163@gmail.com. All rights reserved.
//

import Cocoa
import CocoaExpand

class ViewController: NSViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        DDLog(kScreenWidth)
    }

  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }


}


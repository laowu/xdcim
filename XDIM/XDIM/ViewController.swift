//
//  ViewController.swift
//  XDIM
//
//  Created by 白大卫 on 17/3/3.
//  Copyright © 2017年 bdw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let connectMgr:XDCConnectionManager = XDCConnectionManager.sharedInstance
        connectMgr.connect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  ViewController.swift
//  Kipochi
//
//  Created by parthdigitus on 07/18/2019.
//  Copyright (c) 2019 parthdigitus. All rights reserved.
//

import UIKit
import Kipochi

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            KipochiConfigration().getData(from: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


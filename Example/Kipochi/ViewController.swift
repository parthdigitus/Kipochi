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
    }

    @IBAction func btnPayPress(_ sender: UIButton) {
        KipochiConfigration.shared.presentPaymentView(self, email: "parth.bhadaja@digituscomputing.com", orderId: "1", amount: "1", customerId: "C2", meta: "pu-c-1001", delegate: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: KipochiPaymentControllerDelegate {
    func paymentController(_ paymentController: KipochiPaymentController, didFailWithError error: Error) {
        
    }
    
    func paymentControllerDidCancel(_ paymentController: KipochiPaymentController) {
        print("Cancel Called")
    }
    
    func paymentControllerDidFinish(_ paymentController: KipochiPaymentController) {
        
    }
}

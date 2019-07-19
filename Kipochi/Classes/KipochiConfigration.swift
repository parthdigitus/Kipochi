//
//  KipochiConfigration.swift
//  Kipochi
//
//  Created by macbook on 7/18/19.
//

import Foundation

public class KipochiConfigration: NSObject {
    
    public func getData(from:UIViewController) {
        
        let podBundle = Bundle(for: KipochiPaymentController.self)
        
        let bundleURL = podBundle.url(forResource: "Kipochi", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)!
        
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let vc = storyboard.instantiateInitialViewController()!
        from.present(vc, animated: true, completion: nil)
    }
    
    static var bundle:Bundle {
        let podBundle = Bundle(for: KipochiPaymentController.self)
        
        let bundleURL = podBundle.url(forResource: "Kipochi", withExtension: "bundle")
        return Bundle(url: bundleURL!)!
    }
    
}


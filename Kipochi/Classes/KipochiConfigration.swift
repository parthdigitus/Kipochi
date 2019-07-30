//
//  KipochiConfigration.swift
//  Kipochi
//
//  Created by macbook on 7/18/19.
//

import Foundation


//public let baseURL = "http://kipochi.digituscomputing.com/v1/"

enum URLS:String {
    case checkout_token = "checkout/token"
    case checkout_mpesaexpress = "checkout/mpesaexpress"
    case checkout_query = "checkout/query"
}



public class KipochiConfigration: NSObject {
    
    public static let shared = KipochiConfigration()
    public var AppKey:String?
    public var SecretKey:String?

    override init(){
        
    }
    
    public func presentPaymentView(_ fromViewController:UIViewController, email:String,orderId:String,amount:String,customerId:String,meta:String,delegate:KipochiPaymentControllerDelegate) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.bundle)
        let aVC = storyboard.instantiateInitialViewController()! as! UINavigationController
        let VC = aVC.topViewController as! KipochiPaymentController
        VC.delegate = delegate
        VC.orderId = orderId
        VC.amount = amount
        VC.email = email
        VC.meta = meta
        VC.customerId = customerId
        fromViewController.present(aVC, animated: true, completion: nil)
    }
    
    public func pushPaymentView(_ fromNavigation:UINavigationController, email:String,orderId:String,amount:String,customerId:String,meta:String,delegate:KipochiPaymentControllerDelegate) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.bundle)
        let aVC = storyboard.instantiateViewController(withIdentifier: "KipochiPaymentController") as! KipochiPaymentController
        aVC.delegate = delegate
        aVC.orderId = orderId
        aVC.amount = amount
        aVC.email = email
        aVC.meta = meta
        aVC.customerId = customerId
        fromNavigation.pushViewController(aVC, animated: true)
    }
    

    
}


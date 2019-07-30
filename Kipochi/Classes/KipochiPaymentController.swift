//
//  KipochiPaymentController.swift
//  Kipochi
//
//  Created by macbook on 7/18/19.
//

import UIKit
import Alamofire
import SVProgressHUD

public protocol KipochiPaymentControllerDelegate {
    func paymentControllerDidFinish(_ paymentController: KipochiPaymentController)
    func paymentController(_ paymentController: KipochiPaymentController, didFailWithError error: Error)
    func paymentControllerDidCancel(_ paymentController: KipochiPaymentController)
}
public let baseURL = "http://kipochi.digituscomputing.com/v1/"


public class KipochiPaymentController: UIViewController {

    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var paymentTable: UITableView!
    @IBOutlet weak var paymentTableHeight: NSLayoutConstraint!

    @IBOutlet weak var btnKipochi: UIButton!
    
    
    var timer = Timer()
    let delay = 5.0
    
    var expandedIndex = 0
    var delegate:KipochiPaymentControllerDelegate?
    private var checkoutToken:GenerateToken!
    var email:String!
    var orderId:String!
    var amount:String!
    var customerId:String!
    var meta:String!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.callAPIForGenerateToken()
        
        paymentTable.register(UINib(nibName: "ExpandbleCell", bundle: Bundle.bundle), forCellReuseIdentifier: "ExpandbleCell")
        paymentTable.register(UINib(nibName: "MpesaExpressCell", bundle: Bundle.bundle), forCellReuseIdentifier: "MpesaExpressCell")
        paymentTable.register(UINib(nibName: "MpesaCell", bundle: Bundle.bundle), forCellReuseIdentifier: "MpesaCell")
        paymentTable.register(UINib(nibName: "DebitCreditCell", bundle: Bundle.bundle), forCellReuseIdentifier: "DebitCreditCell")
        
        self.paymentTable.tableFooterView = UIView(frame: .zero)
        
        let item = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(btnCancelPress(_:)))
        navigationItem.leftBarButtonItem = item
        
        
        // Do any additional setup after loading the view.
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            self.paymentTableHeight.constant = self.paymentTable.contentSize.height
            self.view.layoutIfNeeded()
    }
    
    @IBAction func btnCancelPress(_ sender: UIBarButtonItem) {
        delegate?.paymentControllerDidCancel(self)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnKipochiPressed(_ sender:UIButton) {
       //Got to website
    }

    

}


extension KipochiPaymentController:UITableViewDelegate,
UITableViewDataSource{
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expandedIndex == section {
            return 2
        }
        return 1
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if expandedIndex == indexPath.section {
            if indexPath.row == 0 {
                return 41
            }
            else {
                if indexPath.section == 0 {
                    return 242
                }
                else if indexPath.section == 1 {
                    return 311
                }
                return 380
            }
        }
        return 41
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 7
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandbleCell", for: indexPath) as! ExpandbleCell
            cell.lblTitle.text = "MPESA EXPRESS"
            switch indexPath.section {
                case 0:
                    cell.lblTitle.text = "MPESA EXPRESS"
                case 1:
                    cell.lblTitle.text = "MPESA"
                case 2:
                    cell.lblTitle.text = "DEBIT / CREDIT CARD"
                default:
                break
            }
            if expandedIndex == indexPath.section {
                cell.btnArrow.isSelected = true
            }
            else {
                cell.btnArrow.isSelected = false
            }
            
            return cell
        }
        else {
            
            switch indexPath.section {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MpesaExpressCell", for: indexPath) as! MpesaExpressCell
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MpesaCell", for: indexPath) as! MpesaCell
                    
                    return cell
                case 2:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DebitCreditCell", for: indexPath) as! DebitCreditCell
                    
                    return cell
                default:
                break
            }
        }
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: indexPath.section)) as! ExpandbleCell
            if expandedIndex == indexPath.section {
                expandedIndex = -1
                tableView.deleteRows(at: [IndexPath(row: 1, section: indexPath.section)], with: .automatic)
                cell.btnArrow.isSelected = false
            }
            else {
                cell.btnArrow.isSelected = true
                if expandedIndex != -1 {
                    let oldIndex = expandedIndex
                    expandedIndex = -1
                    let cellTmp = tableView.cellForRow(at: IndexPath(row: 0, section: oldIndex)) as! ExpandbleCell
                    cellTmp.btnArrow.isSelected = false
                    tableView.deleteRows(at: [IndexPath(row: 1, section: oldIndex)], with: .automatic)
                }
                expandedIndex = indexPath.section
                tableView.insertRows(at: [IndexPath(row: 1, section: indexPath.section)], with: .automatic)
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.paymentTableHeight.constant = tableView.contentSize.height
                self.view.layoutIfNeeded()
            }
        }
    }
}


extension KipochiPaymentController {
    @IBAction func btnSendRequestPress(_ sender:UIButton){
        let indexPath = IndexPath(row: 1, section: 0)
        let cell = self.paymentTable.cellForRow(at: indexPath) as! MpesaExpressCell
        if cell.txtNumber.text!.count == 14 {
          self.callAPIForMPESAExpress(ContactNo: cell.txtNumber.text!)
        }
        
    }
    
    @IBAction func btnPaymentPress(_ sender:UIButton){
        self.callAPIForMPESA()
    }
    
    @IBAction func btnPayPress(_ sender:UIButton){
        
    }
}

extension KipochiPaymentController {
    
    func callAPIForGenerateToken(){
        SVProgressHUD.show()
        let param = ["orderId":orderId,
                     "amount": amount,
                     "customerId": customerId,
                     "meta": meta] as [String:AnyObject]
        
        let headerTokenString = KipochiConfigration.shared.AppKey! + ":" + KipochiConfigration.shared.SecretKey!
        
        callDataResponse(urlPath: URLS.checkout_token, method: .post, param: param, headers: ["Authorization" : "Basic " + headerTokenString.toBase64().trimmingCharacters(in: .whitespacesAndNewlines)], modal: GenerateToken.self, completion: { (result) in
            SVProgressHUD.dismiss()
            self.checkoutToken = result

        }) { (responce, error) in
            SVProgressHUD.dismiss()
        }
    }
    
    //MARK:- Call API for MPESA-Express
    func callAPIForMPESAExpress(ContactNo:String){
        
        let param = ["orderId":orderId,
                     "orderDisplay": "KCA001A",
                     "amount": amount,
                     "msisdn": ContactNo,
                     "meta": meta] as [String:AnyObject]
        
        let headerTokenString = KipochiConfigration.shared.AppKey! + ":" + KipochiConfigration.shared.SecretKey!
        
        callDataResponse(urlPath: URLS.checkout_mpesaexpress, method: .post, param: param, headers: ["Authorization" : "Basic " + headerTokenString.toBase64()], modal: MPESAExpressModal.self, completion: { (result) in
            print(result)
            
        }) { (responce, error) in
            
        }
    }
    
    //MARK:- Call API for MPESA-Express
    func callAPIForMPESA(){
        
        let param = ["orderId":orderId,
                     "orderDisplay": "KCA001A",
                     "amount": amount,
                     "msisdn": "",
                     "meta": meta] as [String:AnyObject]
        
        let headerTokenString = KipochiConfigration.shared.AppKey! + ":" + KipochiConfigration.shared.SecretKey!
        
        callDataResponse(urlPath: URLS.checkout_mpesaexpress, method: .post, param: param, headers: ["Authorization" : "Basic " + headerTokenString.toBase64()], modal: MPESAExpressModal.self, completion: { (result) in
            print(result)
            self.timer =  Timer.scheduledTimer(timeInterval: self.delay, target: self, selector: #selector(self.delayedAction), userInfo: nil, repeats: true)
            
        }) { (responce, error) in
            
        }
    }
    
    @objc func delayedAction() {
        print("Delay....5 sec")
        //self.callAPIforCheckoutMPESA(modal: result)
    }
    
    func callAPIforCheckoutMPESA(modal:MPESAExpressModal) {
        let param = ["billRefNumber": "",
                     "checkoutId": modal.checkoutId,
                     "token": "",
                     "checkoutRequestId": modal.checkoutRequestId] as [String:AnyObject]
        
        let headerTokenString = KipochiConfigration.shared.AppKey! + ":" + KipochiConfigration.shared.SecretKey!
        
        callDataResponse(urlPath: URLS.checkout_query, method: .post, param: param, headers: ["Authorization" : "Basic " + headerTokenString.toBase64()], modal: MPESAExpressModal.self, completion: { (result) in
            print(result)
            
        }) { (responce, error) in
            
        }
    }
}


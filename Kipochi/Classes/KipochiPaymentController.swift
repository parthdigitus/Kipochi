//
//  KipochiPaymentController.swift
//  Kipochi
//
//  Created by macbook on 7/18/19.
//

import UIKit

public class KipochiPaymentController: UIViewController {

    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var paymentTable: UITableView!
    @IBOutlet weak var paymentTableHeight: NSLayoutConstraint!

    @IBOutlet weak var btnKipochi: UIButton!
    
    
    
    var expandedIndex = 0
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let podBundle = Bundle(for: KipochiPaymentController.self)
        
        let bundleURL = podBundle.url(forResource: "Kipochi", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)!
        
        paymentTable.register(UINib(nibName: "ExpandbleCell", bundle: bundle), forCellReuseIdentifier: "ExpandbleCell")
        paymentTable.register(UINib(nibName: "MpesaExpressCell", bundle: bundle), forCellReuseIdentifier: "MpesaExpressCell")
        paymentTable.register(UINib(nibName: "MpesaCell", bundle: bundle), forCellReuseIdentifier: "MpesaCell")
        paymentTable.register(UINib(nibName: "DebitCreditCell", bundle: bundle), forCellReuseIdentifier: "DebitCreditCell")
        
        self.paymentTable.tableFooterView = UIView(frame: .zero)
        
        
        
        // Do any additional setup after loading the view.
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.paymentTableHeight.constant = self.paymentTable.contentSize.height
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func btnCancelPress(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnKipochiPressed(_ sender:UIButton) {
       //Got to website
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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

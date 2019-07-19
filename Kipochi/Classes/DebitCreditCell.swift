//
//  DebitCreditCell.swift
//  ProgamaticallyTableView
//
//  Created by Admin on 18/07/19.
//  Copyright © 2019 Sandy. All rights reserved.
//

import UIKit

class DebitCreditCell: UITableViewCell {

    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtMothYear: UITextField!
    @IBOutlet weak var txtSecurityCode: UITextField!
    @IBOutlet weak var imgCardNumber: UIImageView!
    @IBOutlet weak var imgMonthYear: UIImageView!
    @IBOutlet weak var imgCVV: UIImageView!
    @IBOutlet weak var btnPay: UIButton!
    
    var imgcardType: UIImageView!
    var type: CardType = .Unknown
    var bundle:Bundle!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let podBundle = Bundle(for: KipochiPaymentController.self)
        
        let bundleURL = podBundle.url(forResource: "Kipochi", withExtension: "bundle")
        bundle = Bundle(url: bundleURL!)!
        
        btnPay.layer.cornerRadius = 8
        btnPay.clipsToBounds = true
        
        imgcardType = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: txtCardNumber.frame.size.height))
        imgcardType.contentMode = .center
        imgcardType.image = UIImage(named: "default.png", in: bundle, compatibleWith: nil)
        txtCardNumber.leftView = imgcardType
        txtCardNumber.leftViewMode = .always
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension DebitCreditCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            return true
        }
        let lastText = (text as NSString).replacingCharacters(in: range, with: string) as String
        
        if self.txtCardNumber == textField {
            
            textField.text = lastText.format("nnnn nnnn nnnn nnnn", oldString: text)
            let input = textField.text!
            //Remove Space
            let numberOnly = input.replacingOccurrences(of: [" "," "," "," "], with: "")
            
            // detect card type
            for card in CardType.allCards {
                if (matchesRegex(regex: card.regex, text: numberOnly)) {
                    type = card
                    print(type)
                    self.imgcardType.image = UIImage(named: "\(card).png", in: bundle, compatibleWith: nil)
                    if type == .MasterCard {
                        self.txtSecurityCode.placeholder = "0000"
                    }
                    else {
                        self.txtSecurityCode.placeholder = "000"
                    }
                    break
                }
                else {
                    self.imgcardType.image = UIImage(named: "default.png", in: bundle, compatibleWith: nil)
                    self.txtSecurityCode.placeholder = "000"
                }
            }
            if numberOnly.count > 15{
                if  luhnCheck(number: numberOnly) {
                    self.imgCardNumber.image = UIImage(named: "mark-selected.png", in: bundle, compatibleWith: nil)
                }else {
                    self.imgCardNumber.image = UIImage(named: "mark-unselected.png", in: bundle, compatibleWith: nil)
                }
            }
            else {
                self.imgCardNumber.image = UIImage(named: "mark-unselected.png", in: bundle, compatibleWith: nil)
            }
            return false
        } else if self.txtMothYear == textField {
            textField.text = lastText.format("NN/NNNN", oldString: text)
            //Month-Year Validation
            if validate(value: textField.text!) {
                //Valid
                if UInt(String(textField.text!.suffix(4)))! > Date().year {
                    self.imgMonthYear.image = UIImage(named: "mark-selected.png", in: bundle, compatibleWith: nil)
                }
                else if  UInt(String(textField.text!.prefix(2)))! >= Date().month && UInt(String(textField.text!.suffix(4)))! >= Date().year{
                    self.imgMonthYear.image = UIImage(named: "mark-selected.png", in: bundle, compatibleWith: nil)
                }
                else {
                    self.imgMonthYear.image = UIImage(named: "mark-unselected.png", in: bundle, compatibleWith: nil)
                }
                
            }
            else {
                //InValidate
                self.imgMonthYear.image = UIImage(named: "mark-unselected.png", in: bundle, compatibleWith: nil)
            }
            return false
        } else if self.txtSecurityCode == textField {
            if type == .MasterCard {
                textField.text = lastText.format("NNNN", oldString: text)
            }
            else {
                textField.text = lastText.format("NNN", oldString: text)
            }
            if  textField.text?.count == 3 {
                self.imgCVV.image = UIImage(named: "mark-selected.png", in: bundle, compatibleWith: nil)
            }else {
                self.imgCVV.image = UIImage(named: "mark-unselected.png", in: bundle, compatibleWith: nil)
            }
            return false
        }
        
        return true
    }
}

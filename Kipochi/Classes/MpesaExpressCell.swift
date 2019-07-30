//
//  MpesaExpressCell.swift
//  Kipochi
//
//  Created by Admin on 18/07/19.
//  Copyright © 2019 Sandy. All rights reserved.
//

import UIKit

class MpesaExpressCell: UITableViewCell {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var btnSend: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        btnSend.layer.cornerRadius = 8
        btnSend.clipsToBounds = true
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension MpesaExpressCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else {
            return true
        }
        let lastText = (text as NSString).replacingCharacters(in: range, with: string) as String
        
        if self.txtNumber == textField {
            textField.text = lastText.format("+nnnnnnnnnnnnn", oldString: text)
            return false
        }
        return true
    }
}

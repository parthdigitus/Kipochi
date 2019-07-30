//
//  MpesaCell.swift
//  Kipochi
//
//  Created by Admin on 18/07/19.
//  Copyright © 2019 Sandy. All rights reserved.
//

import UIKit

class MpesaCell: UITableViewCell {

    @IBOutlet weak var lblBussNo: UILabel!
    @IBOutlet weak var lblAccountNo: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var btnPayment: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnPayment.layer.cornerRadius = 8
        btnPayment.clipsToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

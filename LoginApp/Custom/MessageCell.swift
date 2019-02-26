//
//  MessageCell.swift
//  LoginApp
//
//  Created by BZN8 on 23/06/2018.
//  Copyright © 2018 Dawid. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var messageLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageLbl.layer.cornerRadius = messageLbl.frame.height / 2
        messageLbl.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

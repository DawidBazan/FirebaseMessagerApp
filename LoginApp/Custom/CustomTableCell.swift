//
//  CustomTableViewCell.swift
//  LoginApp
//
//  Created by Dawid on 19/03/2018.
//  Copyright © 2018 Dawid. All rights reserved.
//

import UIKit

class CustomTableCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellImg: UIImageView!
    @IBOutlet weak var cellLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

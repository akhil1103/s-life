//
//  AlertTableViewCell.swift
//  S-Life
//
//  Created by balabalaji gowd yelagana on 25/09/21.
//

import UIKit

class AlertTableViewCell: UITableViewCell {

    @IBOutlet weak var alertDescLabel: UILabel!
    @IBOutlet weak var alertCategory: UILabel!
    @IBOutlet weak var alertTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

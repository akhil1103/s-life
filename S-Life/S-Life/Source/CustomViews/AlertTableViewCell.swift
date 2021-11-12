//
//  AlertTableViewCell.swift
//  S-Life
//
//  Created by balabalaji gowd yelagana on 25/09/21.
//

import UIKit

protocol AlertTableViewCellDelegate {
    func locationBtnTapped(atRow: Int)
}

class AlertTableViewCell: UITableViewCell {

    @IBOutlet weak var alertDescLabel: UILabel!
    @IBOutlet weak var alertCategory: UILabel!
    @IBOutlet weak var alertTitle: UILabel!
    var delegate: AlertTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func btnLocationTapped(_ sender: UIButton) {
        self.delegate?.locationBtnTapped(atRow: sender.tag)
    }
    
    @IBOutlet weak var btnLocation: UIButton!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}

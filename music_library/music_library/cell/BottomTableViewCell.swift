//
//  BottomTableViewCell.swift
//  music_library
//
//  Created by Twinbit LTD on 24/11/20.
//

import UIKit

class BottomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var trackName ,artistName : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  FavouriteTableViewCell.swift
//  file_manager_from_sabbir
//
//  Created by Twinbit LTD on 14/11/20.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favouriteImageView : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

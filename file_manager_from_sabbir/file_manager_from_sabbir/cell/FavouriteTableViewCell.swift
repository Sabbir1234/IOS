//
//  FavouriteTableViewCell.swift
//  file_manager_from_sabbir
//
//  Created by Twinbit LTD on 14/11/20.
//

import UIKit

protocol FavouriteCellDelegate: AnyObject {
    func favouriteButtonTapped(cell: FavouriteTableViewCell)
}

class FavouriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favouriteImageView : UIImageView!
    @IBOutlet weak var imageNameLabel : UILabel!
    @IBOutlet weak var starButton : UIButton!
    var delegate : FavouriteCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func starButtonTapped(){
        
        delegate?.favouriteButtonTapped(cell : self)
        
    }
    
}

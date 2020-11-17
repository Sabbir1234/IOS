//
//  TableViewCell.swift
//  file_manager_from_sabbir
//
//  Created by Twinbit LTD on 12/11/20.
//

import UIKit

protocol MyCellDelegate: AnyObject {
    func favouriteButtonTapped(cell: TableViewCell)
}


class TableViewCell: UITableViewCell {
    @IBOutlet weak var coverImageView : UIImageView!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var starButton : UIButton!
    var mark = 0
    weak var delegate: MyCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func starButtonTapped(sender: AnyObject) {
            delegate?.favouriteButtonTapped(cell: self)
//            if mark == 0
//            {
//                mark = 1
//                starButton.setBackgroundImage(UIImage(named: "starMark"), for: UIControl.State.normal)
//            }
//            else{
//                mark = 0
//                starButton.setBackgroundImage(UIImage(named: "star_icon"), for: UIControl.State.normal)
//            }
            
        }
    
    
    
    
    
    
    
}

//
//  CollectionViewCell.swift
//  file_manager_from_sabbir
//
//  Created by Twinbit LTD on 11/11/20.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet  weak var folderNameLabel : UILabel!
    @IBOutlet  weak var folderIcon : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

//
//  PhotoCell.swift
//  EQueoTest
//
//  Created by Alexander Filippov on 8/3/19.
//  Copyright © 2019 Alexander Filippov. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoCell: UICollectionViewCell {
    
     static let reuseId = "PhotoCell"
    
    @IBOutlet weak var photoImage: UIImageView!    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var selectControl: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

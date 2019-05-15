//
//  PhotoCell.swift
//  PixelCity
//
//  Created by Kafkas Baranseli on 16/05/2019.
//  Copyright © 2019 Baranseli. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    // 043 initialise the PhotoCell by init command
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    // 044 fatal error message
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")  // go back to MapVC.swift
    }
}

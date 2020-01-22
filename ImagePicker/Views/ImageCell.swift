//
//  ImageCell.swift
//  ImagePicker
//
//  Created by Alex Paul on 1/20/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
  
  @IBOutlet weak var imageView: UIImageView!
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = 20.0
    backgroundColor = .orange
  }
    
    public func configureCell(imageObject: ImageObject) {
        // converint data to UIImage 
        guard let image = UIImage(data: imageObject.imageData) else {
            return
        }
        imageView.image = image
    }
}

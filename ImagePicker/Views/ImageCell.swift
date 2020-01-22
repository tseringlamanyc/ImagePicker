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
    
    // longpressed recognizer
    private lazy var longPressedGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(longPressedAction(gesture:)))
        return gesture
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 20.0
        backgroundColor = .orange
        addGestureRecognizer(longPressedGesture)
    }
    
    @objc
    private func longPressedAction(gesture: UILongPressGestureRecognizer) {
        
    }
    
    public func configureCell(imageObject: ImageObject) {
        // convering data to UIImage
        guard let image = UIImage(data: imageObject.imageData) else {
            return
        }
        
        imageView.image = image
    }
}

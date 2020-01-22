//
//  ImageCell.swift
//  ImagePicker
//
//  Created by Alex Paul on 1/20/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

// step 1: define protocol
protocol ImageCellDelegate: AnyObject { // anyobject requires imagecelldelegate only works w classes
    // list required functions
    
    func didLongPressed(cell: ImageCell)
}

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    // step 2: optional delegate variable 
    weak var delegate: ImageCellDelegate?
    
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
        if gesture.state == .began {
            gesture.state = .cancelled
            return
        }
        
        // step 3: creating custom delegate to notify any updates when user long presses
        delegate?.didLongPressed(cell: self)  // imagesViewController.didLongPress
        
    }
    
    public func configureCell(imageObject: ImageObject) {
        // convering data to UIImage
        guard let image = UIImage(data: imageObject.imageData) else {
            return
        }
        
        imageView.image = image
    }
}

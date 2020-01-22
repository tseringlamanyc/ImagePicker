//
//  ViewController.swift
//  ImagePicker
//
//  Created by Alex Paul on 1/20/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var imageObjects = [ImageObject]()
    
    private var imagePickerController = UIImagePickerController()
    
    private let dataPersistence = PersistenceHelper(filename: "images.plist")
    
    private var selectedImage: UIImage? {
        didSet {
            appendNewPhoto()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // set UIImagePickerController delegate
        imagePickerController.delegate = self
        loadImageObjects()
    }
    
    private func loadImageObjects() {
        do {
            imageObjects = try dataPersistence.loadEvents()
        } catch {
            print("\(error)")
        }
    }
    
    private func appendNewPhoto() {
        //convert UIImage to data
        guard let image = selectedImage, let imageData = image.jpegData(compressionQuality: 1.0) else {
            return
        }
        // create an image object array
        let imageObject = ImageObject(imageData: imageData, date: Date())
        
        // insert image
        imageObjects.insert(imageObject, at: 0)  // insert at top
        
        // create an indexpath for insertion into collection view
        let indexpath = IndexPath(row: 0, section: 0)
        
        // insert new cell into collection view
        collectionView.insertItems(at: [indexpath]) // adding one at a time
        
        // persist imageObject to documents directory
        do {
           try dataPersistence.create(item: imageObject)
        } catch {
            print("\(error)")
        }
        
        
    }
    
    @IBAction func addPictureButton(_ sender: UIBarButtonItem) {
        // present an action sheet to the user
        // actions: camera, photo library or cancel
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] alertAction in
            self?.showImageController(isCameraSelected: true)
        }
        
        let photoLib = UIAlertAction(title: "Photo Library", style: .default) { [weak self] alertAction in
            self?.showImageController(isCameraSelected: false)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // check if camera is available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertController.addAction(cameraAction)
        }
        
        alertController.addAction(photoLib)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func showImageController(isCameraSelected: Bool) {
        // source type default will be .photoLibrary
        imagePickerController.sourceType = .photoLibrary
        
        if isCameraSelected {
            imagePickerController.sourceType = .camera
        }
        present(imagePickerController, animated: true)
    }
}

extension ImagesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // images comes in a form of a dictionary
        // we need to access the UIImagePickerController.Infokey.original ket to get the UIImage that was selected
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        selectedImage = image
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
}

// MARK: - UICollectionViewDataSource
extension ImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCell else {
            fatalError("could not downcast to an ImageCell")
        }
        let imageObject = imageObjects[indexPath.row]
        cell.configureCell(imageObject: imageObject)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ImagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth: CGFloat = UIScreen.main.bounds.size.width // width of the device
        let itemWidth: CGFloat = maxWidth * 0.80
        return CGSize(width: itemWidth, height: itemWidth)  }
}

// more here: https://nshipster.com/image-resizing/
// MARK: - UIImage extension
extension UIImage {
    func resizeImage(to width: CGFloat, height: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}


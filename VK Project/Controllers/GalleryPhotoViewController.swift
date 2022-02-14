//
//  GalleryPhotoViewController.swift
//  VK Project
//
//  Created by Антон Титов on 05.02.2022.
//

import UIKit

class GalleryPhotoViewController: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var galleryView: GalleryPhotoCustomView!
    
    var photoArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backView.backgroundColor = UIColor.lightGray
        galleryView.setImages(images: photoArray)
    }
}

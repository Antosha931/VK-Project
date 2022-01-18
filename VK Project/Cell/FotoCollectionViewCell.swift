//
//  FotoCollectionViewCell.swift
//  VK Project
//
//  Created by Антон Титов on 18.01.2022.
//

import UIKit

class FotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var savedObject: Any?
    
    func clearCell() {
        photoImageView.image = nil
        savedObject = nil
    }
    
    func configure(image: UIImage) {
        photoImageView.image = image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearCell()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clearCell()
    }

}

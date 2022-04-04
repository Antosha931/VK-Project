//
//  ImageNewsTableViewCell.swift
//  VK Project
//
//  Created by Антон Титов on 03.04.2022.
//

import UIKit

final class ImageNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backVew: UIView!
    @IBOutlet weak var newsImage: UIImageView!
    
    private func clearCell() {
        newsImage.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clearCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearCell()
    }
    
//    func configure(friend: Realm) {
//    }
    
    func configure(image: News) {
        newsImage.image = image.imageNews
    }
}

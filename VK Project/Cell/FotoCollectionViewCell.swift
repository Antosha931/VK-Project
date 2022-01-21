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
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var numberLikeLabel: UILabel!
    
    var savedObject: Any?
    
    var numberLikes: Int = 0
    
    var statusLike = false
    
    func setup() {
        likeImage.image = UIImage(systemName: "heart")
        likeImage.tintColor = UIColor.red
        numberLikeLabel.textColor = UIColor.black
        numberLikeLabel.textAlignment = .center
        numberLikeLabel.font = UIFont(name: "System", size: 20.0)
    }
    
    func clearCell() {
        savedObject = nil
        photoImageView.image = nil
        numberLikeLabel.text = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearCell()
    }
    
    func configure(image: UIImage) {
        photoImageView.image = image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        clearCell()
    }
    
    func animateLikeButton() {
        UIView.transition(with: likeImage,
                          duration: 1,
                          options: .transitionFlipFromLeft,
                          animations: {
                            self.likeImage.image = UIImage(systemName: "heart.fill")
                          },
                          completion: {_ in
                            self.numberLikes += 1
                            self.numberLikeLabel.text = String(self.numberLikes)
                            self.numberLikeLabel.isHidden = false
                            self.statusLike = true
                          })
    }
    
    func animateCancelLikeButton() {
        UIView.transition(with: likeImage,
                          duration: 1,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.likeImage.image = UIImage(systemName: "heart")
                          },
                          completion: {_ in
                            self.numberLikeLabel.isHidden = true
                            self.numberLikes -= 1
                            self.statusLike = false
                          })
    }
    
    @IBAction func likeButton(_ sender: Any) {
        if statusLike == false {
            animateLikeButton()
        } else {
            animateCancelLikeButton()
        }
    }
}

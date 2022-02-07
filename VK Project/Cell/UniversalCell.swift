//
//  UniversalCell.swift
//  VK Project
//
//  Created by Антон Титов on 18.01.2022.
//

import UIKit

class UniversalCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    
    var savedObject: Any?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell() {
        userLabel.font = userLabel.font.withSize(25)
        userLabel.textAlignment = .center
        userLabel.textColor = .black
        backView.layer.cornerRadius = 40
        userImage.layer.cornerRadius = 40
        userImage.backgroundColor = .clear
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = CGSize(width: 10, height: 10)
        backView.layer.shadowRadius = 10
        backView.layer.shadowOpacity = 0.5
    }
    
    func clearCell() {
        userImage.image = nil
        userLabel.text = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearCell()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
        clearCell()
        }

    func configure(image: UIImage?, label: String?) {
        userImage.image = image
        userLabel.text = label
    }
    
    func configure(user: User) {
        savedObject = user
        userLabel.text = user.name
        userImage.image = user.avatar
    }
    
    func configure(group: Group) {
        savedObject = group
        userLabel.text = group.name
        userImage.image = group.avatar
    }
    
    func animatedUserImage() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.stiffness = 300
        animation.mass = 4
        animation.duration = 3
        animation.fillMode = CAMediaTimingFillMode.removed
        self.backView.layer.add(animation, forKey: nil)
    }
    
    @IBAction func avatarButton(_ sender: Any) {
        animatedUserImage()
    }
    
    
}

//
//  AuthorNewsTableViewCell.swift
//  VK Project
//
//  Created by Антон Титов on 03.04.2022.
//

import UIKit

final class AuthorNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backVew: UIView!
    @IBOutlet weak var avatarAuthorNewsImage: UIImageView!
    @IBOutlet weak var nameAuthorNewsLabel: UILabel!
    @IBOutlet weak var dateNewsLabel: UILabel!
    
    private func setupUI() {
        avatarAuthorNewsImage.layer.cornerRadius = 20
    }
    
    private func newsDateFormatter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
    
    private func clearCell() {
        avatarAuthorNewsImage.image = nil
        nameAuthorNewsLabel.text = nil
        dateNewsLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        clearCell()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearCell()
    }
    
//    func configure(friend: Realm) {
//    }
    
    func configure(author: News) {
        avatarAuthorNewsImage.image = author.authorAvatar
        nameAuthorNewsLabel.text = author.authorName
        dateNewsLabel.text = newsDateFormatter(date: author.dateNews)
    }
}

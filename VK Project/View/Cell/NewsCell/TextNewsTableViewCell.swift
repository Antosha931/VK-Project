//
//  TextNewsTableViewCell.swift
//  VK Project
//
//  Created by Антон Титов on 04.04.2022.
//

import UIKit

final class TextNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var newsTextLabel: UILabel!
    
    private func clearCell() {
        newsTextLabel.text = nil
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
    
    func configure(news: News) {
        newsTextLabel.text = news.textNews
    }
}

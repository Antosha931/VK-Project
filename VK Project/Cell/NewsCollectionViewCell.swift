//
//  NewsCollectionViewCell.swift
//  VK Project
//
//  Created by Антон Титов on 30.01.2022.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backVew: UIView!
    @IBOutlet weak var newsLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var shareNewsButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    
    var savedObject: Any?
    var numberOfViews = 0
    var statusLikeButton = false
    
    func setup() {
        backVew.backgroundColor = #colorLiteral(red: 0.9175563373, green: 0.9175563373, blue: 0.9175563373, alpha: 1)
        newsLabel.textColor = .black
        newsLabel.textAlignment = .justified
        newsLabel.numberOfLines = 0
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = UIColor.red
        commentTextField.placeholder = "Оставить комментарий"
        commentTextField.font = UIFont(name: "System", size: 16.0)
        commentTextField.textAlignment = .justified
    }
    
    func clearCell() {
        savedObject = nil
        newsLabel.text = nil
        newsImageView.image = nil
    }
    
    func configure(newsText: String, newsImage: UIImage) {
        newsLabel.text = newsText
        newsImageView.image = newsImage
    }
    
    func configure(news: News) {
        savedObject = news
        newsLabel.text = news.newsText
        newsImageView.image = news.newsImage
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearCell()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        clearCell()
    }
    
    @IBAction func likeButton(_ sender: Any) {
        if statusLikeButton == false {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            statusLikeButton = true
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            statusLikeButton = false
        }
    }
    
    @IBAction func shareNewsButton(_ sender: Any) {
        print("Вы поделились новостью!")
    }
    
}

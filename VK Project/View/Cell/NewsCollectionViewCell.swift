//
//  NewsCollectionViewCell.swift
//  VK Project
//
//  Created by Антон Титов on 30.01.2022.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backVew: UIView!
    @IBOutlet weak var newsTextLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var activeItemBackView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareNewsButton: UIButton!
    @IBOutlet weak var numberOfViewsLabel: UILabel!
    
    private var savedObject: Any?
    private var numberOfViews = Int()
    private var statusLikeButton = false
    
    private func setup() {
        backVew.backgroundColor = #colorLiteral(red: 0.9175563373, green: 0.9175563373, blue: 0.9175563373, alpha: 1)
        activeItemBackView.backgroundColor = backVew.backgroundColor
        newsTextLabel.textColor = .black
        newsTextLabel.textAlignment = .justified
        newsTextLabel.font = UIFont(name: "System", size: 16)
        newsTextLabel.numberOfLines = 0
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        commentButton.setImage(UIImage(systemName: "bubble.right"), for: .normal)
        commentButton.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        shareNewsButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        shareNewsButton.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        numberOfViewsLabel.text = "👁 \(String(numberOfViews))"
        numberOfViewsLabel.font = UIFont(name: "System", size: 16)
        numberOfViewsLabel.textAlignment = .justified
        numberOfViewsLabel.backgroundColor = .blue
        
    }
    
    private func clearCell() {
        savedObject = nil
        newsTextLabel.text = nil
        newsImageView.image = nil
        numberOfViewsLabel.text = nil
    }
    
    func configure(news: News) {
        savedObject = news
        newsTextLabel.text = news.newsText
        newsImageView.image = news.newsImage
        numberOfViews = news.numberOfViews
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
            likeButton.tintColor = .red
            statusLikeButton = true
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            statusLikeButton = false
            likeButton.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
    
    @IBAction func shareNewsButton(_ sender: Any) {
        print("Вы поделились новостью!")
    }
    
}

//
//  InfoPanelTableViewCell.swift
//  VK Project
//
//  Created by Антон Титов on 04.04.2022.
//

import UIKit

final class InfoPanelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var likeNewsButton: UIButton!
    @IBOutlet weak var commentsNewsButton: UIButton!
    @IBOutlet weak var shareNewsButton: UIButton!
    @IBOutlet weak var numbersViewsLabel: UILabel!
    
    private var statusLikeButton = false
    
    private func setupUI() {
        numbersViewsLabel.textColor = .lightGray
        numbersViewsLabel.font = UIFont.systemFont(ofSize: 20)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func configure(news: RealmNews) {
        numbersViewsLabel.text = "👁‍🗨 \(news.viewsCount)"
        statusLikeButton = news.likeStatus
    }
    
//    func configure(news: News) {
//        numbersViewsLabel.text = "👁‍🗨 \(news.numbersViews)"
//    }
    
    @IBAction func likeButton(_ sender: Any) {
        if statusLikeButton == false {
            likeNewsButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
            likeNewsButton.tintColor = .red
            statusLikeButton = true
        } else {
            likeNewsButton.setImage(UIImage(systemName: "heart"), for: .selected)
            statusLikeButton = false
            likeNewsButton.tintColor = .lightGray
        }
    }
    
    @IBAction func commentsButton(_ sender: Any) {
        print("Вы оставили комментарий!")
    }
    
    @IBAction func shareNewsButton(_ sender: Any) {
        print("Вы поделились новостью!")
    }
}

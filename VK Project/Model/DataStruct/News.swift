//
//  News.swift
//  VK Project
//
//  Created by Антон Титов on 04.04.2022.
//

import UIKit

struct News {
    
//    let authorName: String
//    let authorAvatar: UIImage
//    let dateNews: Date
//
//    var textNews: String?
//    var imageNews: UIImage?
//
//    let numbersViews: Int
    
    let date: Int
    let text: String
    let likesCount: Int
    let userLikeStatus: Int
    let viewsCount: Int
    let author: Int
    
    var likeStatus: Bool {
        if userLikeStatus == 1 { return true }
        return false
    }
    
    init (itemsNews: ItemsNews) {
        self.date = itemsNews.date
        self.text = itemsNews.text
        self.likesCount = itemsNews.likes.likesCount
        self.userLikeStatus = itemsNews.likes.userLikeStatus
        self.viewsCount = itemsNews.views.countViews
        self.author = itemsNews.authorNews
    }
}

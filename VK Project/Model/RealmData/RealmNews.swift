//
//  RealmNews.swift
//  VK Project
//
//  Created by Антон Титов on 05.04.2022.
//

import RealmSwift

class RealmNews: Object {
    
    @Persisted (primaryKey: true) var date: Int = 0
    @Persisted var text: String = ""
    @Persisted var likesCount: Int
    @Persisted var userLikeStatus: Int
    @Persisted var viewsCount: Int
    @Persisted var author: Int
    
    
    var likeStatus: Bool {
        if userLikeStatus == 1 { return true }
        return false
    }
    
    convenience init (itemsNews: ItemsNews) {
        self.init()
        self.date = itemsNews.date
        self.text = itemsNews.text
        self.likesCount = itemsNews.likes.likesCount
        self.userLikeStatus = itemsNews.likes.userLikeStatus
        self.viewsCount = itemsNews.views.countViews
        self.author = itemsNews.authorNews
    }
}

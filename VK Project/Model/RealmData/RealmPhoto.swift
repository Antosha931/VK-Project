//
//  RealmPhoto.swift
//  VK Project
//
//  Created by Антон Титов on 01.03.2022.
//

import RealmSwift

class RealmPhoto: Object {
    
    @Persisted (primaryKey: true) var friendId: Int = 0
    @Persisted var likesCount: Int
    @Persisted var ownerId: Int
    @Persisted var userLikeStatus: Int
    @Persisted var photoUrlString: String = ""
    
    var likeStatus: Bool {
        if userLikeStatus == 1 { return true }
        return false
    }
    
    var photo: UIImage? {
        return PhotoProcessing().downloadPhoto(urlString: photoUrlString)
    }
    
    convenience init (itemsPhoto: ItemsPhotoArray) {
        self.init()
        self.friendId = itemsPhoto.id
        self.likesCount = itemsPhoto.likes.likesCount
        self.ownerId = itemsPhoto.ownerId
        self.userLikeStatus = itemsPhoto.likes.userLikeStatus
        self.photoUrlString = itemsPhoto.photoSize.last!.photoUrlString
    }
}

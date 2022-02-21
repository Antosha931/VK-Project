//
//  Photos.swift
//  VK Project
//
//  Created by Антон Титов on 21.02.2022.
//

import UIKit

struct Photos {
    
    let friendId: Int
    let likesCount: Int
    let ownerId: Int
    
    var userLikeStatus: Bool?
    var photo: UIImage?
    
    init?(itemsPhoto: ItemsPhotoArray) {
        self.friendId = itemsPhoto.id
        self.likesCount = itemsPhoto.likes.likesCount
        self.ownerId = itemsPhoto.ownerId
        self.userLikeStatus = likeProcessing(likeStatus: itemsPhoto.likes.userLikeStatus)
        self.photo = downloadPhoto(urlString: itemsPhoto.photoSize.last?.photoUrlString)
    }
    
    func likeProcessing(likeStatus: Int) -> Bool {
        if likeStatus == 1 { return true }
        return false
    }
    
    func downloadPhoto(urlString: String?) -> UIImage? {
        
        guard let url = URL(string: urlString ?? ""),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else { return nil }
        return image
    }
}

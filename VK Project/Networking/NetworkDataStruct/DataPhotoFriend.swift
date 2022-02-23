//
//  DataPhotoFriends.swift
//  VK Project
//
//  Created by Антон Титов on 20.02.2022.
//

import Foundation

struct ResponsePhotoArray: Codable {
    
    let items: [ItemsPhotoArray]
    
    enum CodingKeys: String, CodingKey {
        case items
    }
}

struct ItemsPhotoArray: Codable {
    
    let id: Int
    let likes: PhotoLikes
    let ownerId: Int
    let photoSize: [PhotoSize]
    
    enum CodingKeys: String, CodingKey {
        case id
        case likes
        case ownerId = "owner_id"
        case photoSize = "sizes"
    }
}

struct PhotoLikes: Codable {
    
    let likesCount: Int
    let userLikeStatus: Int
    
    enum CodingKeys: String, CodingKey {
        case likesCount = "count"
        case userLikeStatus = "user_likes"
    }
}

struct PhotoSize: Codable {
    
    let photoUrlString: String
    
    enum CodingKeys: String, CodingKey {
        case photoUrlString = "url"
    }
}

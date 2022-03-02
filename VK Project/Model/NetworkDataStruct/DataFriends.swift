//
//  NetworkUser.swift
//  VK Project
//
//  Created by Антон Титов on 19.02.2022.
//

import Foundation

struct DataFriends: Codable {
    
    let response: ResponseFriends
    
    enum CodingKeys: String, CodingKey {
        case response
    }
}

struct ResponseFriends: Codable {
    
    let items: [ItemsFriend]
    
    enum CodingKeys: String, CodingKey {
        case items
    }
}

struct ItemsFriend: Codable {
    
    let id: Int
    let firstName: String
    let lastName: String
    let avatarPhoto: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarPhoto = "photo_50"

    }
}


//
//  DataGroups.swift
//  VK Project
//
//  Created by Антон Титов on 20.02.2022.
//

import Foundation

struct DataGroups: Codable {
    
    let response: ResponseGroups
    
    enum CodingKeys: String, CodingKey {
        case response
    }
}

struct ResponseGroups: Codable {
    
    let items: [ItemsGroup]
    
    enum CodingKeys: String, CodingKey {
        case items
    }
}

struct ItemsGroup: Codable {
    
    let id: Int
    let name: String
    let avatarPhoto: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatarPhoto = "photo_50"
    }
}

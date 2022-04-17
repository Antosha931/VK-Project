//
//  DataNews.swift
//  VK Project
//
//  Created by Антон Титов on 05.04.2022.
//

import Foundation

struct ResponseNews: Codable {
    
    let groups: [ItemsGroup]
    let items: [ItemsNews]
    let friends: [ItemsFriend]
    
    enum CodingKeys: String, CodingKey {
        case groups
        case items
        case friends = "profiles"
    }
}

struct ItemsNews: Codable {
    
//    let attachments: [Attachments]
    let date: Int
    let text: String
    let likes: PhotoLikes
    let views: Views
    let authorNews: Int

    enum CodingKeys: String, CodingKey {
//        case attachments
        case date
        case text
        case likes
        case views
        case authorNews = "source_id"
    }
}

struct Views: Codable {
    
    let countViews: Int
    
    enum CodingKeys: String, CodingKey {
        case countViews = "count"
    }
}

struct Attachments: Codable {
    
    let photo: PhotoNews
    let video: VideoNews?
    let audio: AudioNews?
    
    enum CodingKeys: String, CodingKey {
        case photo
        case video
        case audio
    }
}

struct PhotoNews: Codable {
    
    let id: Int
    let ownerId: String
    let photoSize: [PhotoNewsSize]
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
        case photoSize = "sizes"
    }
}

struct VideoNews: Codable {
    
    let id: Int
    let photo: [PhotoNewsSize]
    
    enum CodingKeys: String, CodingKey {
        case id
        case photo = "image"
    }
}

struct AudioNews: Codable {
    
    let id: Int
    let artist: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case artist
    }
}

struct PhotoNewsSize: Codable {
    
    let photoUrlString: String
    
    enum CodingKeys: String, CodingKey {
        case photoUrlString = "url"
    }
}

//
//  Friends.swift
//  VK Project
//
//  Created by Антон Титов on 18.01.2022.
//

import UIKit

struct Friend {
    
    let friendId: Int
    let firstName: String
    let lastName: String
    
    var fullName: String {
        return firstName + " " + lastName
    }
    
    var avatar: UIImage?
    
    init?(friendsItems: ItemsFriend) {
        self.friendId = friendsItems.id
        self.firstName = friendsItems.firstName
        self.lastName = friendsItems.lastName
        self.avatar = PhotoProcessing().downloadPhoto(urlString: friendsItems.avatarPhoto)
    }
}

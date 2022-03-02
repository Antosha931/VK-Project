//
//  RealmData.swift
//  VK Project
//
//  Created by Антон Титов on 28.02.2022.
//

import RealmSwift

class RealmFriends: Object {
    
    @Persisted (primaryKey: true) var friendId: Int = 0
    @Persisted var firstName: String = ""
    @Persisted var lastName: String = ""
    @Persisted var avatarUrlString: String = ""
    
    
    var fullName: String {
        return firstName + " " + lastName
    }
    
    var avatar: UIImage? {
        return PhotoProcessing().downloadPhoto(urlString: avatarUrlString)
    }
}
    
extension RealmFriends {
    
    convenience init(itemsFriend: ItemsFriend) {
        self.init()
        self.friendId = itemsFriend.id
        self.firstName = itemsFriend.firstName
        self.lastName = itemsFriend.lastName
        self.avatarUrlString = itemsFriend.avatarPhoto
    }
}

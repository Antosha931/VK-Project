//
//  RealmGroups.swift
//  VK Project
//
//  Created by Антон Титов on 01.03.2022.
//

import RealmSwift

class RealmGroups: Object {
    
    @Persisted (primaryKey: true) var groupId: Int = 0
    @Persisted var name: String = ""
    @Persisted var avatarUrlString: String = ""
    
    var avatar: UIImage? {
        return PhotoProcessing().downloadPhoto(urlString: avatarUrlString)
    }
}
    
extension RealmGroups {
    
    convenience init(itemsGroup: ItemsGroup) {
        self.init()
        self.groupId = itemsGroup.id
        self.name = itemsGroup.name
        self.avatarUrlString = itemsGroup.avatarPhoto
    }
}


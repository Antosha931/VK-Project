//
//  Group.swift
//  VK Project
//
//  Created by Антон Титов on 18.01.2022.
//

import UIKit

struct Groups {
    
    let groupId: Int
    let name: String
    var avatar: UIImage?
    
    init?(itemsGroup: ItemsGroup) {
        self.groupId = itemsGroup.id
        self.name = itemsGroup.name
        self.avatar = downloadPhoto(urlString: itemsGroup.avatarPhoto)
    }
    
    func downloadPhoto(urlString: String) -> UIImage? {
        
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else { return nil }
        return image
    }
}

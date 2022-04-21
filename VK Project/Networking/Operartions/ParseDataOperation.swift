//
//  ParseDataOperation.swift
//  VK Project
//
//  Created by Антон Титов on 18.04.2022.
//

import Foundation
import RealmSwift

class ParseDataOperation: Operation {
    
    var groupItems: [ItemsGroup] = []
    
    override func main() {
        guard let getDataOperation = dependencies.first as? GetDataOperation,
              let data = getDataOperation.data else { return }
        
        do {
            let friendsData = try JSONDecoder().decode(VKResponse<ResponseGroups>.self, from: data)
            
            groupItems = friendsData.response.items
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

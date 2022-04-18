//
//  SaveDataRealmOperation.swift
//  VK Project
//
//  Created by Антон Титов on 18.04.2022.
//

import Foundation
import RealmSwift

class SaveDataRealmOperation: Operation {
    
    var controller: UserGroupTableViewController
    
    init(controller: UserGroupTableViewController) {
        self.controller = controller
    }
    
    override func main() {
        guard let parseData = dependencies.first as? ParseDataOperation else { return }
        
        let realmGroup = parseData.groupItems.map { RealmGroups(itemsGroup: $0) }
        
        do {
            try RealmService.save(items: realmGroup)
        } catch {
            print(error.localizedDescription)
        }
        
        OperationQueue.main.addOperation {
            self.controller.tableView.reloadData()
        }
    }
}

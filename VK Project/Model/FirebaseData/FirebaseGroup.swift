//
//  FirebaseGroup.swift
//  VK Project
//
//  Created by Антон Титов on 01.04.2022.
//

import Foundation
import Firebase

class FirebaseGroup {
    
    var nameGroup: String
    var idGroup: Int
    var ref: DatabaseReference?
    
    init(name: String, id: Int) {
        self.ref = nil
        self.nameGroup = name
        self.idGroup = id
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
              let id = value["idGroup"] as? Int,
              let name = value["nameGroup"] as? String else {
            return nil
        }
        self.ref = snapshot.ref
        self.nameGroup = name
        self.idGroup = id
    }
    
    func toAnyObject() -> [String: Any] {
        return [
            "nameGroup": nameGroup,
            "idGroup": idGroup ]
    }
}

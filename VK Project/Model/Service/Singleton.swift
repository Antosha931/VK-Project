//
//  Singleton.swift
//  VK Project
//
//  Created by Антон Титов on 14.02.2022.
//

import Foundation

final class Session {
    
    var token: String = ""
    var userID: Int = 0
    
    var userIdString: String {
        return String(userID)
    }
    
    static let instance = Session()
    
    private init() { }
}



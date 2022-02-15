//
//  Singleton.swift
//  VK Project
//
//  Created by Антон Титов on 14.02.2022.
//

import Foundation

final class SomeSingleton {
    var token: String = ""
    var userID: Int = 0
    
    static let instance = SomeSingleton()
    
    private init() { }
}



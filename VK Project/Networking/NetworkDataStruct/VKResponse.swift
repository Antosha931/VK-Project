//
//  VKResponse.swift
//  VK Project
//
//  Created by Антон Титов on 24.02.2022.
//

import Foundation

struct VKResponse<T: Codable> : Codable {
    
    let response: T
    
    enum CodingKeys: String, CodingKey {
        case response
    }
}

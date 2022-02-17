//
//  NetworkService.swift
//  VK Project
//
//  Created by Антон Титов on 17.02.2022.
//

import Foundation

class NetworkService {
    
    private var urlConstructorUser: URLComponents = {
        var constructor = URLComponents()
        constructor.scheme = "https"
        constructor.host = "api.vk.com"
        constructor.path = "/method/friends.get"
        
        return constructor
    }()
    
    func fetchUserFriends() {
        var constructor = urlConstructorUser
        constructor.queryItems = [
            URLQueryItem(name: "user_id", value: SomeSingleton.instance.userIdString),
            URLQueryItem(name: "order", value: "hints"),
            URLQueryItem(name: "count", value: "50"),
            URLQueryItem(name: "fields", value: "photo_50"),
            URLQueryItem(name: "access_token", value: SomeSingleton.instance.token),
            URLQueryItem(name: "v", value: "5.131"),
        ]
        
        guard let url = constructor.url else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                let dataString = String(data: data, encoding: .utf8)
                print(dataString)
            }
        }
        task.resume()
    }
    
    private var urlConstructorGroup: URLComponents = {
        var constructor = URLComponents()
        constructor.scheme = "https"
        constructor.host = "api.vk.com"
        constructor.path = "/method/groups.get"
        
        return constructor
    }()
    
    func fetchUserGroup() {
        var constructor = urlConstructorGroup
        constructor.queryItems = [
            URLQueryItem(name: "user_id", value: SomeSingleton.instance.userIdString),
            URLQueryItem(name: "count", value: "50"),
            URLQueryItem(name: "access_token", value: SomeSingleton.instance.token),
            URLQueryItem(name: "v", value: "5.131"),
        ]
        
        guard let url = constructor.url else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                let dataString = String(data: data, encoding: .utf8)
                print(dataString)
            }
        }
        task.resume()
    }
    
    private var urlConstructorGlobalGroup: URLComponents = {
        var constructor = URLComponents()
        constructor.scheme = "https"
        constructor.host = "api.vk.com"
        constructor.path = "/method/groups.search"
        
        return constructor
    }()
    
    func fetchGlobalGroup(groupSearch: String) {
        var constructor = urlConstructorGlobalGroup
        constructor.queryItems = [
            URLQueryItem(name: "user_id", value: SomeSingleton.instance.userIdString),
            URLQueryItem(name: "q", value: groupSearch),
            URLQueryItem(name: "type", value: "group"),
            URLQueryItem(name: "count", value: "50"),
            URLQueryItem(name: "access_token", value: SomeSingleton.instance.token),
            URLQueryItem(name: "v", value: "5.131"),
        ]
        
        guard let url = constructor.url else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                let dataString = String(data: data, encoding: .utf8)
                print(dataString)
            }
        }
        task.resume()
    }
}


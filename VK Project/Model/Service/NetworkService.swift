//
//  NetworkService.swift
//  VK Project
//
//  Created by Антон Титов on 17.02.2022.
//

import Foundation

class NetworkService {
    
    private var urlConstructor: URLComponents = {
        var constructor = URLComponents()
        constructor.scheme = "https"
        constructor.host = "api.vk.com"
        constructor.path = "/method"
        
        return constructor
    }()
    
    
    func fetchUserFriends(completion: @escaping (Result<[ItemsFriend], Error>) -> Void ) {
        var constructor = urlConstructor
        constructor.path = "/method/friends.get"
        constructor.queryItems = [
            URLQueryItem(name: "user_id", value: Session.instance.userIdString),
            URLQueryItem(name: "order", value: "hints"),
            URLQueryItem(name: "count", value: "20"),
            URLQueryItem(name: "fields", value: "photo_50"),
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: "5.131"),
        ]
        
        guard let url = constructor.url else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil,
                  let data = data else { return }
            
            do {
                let friendsData = try JSONDecoder().decode(DataFriends.self, from: data)
                completion(.success(friendsData.response.items))
                
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    func fetchUserGroups(completion: @escaping (Result<[ItemsGroup], Error>) -> Void ) {
        var constructor = urlConstructor
        constructor.path = "/method/groups.get"
        constructor.queryItems = [
            URLQueryItem(name: "user_id", value: Session.instance.userIdString),
            URLQueryItem(name: "count", value: "20"),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: "5.131"),
        ]
        
        guard let url = constructor.url else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil,
                  let data = data else { return }
            
            do {
                let groupsData = try JSONDecoder().decode(DataGroups.self, from: data)
                completion(.success(groupsData.response.items))
                
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    func fetchGlobalGroup(groupSearch: String, completion: @escaping (Result<[ItemsGroup], Error>) -> Void ) {
        var constructor = urlConstructor
        constructor.path = "/method/groups.search"
        constructor.queryItems = [
            URLQueryItem(name: "user_id", value: Session.instance.userIdString),
            URLQueryItem(name: "q", value: groupSearch),
            URLQueryItem(name: "type", value: "group"),
            URLQueryItem(name: "count", value: "10"),
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: "5.131"),
        ]
        
        guard let url = constructor.url else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil,
                  let data = data else { return }
         
            do {
                let groupsData = try JSONDecoder().decode(DataGroups.self, from: data)
                completion(.success(groupsData.response.items))
                
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    func fetchPhotos(friendId: String, completion: @escaping (Result<[ItemsPhotoArray], Error>) -> Void ) {
        var constructor = urlConstructor
        constructor.path = "/method/photos.get"
        constructor.queryItems = [
            URLQueryItem(name: "user_id", value: Session.instance.userIdString),
            URLQueryItem(name: "owner_id", value: friendId),
            URLQueryItem(name: "album_id", value: "profile"),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "count", value: "6"),
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: "5.131"),
        ]

        guard let url = constructor.url else { return }

        let session = URLSession(configuration: .default)

        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil,
                  let data = data else { return }
            
            do {
                let groupsData = try JSONDecoder().decode(DataPhotoFriend.self, from: data)
                completion(.success(groupsData.response.items))
                
            } catch let error as NSError {
                completion(.failure(error))
            }
        }
        task.resume()
//            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
//
//            print(json)
    }
}

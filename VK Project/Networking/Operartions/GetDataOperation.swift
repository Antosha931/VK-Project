//
//  GetDataOperation.swift
//  VK Project
//
//  Created by Антон Титов on 18.04.2022.
//

import Foundation

class GetDataOperation: AsyncOperation {
    
    private var urlConstructor: URLComponents = {
        var constructor = URLComponents()
        constructor.scheme = "https"
        constructor.host = "api.vk.com"
        constructor.path = "/method"
        
        return constructor
    }()
    
    var data: Data?
    
    override func cancel() {
        super.cancel()
    }
    
    override func main() {
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
        
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            if error == nil {
                self.data = data
                self.state = .finished
            }
        }
        task.resume()
    }
}

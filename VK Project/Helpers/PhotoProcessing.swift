//
//  PhotoProcessing.swift
//  VK Project
//
//  Created by Антон Титов on 22.02.2022.
//

import UIKit

class PhotoProcessing {
    
    func downloadPhoto(urlString: String) -> UIImage? {
        
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else { return nil }
        
        return image
    }
}

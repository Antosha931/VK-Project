//
//  PhotoService.swift
//  VK Project
//
//  Created by Антон Титов on 19.04.2022.
//

import UIKit
import RealmSwift

class PhotoService {
    
    private var images = [String: UIImage]()
    private let cacheLifeTime: TimeInterval = 30 * 24 * 60 * 60
    
    private let container: DataReloadable

    init(container: UITableView) {
        self.container = Table(table: container)
    }

    init(container: UICollectionView) {
        self.container = Collection(collection: container)
    }
    
    private static let pathName: String = {
        let pathName = "images"
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName }
        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathName
    }()
    
    func photoLoad(url: String, indexPath: IndexPath) -> UIImage {
        var image = UIImage()
        
        if let photo = images[url] {
            image = photo
        } else if let photo = getImageFromCache(url: url) {
            image = photo
        } else {
            loadPhoto(url: url, indexPath: indexPath)
        }
        
        return image
    }
    
    private func getImageFromCache(url: String) -> UIImage? {
        guard let fileName = getFilePath(url: url),
              let info = try? FileManager.default.attributesOfItem(atPath: fileName),
              let modificationDate = info[FileAttributeKey.modificationDate] as? Date else { return nil }
        
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard lifeTime <= cacheLifeTime,
              let image = UIImage(contentsOfFile: fileName) else { return nil }
        
        DispatchQueue.main.async {
            self.images[url] = image
            print("loading from cache")
        }
        
        return image
    }
    
    private func getFilePath(url: String) -> String? {
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        let hashName = url.split(separator: "/").last ?? "default"
        return cachesDirectory.appendingPathComponent(PhotoService.pathName + "/" + hashName).path
    }
    
    private func loadPhoto(url: String, indexPath: IndexPath) {
        
        guard let image = PhotoProcessing().downloadPhoto(urlString: url) else { return }
        
        DispatchQueue.main.async {
            self.images[url] = image
            print("load")
        }
        
        self.saveImageToCache(url: url, image: image)
        
        DispatchQueue.main.async {
            self.container.reloadRow(indexPath: indexPath)
        }
    }
    
    private func saveImageToCache(url: String, image: UIImage) {
        guard let fileName = getFilePath(url: url),
              let data = image.pngData() else { return }
        
        print("save")
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }
}

fileprivate protocol DataReloadable {
    func reloadRow(indexPath: IndexPath)
}

extension PhotoService {

    private class Table: DataReloadable {
        let table: UITableView

        init(table: UITableView) {
            self.table = table
        }

        func reloadRow(indexPath: IndexPath) {
            table.reloadRows(at: [indexPath], with: .none)
        }
    }

    private class Collection: DataReloadable {
        let collection: UICollectionView

        init(collection: UICollectionView) {
            self.collection = collection
        }

        func reloadRow(indexPath: IndexPath) {
            collection.reloadItems(at: [indexPath])
        }
    }
}

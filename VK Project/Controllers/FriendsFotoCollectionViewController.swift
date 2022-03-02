//
//  FriendsFotoCollectionViewController.swift
//  VK Project
//
//  Created by Антон Титов on 18.01.2022.
//

import UIKit
import RealmSwift

class FriendsFotoCollectionViewController: UICollectionViewController {
    
    private let reuseIdentifier = "FotoCell"
    private let segueIdentifierToGalleryPhoto = "segueIdentifierToGalleryPhoto"
    
    var friendId = Int()
    var photoIndex = Int()
    
    private let networking = NetworkService()
    private var realmPhoto: Results<RealmPhoto>?
    private var photoFriend = [RealmPhoto]()
    
    private var photoArray = [UIImage]()
    
    private func reloadPhoto() {
        
        realmPhoto = try? RealmService.load(typeOf: RealmPhoto.self)
        photoFriend.removeAll()
        photoArray.removeAll()
        
        guard let items = realmPhoto else { return }
        
        for item in items {
            guard let photo = item.photo else { return }
            if item.ownerId == friendId {
                photoFriend.append(item)
                photoArray.append(photo)
            }
        }
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadPhoto()
        
        networking.fetchPhotos(friendId: String(friendId), completion: { [weak self] result in
            switch result {
            case .success(let itemsPhoto):
                let realmPhoto = itemsPhoto.map {RealmPhoto.init(itemsPhoto: $0)}
                DispatchQueue.main.async {
                    do {
                        try RealmService.save(items: realmPhoto)
                        self?.reloadPhoto()
                    } catch {
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        })
        
        self.collectionView.register(UINib(nibName: "FotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoFriend.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
                as? FotoCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(friendPhoto: photoFriend[indexPath.item])
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        photoIndex = indexPath.item
        performSegue(withIdentifier: segueIdentifierToGalleryPhoto, sender: photoArray)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifierToGalleryPhoto,
           let dst = segue.destination as? GalleryPhotoViewController {
            dst.photoArray = self.photoArray
            dst.photoIndex = self.photoIndex
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension FriendsFotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}


//
//  FriendsFotoCollectionViewController.swift
//  VK Project
//
//  Created by Антон Титов on 18.01.2022.
//

import UIKit
import RealmSwift

final class FriendsFotoCollectionViewController: UICollectionViewController {
    
    private let reuseIdentifier = "FotoCell"
    private let segueIdentifierToGalleryPhoto = "segueIdentifierToGalleryPhoto"
    
    var friendId = Int()
    var photoIndex = Int()
    
    private let networking = NetworkService()
    private var realmPhoto: Results<RealmPhoto>?
    private var photoFriend = [RealmPhoto]()
    private var photoToken: NotificationToken?
    private var photoService: PhotoService?
    
    private var photoArray = [UIImage]()
    
    private func reloadPhotoData() {
        realmPhoto = try? RealmService.load(typeOf: RealmPhoto.self)
        
        guard let items = realmPhoto else { return }
        
        for item in items {
            if item.ownerId == friendId {
                photoFriend.append(item)
            }
        }
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoService = PhotoService(container: collectionView)
        
        DispatchQueue.global(qos: .userInteractive).async {
            self.networking.fetchPhotos(friendId: String(self.friendId), completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let itemsPhoto):
                    let realmPhoto = itemsPhoto.map {RealmPhoto(itemsPhoto: $0)}
                    DispatchQueue.main.async {
                        do {
                            try RealmService.save(items: realmPhoto)
                            self.reloadPhotoData()
                        } catch {
                            print(error)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            })
        }
        
        self.collectionView.register(UINib(nibName: "FotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        photoToken = realmPhoto?.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case .initial(_):
                self.collectionView.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                self.collectionView.reloadData()
                print(deletions, insertions, modifications)
            case .error(let error):
                print(error)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        photoToken?.invalidate()
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoFriend.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
                as? FotoCollectionViewCell else { return UICollectionViewCell() }
        
        if let photo = photoService?.photoLoad(url: photoFriend[indexPath.item].photoUrlString, indexPath: indexPath) {
            photoArray.append(photo)
        }
        
        cell.configure(friendPhotoItems: photoFriend[indexPath.item], friendPhoto: photoArray[indexPath.item])
        
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


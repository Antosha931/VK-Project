//
//  FriendsFotoCollectionViewController.swift
//  VK Project
//
//  Created by Антон Титов on 18.01.2022.
//

import UIKit


class FriendsFotoCollectionViewController: UICollectionViewController {
    
    private let reuseIdentifier = "FotoCell"
    private let segueIdentifierToGalleryPhoto = "segueIdentifierToGalleryPhoto"
    
    var friendId = Int()
    
    private let networking = NetworkService()
    private var photoItems = [ItemsPhotoArray]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private var photoArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networking.fetchPhotos(friendId: String(friendId), completion: { [weak self] result in
            switch result {
            case .success(let itemsPhoto):
                self?.photoItems = itemsPhoto
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
        return photoItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
                as? FotoCollectionViewCell else { return UICollectionViewCell() }
        
        if let items = Photos(itemsPhoto: photoItems[indexPath.item]),
           items.photo != nil {
            cell.configure(friendPhoto: items)
            photoArray.append(items.photo!)
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueIdentifierToGalleryPhoto, sender: photoArray)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifierToGalleryPhoto,
           let dst = segue.destination as? GalleryPhotoViewController {
            dst.photoArray = self.photoArray
        }
    }
}

extension FriendsFotoCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 208, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
}


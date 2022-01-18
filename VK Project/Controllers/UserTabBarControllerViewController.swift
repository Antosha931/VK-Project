//
//  UserTabBarControllerViewController.swift
//  VK Project
//
//  Created by Антон Титов on 06.01.2022.
//

import UIKit

class UserTabBarControllerViewController: UITabBarController {
    
    func setupUser() -> [User] {
        
        var resultArray = [User]()
        
        let userOnePhotoArray = [UIImage(named: "1_1")!, UIImage(named: "1_2")!, UIImage(named: "1_3")!, UIImage(named: "1_4")!]
        let userOne = User(name: "Shibkov Roman", avatar: UIImage(named: "1_1")!, photoArray: userOnePhotoArray)
        
        resultArray.append(userOne)
        
        let userTwoPhotoArray = [UIImage(named: "2_1")!, UIImage(named: "2_2")!, UIImage(named: "2_3")!, UIImage(named: "2_4")!]
        let userTwo = User(name: "Modin Alex", avatar: UIImage(named: "2_1")!, photoArray: userTwoPhotoArray)
        
        resultArray.append(userTwo)
        
        let userThreePhotoArray = [UIImage(named: "3_1")!, UIImage(named: "3_2")!, UIImage(named: "3_3")!, UIImage(named: "3_4")!]
        let userThree = User(name: "Sycheskiy Alex", avatar: UIImage(named: "3_1")!, photoArray: userThreePhotoArray)
        
        resultArray.append(userThree)
        
        let userFourPhotoArray = [UIImage(named: "4_1")!, UIImage(named: "4_2")!, UIImage(named: "4_3")!, UIImage(named: "4_4")!]
        let userFour = User(name: "Kuznetsov Ivan", avatar: UIImage(named: "4_1")!, photoArray: userFourPhotoArray)
        
        resultArray.append(userFour)
        
        let sortiredNames = resultArray.sorted(by: {$0.name < $1.name})
        
        resultArray = sortiredNames
        
        return resultArray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let friendsNavigationController = self.viewControllers?.first as? UINavigationController,
           let friendsVC = friendsNavigationController.viewControllers.first as? FriendsTableViewController {
            friendsVC.configure(userArray: setupUser())
        }
    }
}

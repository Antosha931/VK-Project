//
//  FriendsTableTableViewController.swift
//  VK Project
//
//  Created by Антон Титов on 06.01.2022.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    
    @IBOutlet var friendsTableView: UITableView! {
        didSet {
            friendsTableView.delegate = self
            friendsTableView.dataSource = self
        }
    }
    
    var savedObject: Any?
    
    private let networking = NetworkService()
    private var friendsArray = [ItemsFriend]() {
        didSet {
            DispatchQueue.main.async {
                self.friendsTableView.reloadData()
            }
        }
    }
    
    private let reuseIdentifierUserTableCell = "UserCell"
    private let segueIdentifierToFotoController = "segueIdentifierToFotoController"
    
    private func sortingFriendsNames() -> [String] {
        var lettersArray: [String] = []
        
        for user in friendsArray {
            let letter = String(user.lastName.prefix(1))
            if !lettersArray.contains(letter) {
                lettersArray.append(letter)
            }
        }
        
        let sortiredNames = lettersArray.sorted(by: {$0 < $1})
        
        return sortiredNames
    }
    
    private func filterByAlphabet(lettersArray: String) -> [ItemsFriend] {
        var lettersOfName: [ItemsFriend] = []
        
        for item in friendsArray {
            let nameLetter = String(item.lastName.prefix(1))
            if nameLetter == lettersArray {
                lettersOfName.append(item)
            }
        }
        return lettersOfName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networking.fetchUserFriends { [weak self] result in
            switch result {
            case .success(let friends):
                self?.friendsArray = friends
            case .failure(let error):
                print(error)
            }
        }
        
        self.clearsSelectionOnViewWillAppear = false
        
        friendsTableView.register(UINib(nibName: "UniversalCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierUserTableCell)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sortingFriendsNames().count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterByAlphabet(lettersArray: sortingFriendsNames()[section]).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierUserTableCell, for: indexPath)
                as? UniversalCell else { return UITableViewCell() }
        
        let arrayLetter = filterByAlphabet(lettersArray: sortingFriendsNames()[indexPath.section])
        
        if let itemsFriends = Friend(friendsItems: arrayLetter[indexPath.row]) {
            cell.configure(user: itemsFriends)
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - Table view Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           guard let cell = tableView.cellForRow(at: indexPath) as? UniversalCell,
                 let cellObject = cell.savedObject as? Friend else { return }
           performSegue(withIdentifier: segueIdentifierToFotoController, sender: cellObject)
       }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortingFriendsNames()[section].uppercased()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifierToFotoController,
           let dst = segue.destination as? FriendsFotoCollectionViewController,
           let friend = sender as? Friend {
            dst.friendId = friend.friendId
        }
    }
}
 

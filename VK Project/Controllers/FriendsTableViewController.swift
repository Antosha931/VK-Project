//
//  FriendsTableTableViewController.swift
//  VK Project
//
//  Created by Антон Титов on 06.01.2022.
//

import UIKit
import RealmSwift
import FirebaseAuth

class FriendsTableViewController: UITableViewController {
    
    @IBOutlet var friendsTableView: UITableView! {
        didSet {
            friendsTableView.delegate = self
            friendsTableView.dataSource = self
        }
    }
    
    private let reuseIdentifierUserTableCell = "UserCell"
    private let segueIdentifierToFotoController = "segueIdentifierToFotoController"
    
    var savedObject: Any?
    
    private let networking = NetworkService()
    private var realmFriend: Results<RealmFriends>?
    private var friendsToken: NotificationToken?
    
    private func sortingFriendsNames() -> [String] {
        var lettersArray: [String] = []
        guard let friends = realmFriend else { return lettersArray }
        for friend in friends {
            let letter = String(friend.lastName.prefix(1))
            if !lettersArray.contains(letter) {
                lettersArray.append(letter)
            }
        }
        
        let sortiredNames = lettersArray.sorted(by: {$0 < $1})
        
        return sortiredNames
    }
    
    private func filterByAlphabet(lettersArray: String) -> [RealmFriends] {
        var lettersOfName: [RealmFriends] = []
        guard let friends = realmFriend else { return lettersOfName }
        for item in friends {
            let nameLetter = String(item.lastName.prefix(1))
            if nameLetter == lettersArray {
                lettersOfName.append(item)
            }
        }
        return lettersOfName
    }
    
    private func reloadDataFriends() {
        realmFriend = try? RealmService.load(typeOf: RealmFriends.self)
        
        friendsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = false
                
        friendsTableView.register(UINib(nibName: "UniversalCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierUserTableCell)
        
        reloadDataFriends()
        
        networking.fetchUserFriends { [weak self] result in
            switch result {
            case .success(let friends):
                let realmFriend = friends.map { RealmFriends(itemsFriend: $0) }
                DispatchQueue.main.async {
                    do {
                        try RealmService.save(items: realmFriend)
                        self?.reloadDataFriends()
                    } catch {
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        
        self.clearsSelectionOnViewWillAppear = false
        
        friendsTableView.register(UINib(nibName: "UniversalCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierUserTableCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        friendsToken = realmFriend?.observe { [weak self] changes in
            switch changes {
            case .initial(_):
                self?.friendsTableView.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                print(deletions, insertions, modifications)
                self?.friendsTableView.reloadData()
            case .error(let error):
                print(error)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        friendsToken?.invalidate()
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

        cell.configure(friend: arrayLetter[indexPath.row])
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - Table view Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           guard let cell = tableView.cellForRow(at: indexPath) as? UniversalCell,
                 let cellObject = cell.savedObject as? RealmFriends else { return }
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
           let friend = sender as? RealmFriends {
            dst.friendId = friend.friendId
        }
    }
    
    @IBAction func exitButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            guard let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") else { return }
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true, completion: nil)
        } catch (let error) {
            print("Auth sign out failed: \(error)") }
    }
}
 

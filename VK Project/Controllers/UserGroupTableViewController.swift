//
//  GroupTableViewController.swift
//  VK Project
//
//  Created by Антон Титов on 06.01.2022.
//

import UIKit

class UserGroupTableViewController: UITableViewController {
    
    private let groupSearchBar = UISearchBar()
    
    private let reuseIdentifierUserGroupCell = "UserGroupCell"
    private let segueIdentifierToGlobalGroupController = "segueIdentifierToGlobalGroupController"
    
    private let networking = NetworkService()
    private var groupItems = [ItemsGroup]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var resultSearchGroup = [ItemsGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = false
        groupSearchBar.delegate = self
        
        networking.fetchUserGroups { [weak self] result in
            switch result {
            case .success(let groupItems):
                self?.groupItems = groupItems
            case .failure(let error):
                print(error)
            }
        }
        
        self.tableView.register(UINib(nibName: "UniversalCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierUserGroupCell)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addNewGroup(_:)), name: NSNotification.Name(rawValue: "sendGroup"), object: nil)
    }
    
    private func isContainInArray(group: ItemsGroup) -> Bool {
        if groupItems.contains(where: { itemGroup in itemGroup.name == group.name}) {
            return true
        }
        return false
    }
    
    @objc func addNewGroup(_ notification: Notification) {
        
        guard let newGroup = notification.object as? ItemsGroup else {return}
        
        if isContainInArray(group: newGroup) {
            return
        }
        groupItems.append(newGroup)
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchGroup.isEmpty {
            return groupItems.count
        }
        return resultSearchGroup.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierUserGroupCell, for: indexPath)
                as? UniversalCell else { return UITableViewCell() }
        
        if resultSearchGroup.isEmpty,
           let itemsGroup = Groups(itemsGroup: groupItems[indexPath.row]) {
            cell.configure(group: itemsGroup)
        } else if let itemsGroup = Groups(itemsGroup: resultSearchGroup[indexPath.row]) {
            cell.configure(group: itemsGroup)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - Table view Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension UserGroupTableViewController: UISearchBarDelegate {
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return groupSearchBar
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            resultSearchGroup = groupItems
        } else {
            resultSearchGroup = groupItems.filter({ item in
                item.name.lowercased().contains(searchText.lowercased())
            })
        }
        self.tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.tableView.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultSearchGroup = groupItems
    }
    
}

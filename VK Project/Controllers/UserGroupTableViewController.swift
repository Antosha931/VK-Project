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
    
    var userGroup = [Group]()
    
    private var resultSearchGroup = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = false
        self.tableView.delegate = self
        
        groupSearchBar.delegate = self
        
        self.tableView.register(UINib(nibName: "UniversalCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierUserGroupCell)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addNewGroup(_:)), name: NSNotification.Name(rawValue: "sendGroup"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resultSearchGroup = userGroup
        self.tableView.reloadData()
    }
    
    func isContainInArray(group: Group) -> Bool {
        if userGroup.contains(where: { itemGroup in itemGroup.name == group.name}) {
            return true
        }
        return false
    }
    
    @objc func addNewGroup(_ notification: Notification) {
        
        guard let newGroup = notification.object as? Group else {return}
        
        if isContainInArray(group: newGroup) {
            return
        }
        userGroup.append(newGroup)
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultSearchGroup.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierUserGroupCell, for: indexPath)
                as? UniversalCell else { return UITableViewCell() }
        
        cell.configure(group: resultSearchGroup[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        userGroup.remove(at: indexPath.row)
        resultSearchGroup.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
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
            resultSearchGroup = userGroup
        } else {
            resultSearchGroup = userGroup.filter({ item in
                item.name.lowercased().contains(searchText.lowercased())
            })
        }
        self.tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.tableView.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultSearchGroup = userGroup
    }
    
}

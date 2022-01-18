//
//  GroupTableViewController.swift
//  VK Project
//
//  Created by Антон Титов on 06.01.2022.
//

import UIKit

class UserGroupTableViewController: UITableViewController {
    
    let reuseIdentifierUserGroupCell = "UserGroupCell"
    let segueIdentifierToGlobalGroupController = "segueIdentifierToGlobalGroupController"
    
    var userGroup = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = false
        self.tableView.delegate = self
        
        self.tableView.register(UINib(nibName: "UniversalCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierUserGroupCell)
        
        NotificationCenter.default.addObserver(self, selector: #selector(addNewGroup(_:)), name: NSNotification.Name(rawValue: "sendGroup"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        return userGroup.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierUserGroupCell, for: indexPath)
                as? UniversalCell else { return UITableViewCell() }
        
        cell.configure(group: userGroup[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        userGroup.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Table view Delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//
//  GroupTableViewController.swift
//  VK Project
//
//  Created by Антон Титов on 06.01.2022.
//

import UIKit
import RealmSwift

class UserGroupTableViewController: UITableViewController {
    
    private var groupSearchBar = UISearchBar()
    
    private let reuseIdentifierUserGroupCell = "UserGroupCell"
    private let segueIdentifierToGlobalGroupController = "segueIdentifierToGlobalGroupController"
    
    private let networking = NetworkService()
    private var realmGroups: Results<RealmGroups>?
    private var groupsToken: NotificationToken?
    private var groupItems = [RealmGroups]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var resultSearchGroup = [RealmGroups]()
    
    private func reloadGroups() {
        realmGroups = try? RealmService.load(typeOf: RealmGroups.self)
        
        groupItems = groupSorting()
        
        self.tableView.reloadData()
    }
    
    private func groupSorting() -> [RealmGroups] {
        var lettersOfName: [RealmGroups] = []
        guard let groups = realmGroups else { return lettersOfName }
        for item in groups {
            if !lettersOfName.contains(item) {
                lettersOfName.append(item)
            }
        }
        return lettersOfName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = false
        groupSearchBar.delegate = self
        
        networking.fetchUserGroups { [weak self] result in
            switch result {
            case .success(let groupItems):
                let realmGroup = groupItems.map { RealmGroups(itemsGroup: $0) }
                DispatchQueue.main.async {
                    do {
                        try RealmService.save(items: realmGroup)
                        self?.reloadGroups()
                    } catch {
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        
        self.tableView.register(UINib(nibName: "UniversalCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierUserGroupCell)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(addNewGroup(_:)), name: NSNotification.Name(rawValue: "sendGroup"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        groupsToken = realmGroups?.observe { [weak self] changes in
            switch changes {
            case .initial(_):
                self?.tableView.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                print(deletions, insertions, modifications)
                self?.tableView.beginUpdates()
                self?.tableView.insertRows(at: deletions.map( {IndexPath(row: $0, section: 0)} ), with: .automatic)
                self?.tableView.insertRows(at: insertions.map( {IndexPath(row: $0, section: 0)} ), with: .automatic)
                self?.tableView.insertRows(at: modifications.map( {IndexPath(row: $0, section: 0)} ), with: .automatic)
                self?.tableView.endUpdates()
            case .error(let error):
                print(error)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        groupsToken?.invalidate()
    }
    
//    private func isContainInArray(group: ItemsGroup) -> Bool {
//        if groupItems.contains(where: { itemGroup in itemGroup.name == group.name}) {
//            return true
//        }
//        return false
//    }
//
//    @objc func addNewGroup(_ notification: Notification) {
//
//        guard let newGroup = notification.object as? ItemsGroup else {return}
//
//        if isContainInArray(group: newGroup) {
//            return
//        }
//        groupItems.append(newGroup)
//        self.tableView.reloadData()
//    }
    
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
        
        if resultSearchGroup.isEmpty {
            cell.configure(group: groupItems[indexPath.row])
        } else {
            cell.configure(group: resultSearchGroup[indexPath.row])
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
}

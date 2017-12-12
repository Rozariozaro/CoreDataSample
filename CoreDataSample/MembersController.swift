//
//  MembersController.swift
//  CoreDataSample
//
//  Created by Rozario on 12/11/17.
//  Copyright © 2017 VisionReached. All rights reserved.
//

import UIKit
import CoreData

protocol MembersSelectionDelegate: class {
    func didSelect(members: [User])
}

class MembersController: UIViewController {

    @IBOutlet weak var memberstable: UITableView! {
        didSet {
            memberstable.allowsMultipleSelection = true
        }
    }
    
    var defaultMembers: [User] = Array() {
        didSet {
            memberstable.reloadData()
        }
    }
    
    weak var delegate: MembersSelectionDelegate?
    
    var selectedUsers: [User] = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDefaultUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for selectedUser in selectedUsers {
            if let index = defaultMembers.index(where: {return $0.name == selectedUser.name}) {
                let indexPath = IndexPath(row: index, section: 0)
                memberstable.selectRow(at: indexPath, animated: true, scrollPosition: .none)
            }
        }
    }
    
    func fetchDefaultUsers() {
        let managedContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        // fetch request
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "name != %@", "")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        // fetch from moc
        do {
            defaultMembers = try managedContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }

    @IBAction func doneBtnTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnTapped(_ sender: UIBarButtonItem) {
        if let selectedIndexPath = memberstable.indexPathsForSelectedRows {
            let selectedUsers = selectedIndexPath.map({ (indexPath) -> User in
                return defaultMembers[indexPath.row]
            })
            delegate?.didSelect(members: selectedUsers)
        }
        navigationController?.popViewController(animated: true)
    }
}

extension MembersController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaultMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "membersCell")
        cell.selectionStyle = .none // to prevent cells from being "highlighted"
        let user = defaultMembers[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = "\(user.id)"
        cell.accessoryType = selectedUsers.contains(user) ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
}

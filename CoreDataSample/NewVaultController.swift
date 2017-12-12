//
//  NewVaultController.swift
//  CoreDataSample
//
//  Created by Rozario on 12/11/17.
//  Copyright © 2017 VisionReached. All rights reserved.
//

import UIKit
import CoreData

class NewVaultController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var membersTable: UITableView!
    var selectedMembers: [User] = Array() {
        didSet {
            membersTable.reloadData()
        }
    }
    
    var vault: Vault? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let vault = vault else {return}
        nameTextField.text = vault.name
        idTextField.text = "\(vault.id)"
        if let members: [User] = Array(vault.members ?? []) as? [User] {
            selectedMembers = members
        } else {
            selectedMembers = []
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addMembersBtnTapped(_ sender: UIButton) {
        let membersVc = self.storyboard?.instantiateViewController(withIdentifier: "MembersController") as! MembersController
        membersVc.delegate = self
        membersVc.selectedUsers = selectedMembers
        navigationController?.pushViewController(membersVc, animated: true)
    }
    
    @IBAction func saveBtnTapped(_ sender: UIBarButtonItem) {
        if nameTextField.text == "" {
            let alert = showAlert(withText: "Please enter the name of the vault.", okAction: { (action) in
                self.dismiss(animated: true, completion: {
                    self.nameTextField.becomeFirstResponder()
                })
            })
            self.present(alert, animated: true, completion: nil)
        } else if idTextField.text == "" {
            let alert = showAlert(withText: "Please enter the id of the vault.", okAction: { (action) in
                self.dismiss(animated: true, completion: {
                    self.idTextField.becomeFirstResponder()
                })
            })
            self.present(alert, animated: true, completion: nil)
        } else {
            let name = nameTextField.text!
            let id = idTextField.text!
            let members = selectedMembers
            
            let managedContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
            guard let entity = NSEntityDescription.entity(forEntityName: "Vault", in: managedContext) else {return}
            if let vault = vault {
                vault.name = nameTextField.text!
                vault.id = Int32(id) ?? 0
                vault.members = NSSet(array: members)
            } else {
                let newVault = Vault(entity: entity, insertInto: managedContext)
                newVault.name = name
                newVault.id = Int32(id) ?? 0
                newVault.members = NSSet(array: members)
            }
            
            do {
                try managedContext.save()
                navigationController?.popViewController(animated: true)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension NewVaultController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedMembers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "membersCell")
        let user = selectedMembers[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = "\(user.id)"
        return cell
    }
}

extension NewVaultController: MembersSelectionDelegate {
    func didSelect(members: [User]) {
        selectedMembers = members
    }
}

func showAlert(withText text: String, okAction: @escaping (_ action: UIAlertAction)-> Void) -> UIAlertController {
    let alertVc = UIAlertController(title: "CoreData", message: text, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "Ok", style: .default, handler: okAction)
    return alertVc
}

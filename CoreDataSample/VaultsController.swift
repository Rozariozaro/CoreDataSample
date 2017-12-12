//
//  ViewController.swift
//  CoreDataSample
//
//  Created by Rozario on 12/11/17.
//  Copyright © 2017 VisionReached. All rights reserved.
//

import UIKit
import CoreData

class VaultsController: UIViewController {

    @IBOutlet weak var vaultListTable: UITableView!
    
    var vaults: [Vault] = Array() {
        didSet{
            vaultListTable.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addDefaultUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vaultListTable.reloadData()
        fetchVaultsFromCoreData()
    }
    
    @IBAction func addNewVaultBtnTapped(_ sender: UIBarButtonItem) {
        let newVaultVC = self.storyboard?.instantiateViewController(withIdentifier: "NewVaultController") as! NewVaultController
        navigationController?.pushViewController(newVaultVC, animated: true)
    }
    
    func fetchVaultsFromCoreData() {
        let managedContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Vault>(entityName: "Vault")
        fetchRequest.predicate = NSPredicate(format: "name != \"\"")
        do {
            vaults = try managedContext.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addDefaultUsers() {
        // get viewContext
        let managedContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        // create entityDescription
        guard let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext) else {return}
        // create new User managedObject
        
        let defaultMembers = ["Rozario Rapheal", "Gokulakannan", "Tamil Vendhan", "Thilak Antony", "Dhamodaran Sri", "Senthil Kumar", "Gaja Lakshmi", "Suneel Seelam", "Jaya Priya"]
        
        for (i, eachMember) in defaultMembers.enumerated() {
            if let user = checkForValueInCoreData(name: eachMember) {
                // update already exisisting user
                user.name = eachMember
                user.id = Int32(i+1)
            } else {
                // create new user
                let user = User(entity: entity, insertInto: managedContext)
                user.name = eachMember
                user.id = Int32(i+1)
            }
        }
        
        // save to moc
        do {
            try managedContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func checkForValueInCoreData(name: String) -> User? {
        let managedContext = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<User>(entityName: "User")
        fetchReq.predicate = NSPredicate(format: "name == %@", name)
        do {
            let fetchResult = try managedContext.fetch(fetchReq)
            if fetchResult.count > 0 {
                return fetchResult[0]
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}

extension VaultsController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vaults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "vaultCell")
        let vault = vaults[indexPath.row]
        cell.textLabel?.text = vault.name
        cell.detailTextLabel?.text = "\(vault.id)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vault = vaults[indexPath.row]
        let newVaultsVC = self.storyboard?.instantiateViewController(withIdentifier: "NewVaultController") as! NewVaultController
        newVaultsVC.vault = vault
        self.navigationController?.pushViewController(newVaultsVC, animated: true)
    }
}



//
//  TableViewController.swift
//  LoginApp
//
//  Created by Dawid on 19/03/2018.
//  Copyright © 2018 Dawid. All rights reserved.
//

import UIKit
import Firebase

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var ref: DatabaseReference!
    fileprivate var _refHandle: DatabaseHandle!

    var contactsUID: [String] = []
    let userNames = ["Dan", "Steve", "John", "Rachel", "Hannah"]
    let profileImgArray = [UIImage(named: "profile1"), UIImage(named: "profile2"), UIImage(named: "profile3"), UIImage(named: "profile4"), UIImage(named: "profile5")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureDatabase()
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.title = "Chats"
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableCell
        cell.cellLbl?.text = userNames[indexPath.row]
        cell.cellImg.image = UIImage (named: "profile\(indexPath.row+1)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "startMessaging", sender: self)
    }
    
    func configureDatabase() {
        let user = Auth.auth().currentUser
        ref = Database.database().reference()
        _refHandle = ref.child("Users").child((user?.uid)!).child("Contacts").observe(.value) { (snapshot: DataSnapshot) in
            
            let contacts = snapshot.value as? NSArray
        
            for contact in contacts! {
            self.contactsUID.append(contact as! String)
            print(self.contactsUID)
            // uid.child message unique id, message content
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MessagingVC {
            destination.contactUID = contactsUID[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
}

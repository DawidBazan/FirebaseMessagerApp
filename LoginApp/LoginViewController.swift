//
//  LoginViewController.swift
//  LoginApp
//
//  Created by Dawid on 10/03/2018.
//  Copyright © 2018 Dawid. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var userNameLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var user = Auth.auth().currentUser?.email?.components(separatedBy: "@")
        
        userNameLbl.text = user![0]
    }
    
    var profileImgArray = [UIImage(named: "profile1"), UIImage(named: "profile2"), UIImage(named: "profile3"), UIImage(named: "profile4"), UIImage(named: "profile5")]
    
    var nameArray = ["Frank", "Jessica", "Sarah", "Paul", "Steve"]
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileImgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        
        cell.profileImage.image = profileImgArray[indexPath.row]
        cell.profileName.text = nameArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "chat", sender: self)
    }
}


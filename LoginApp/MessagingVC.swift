//
//  MessagingVC.swift
//  LoginApp
//
//  Created by BZN8 on 02/06/2018.
//  Copyright © 2018 Dawid. All rights reserved.
//

import UIKit
import Firebase

class MessagingVC: UIViewController, UINavigationControllerDelegate {
    
    // MARK: Properties
    var ref: DatabaseReference!
    var messages: [DataSnapshot]! = []
    var msglength: NSNumber = 1000
    var storageRef: StorageReference!
    var remoteConfig: RemoteConfig!
    let imageCache = NSCache<NSString, UIImage>()
    var keyboardOnScreen = false
    var placeholderImage = UIImage(named: "profile1")
    fileprivate var _refHandle: DatabaseHandle!
    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
    var user: User?
    var contactUID: String?
    // MARK: Outlets
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    //@IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var imageMessage: UIButton!
    //@IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var messagesTable: UITableView!
    //@IBOutlet weak var backgroundBlur: UIVisualEffectView!
    @IBOutlet weak var imageDisplay: UIImageView!
    @IBOutlet var dismissImageRecognizer: UITapGestureRecognizer!
    @IBOutlet var dismissKeyboardRecognizer: UITapGestureRecognizer!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        self.signedInStatus(isSignedIn: true)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    // MARK: Config
    
    func configureAuth() {
        // TODO: configure firebase authentication
    }
    
    func configureDatabase() {
        user = Auth.auth().currentUser
        ref = Database.database().reference()
        _refHandle = ref.child("Users").child((user?.uid)!).child("messages").child(contactUID!).observe(.childAdded) { (snapshot: DataSnapshot) in
            self.messages.append(snapshot)
            self.messagesTable.insertRows(at: [IndexPath(row: self.messages.count - 1, section: 0)], with: .automatic)
            self.scrollToBottomMessage()
        }
    }
    
    func configureStorage() {
        // TODO: configure storage using your firebase storage
    }
    
    deinit {
        
        ref.child("Users").child((user?.uid)!).child("messages").removeObserver(withHandle: _refHandle)
        // TODO: set up what needs to be deinitialized when view is no longer being used
    }
    
    // MARK: Remote Config
    
    func configureRemoteConfig() {
        // TODO: configure remote configuration settings
    }
    
    func fetchConfig() {
        // TODO: update to the current coniguratation
    }
    
    // MARK: Sign In and Out
    
    func signedInStatus(isSignedIn: Bool) {
        //signInButton.isHidden = isSignedIn
        //signOutButton.isHidden = !isSignedIn
        messagesTable.isHidden = !isSignedIn
        messageTextField.isHidden = !isSignedIn
        sendButton.isHidden = !isSignedIn
        imageMessage.isHidden = !isSignedIn
        
        if (isSignedIn) {
            
            // remove background blur (will use when showing image messages)
            messagesTable.rowHeight = UITableViewAutomaticDimension
            messagesTable.estimatedRowHeight = 122.0
            //backgroundBlur.effect = nil
            messageTextField.delegate = self
            
            configureDatabase()
            
            // TODO: Set up app to send and receive messages when signed in
        }
    }
    
    func loginSession() {
      //  let authViewController = Auth.defaultAuthUI()!.authViewController()
       // self.present(authViewController, animated: true, completion: nil)
    }
    
    // MARK: Send Message
    
    func sendMessage(data: [String:String]) {
        // TODO: create method that pushes message to the firebase database
        var mdata = data
        var userName = user?.email?.components(separatedBy: "@")
        mdata[Constants.MessageFields.name] = userName?[0]
        self.ref.child("Users").child((user?.uid)!).child("messages").child(contactUID!).childByAutoId().setValue(mdata)
        self.ref.child("Users").child(contactUID!).child("messages").child((user?.uid)!).childByAutoId().setValue(mdata)
        self.ref.child("Users").child(contactUID!).child("Contacts").childByAutoId().setValue((user?.uid)!)
        
    }
    
    func sendPhotoMessage(photoData: Data) {
        // TODO: create method that pushes message w/ photo to the firebase database
    }
    
    // MARK: Alert
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Scroll Messages
    
    func scrollToBottomMessage() {
        if messages.count == 0 { return }
        let bottomMessageIndex = IndexPath(row: messagesTable.numberOfRows(inSection: 0) - 1, section: 0)
        messagesTable.scrollToRow(at: bottomMessageIndex, at: .bottom, animated: true)
    }
    
    // MARK: Actions
//    @IBAction func showLoginView(_ sender: AnyObject) {
//        loginSession()
//    }
    
    @IBAction func didTapAddPhoto(_ sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
//    @IBAction func signOut(_ sender: UIButton) {
//        do {
//            try Auth.auth().signOut()
//        } catch {
//            print("unable to sign out: \(error)")
//        }
//    }
    
    @IBAction func didSendMessage(_ sender: UIButton) {
        let _ = textFieldShouldReturn(messageTextField)
        messageTextField.text = ""
    }
    
//    @IBAction func dismissImageDisplay(_ sender: AnyObject) {
//        // if touch detected when image is displayed
//        if imageDisplay.alpha == 1.0 {
//            UIView.animate(withDuration: 0.25) {
//                //self.backgroundBlur.effect = nil
//                self.imageDisplay.alpha = 0.0
//            }
//            dismissImageRecognizer.isEnabled = false
//            messageTextField.isEnabled = true
//        }
//    }
//
//    @IBAction func tappedView(_ sender: AnyObject) {
//        resignTextfield()
//    }
}

// MARK: - FCViewController: UITableViewDelegate, UITableViewDataSource

extension MessagingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue cell
        let cell = messagesTable.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageCell
        
        let messageSnap: DataSnapshot! = messages[indexPath.row]
        let message = messageSnap.value as! [String:String]
        let name = message[Constants.MessageFields.name] ?? "[username]"
        let text = message[Constants.MessageFields.text] ?? "[message]"
        cell.messageLbl.text = name + ": " + text
        cell.messageLbl.numberOfLines = 0
        cell.userImg.image = self.placeholderImage
        
        return cell
        // TODO: update cell to display message data
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: if message contains an image, then display the image
    }
    
    // MARK: Show Image Display
    
    func showImageDisplay(_ image: UIImage) {
        dismissImageRecognizer.isEnabled = true
        dismissKeyboardRecognizer.isEnabled = false
        messageTextField.isEnabled = false
        UIView.animate(withDuration: 0.25) {
           // self.backgroundBlur.effect = UIBlurEffect(style: .light)
            self.imageDisplay.alpha = 1.0
            self.imageDisplay.image = image
        }
    }
    
    // MARK: Show Image Display
    
    func showImageDisplay(image: UIImage) {
        dismissImageRecognizer.isEnabled = true
        dismissKeyboardRecognizer.isEnabled = false
        messageTextField.isEnabled = false
        UIView.animate(withDuration: 0.25) {
          //  self.backgroundBlur.effect = UIBlurEffect(style: .light)
            self.imageDisplay.alpha = 1.0
            self.imageDisplay.image = image
        }
    }
}

// MARK: - FCViewController: UIImagePickerControllerDelegate

extension MessagingVC: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:Any]) {
        // constant to hold the information about the photo
        if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage, let photoData = UIImageJPEGRepresentation(photo, 0.8) {
            // call function to upload photo message
            sendPhotoMessage(photoData: photoData)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - FCViewController: UITextFieldDelegate

extension MessagingVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // set the maximum length of the message
        guard let text = textField.text else { return true }
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= msglength.intValue
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !textField.text!.isEmpty {
            let data = [Constants.MessageFields.text: textField.text! as String]
            sendMessage(data: data)
            textField.resignFirstResponder()
        }
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if !keyboardOnScreen {
            self.view.frame.origin.y -= self.keyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            self.view.frame.origin.y += self.keyboardHeight(notification)
        }
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
        dismissKeyboardRecognizer.isEnabled = true
        scrollToBottomMessage()
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        dismissKeyboardRecognizer.isEnabled = false
        keyboardOnScreen = false
    }
    
    func keyboardHeight(_ notification: Notification) -> CGFloat {
        return ((notification as NSNotification).userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.height
    }
    
    func resignTextfield() {
        if messageTextField.isFirstResponder {
            messageTextField.resignFirstResponder()
        }
    }
    
    func subscribeToKeyboardNotifications() {
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
    }
    
    func subscribeToNotification(_ name: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}

    




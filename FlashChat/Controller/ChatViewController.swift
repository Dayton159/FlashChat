//
//  ChatViewController.swift
//  FlashChat
//
//  Created by Dayton on 11/12/20.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    //database reference
    let db = Firestore.firestore()
    
    // is going to contain an array of Message object
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        title = K.appName
        
        //hiding the back button in chat VC because it is unrelevant
        // to go login and going back to login screen after pressing back button
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        getMessages()
        
    }
    
    func getMessages(){
        
        //the completion handler depends on your internet, and often even though it is trigerred when the view did load
        //the messages may not added in time for it getting showed in the tableview.
        
        //we will access the specified collection that we made, order it by date they were created, and
        //add some listener to trigger this code everytime there is an update of data happening.
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapShop, error) in
            
            self.messages = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestrore. \(e.localizedDescription)")
            }else{
                
                // getting the actual documents that is saved in a collection
                if let snapshotDocuments = querySnapShop?.documents{
                    for doc in snapshotDocuments{
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            
                            //when we are trying to update the interface while we are in a closure
                            DispatchQueue.main.async {
                                //tap into table view and trigger those data source method again
                                self.tableView.reloadData()
                                //which row you want to scroll to
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                //scroll to some row
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
                                                    //getting access of the email of the sender
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
                //collection within a specified path in the database, adding some document to it.
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to firestore: \(e.localizedDescription)")
                }else{
                    print("Successfully saved data ")
                    
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                    
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        //because sign out method may throw an error,
        //we use do catch syntax
        do {
          try Auth.auth().signOut()
            
            //pop all view controller except the root VC
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError { //will carried out if there is a problem signing out the user
          print ("Error signing out: %@", signOutError)
            
        }
          
    }
    
}
//when our viewController loads up it will going to request for some data
//it is responsible for populate our tableview
extension ChatViewController: UITableViewDataSource {
    
    // how many row/cell you want in your tableview
    //basically the func numberOfRowsInSection will return an int and it will execute CellForRowAt func the same time
    //as the return value of numberOfRowsInSection func.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    //index path = position
    //this method asking us for UITableView Cell what it should displays in each and every row of tableview.
    // we need to create cell and returns it to the tableview.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        
        //this is a messages from the current user.
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        //this is a message from another sender.
        else{
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
       
        return cell
    }
}



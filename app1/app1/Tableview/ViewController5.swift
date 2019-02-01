//
//  ViewController5.swift
//  app1
//
//  Created by Promptnow on 31/1/2562 BE.
//  Copyright © 2562 Promptnow. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

//class Data {
//    var name: String = ""
//
//    init(name: String) {
//       self.name = name
//    }
//}

class User {
    var user:UserData = UserData()
}

class UserData {
    var userId = ""
    var userAge = ""
    var userName = ""
    var userDept = ""
    var userQRCode = ""
}

class ViewController5: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView2: UITableView!
    
//    var data:[Data] = [Data]()
    var userData = [UserData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        read()
    
    }
    
    func read() {
        let docRef = Firestore.firestore().collection("Promptnow")
        docRef.getDocuments { (snapshot, err) in
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in snapshot!.documents {
                    let docId = document.documentID
                    let name = document.get("name") as! String
                    let age = document.get("age") as! String
                    let dept = document.get("dept") as! String
                    
                    let newData = UserData()
                    newData.userId = docId
                    newData.userName = name
                    newData.userAge = age
                    newData.userDept = dept
                    print(newData)
                    self.userData.append(newData)
                }
                self.tableView2.delegate = self
                self.tableView2.dataSource = self
                self.tableView2.reloadData()
            }
        }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        cell.textLabel?.text = userData[indexPath.row].userName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dvc = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as! ViewController3
        dvc.getname = userData[indexPath.row].userName
        dvc.getid = userData[indexPath.row].userId
        dvc.getdept = userData[indexPath.row].userDept
        dvc.getage = userData[indexPath.row].userAge
        dvc.isFromTab5 = true
     
        
        self.navigationController?.pushViewController(dvc, animated: true)
    }

}

//
//  ViewController3.swift
//  app1
//
//  Created by Promptnow on 8/1/2562 BE.
//  Copyright © 2562 Promptnow. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
class ViewController3: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var dept: UITextField!
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var id: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        img.layer.cornerRadius = img.frame.size.width / 2
        img.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func openlb(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true, completion: nil)    }
    
    @IBAction func cameraBtn(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }else {
        let alert = UIAlertController(title: "ไม่สามารถใช้กล้องได้", message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
        }

    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            img.image = image
            
        }else{
            //error
            print("error")
        }
        
        self.dismiss(animated: true, completion: nil)
//        img.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//        self.dismiss(animated: true, completion: nil)
        
}
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)

    }
//    func uploadMedia(completion: @escaping (_ url: String?) -> Void) {
//        let storageRef = Storage.storage().reference().child("myImage.png")
//        if let uploadData = self.img.image!.pngData() {
//            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
//                if error != nil {
//                    print("error")
//                    completion(nil)
//                } else {
//                
//                    completion((metadata?.downloadURL()?.absoluteString)!);)
//                    // your uploaded photo url.
//                }
//            }
//        }
//    }
    
    func uploadMedia()  {
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("image.png").child("\(imageName).png")
        if let uploadData = self.img.image!.pngData(){

            storageRef.putData(uploadData, metadata: nil, completion:
                {
                    (metadata, error) in
                    
                    if error != nil {
                        print("error")
                        return
                    }

                    storageRef.downloadURL { url, error in
                        if let error = error {
                            // Handle any errors
                            if(error != nil){
                                print(error)
                                return
                            }
                        }else {
                            // Get the download URL
                           
                            let urlStr:String = (url?.absoluteString)!
                            let id = self.id.text
                            let db = Firestore.firestore()
                            
                            
                            db.collection("Promptnow").document(id!).setData(
                                ["dept": self.dept.text!,
                                 "id": self.id.text!,
                                 "name": self.name.text!,
                                 "age": self.age.text!,
                                 "imageURL": urlStr,
                                 "qrcode": ""]){ err in
                                    if let err = err {
                                        print("Error writing document: \(err)")
                                } else {
                                        let alert = UIAlertController(title: "เพิ่มข้อมูลสำเร็จ", message: nil, preferredStyle: .alert)
                                        let okButton = UIAlertAction(title: "OK", style: .default, handler: { action in
                                            self.id.text = ""
                                            self.dept.text = ""
                                            self.name.text = ""
                                            self.age.text = ""
                                            self.img.image = nil })
                                        alert.addAction(okButton)
                                        self.present(alert,animated: true,completion: nil)
                                                                                    }
                            }
                    }
                        print(metadata)
                        print(url)

                }
                
            })
            
        }
    }
    
    
    @IBAction func add(_ sender: Any) {
        self.uploadMedia()
 
    }
}

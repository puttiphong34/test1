//
//  ViewController2.swift
//  app1
//
//  Created by Promptnow on 8/1/2562 BE.
//  Copyright © 2562 Promptnow. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import AVFoundation

class ViewController2: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imageQR: UIImageView!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var imageInQR: UIImageView!
    @IBOutlet weak var btngen: UIButton!
    @IBOutlet weak var btnsave: UIButton!
    @IBOutlet weak var lbid: UILabel!
    @IBOutlet weak var lbdept: UILabel!
    @IBOutlet weak var lbname: UILabel!
    @IBOutlet weak var lbage: UILabel!
    @IBOutlet weak var lbtitleid: UILabel!
    @IBOutlet weak var lbtitledept: UILabel!
    @IBOutlet weak var lbtitlename: UILabel!
    @IBOutlet weak var lbtitleage: UILabel!
    
    
    override func viewDidLoad() {
        
        btnsave.isEnabled = false
        
        lbid.isHidden = true
        lbage.isHidden = true
        lbname.isHidden = true
        lbdept.isHidden = true
        
        lbtitleid.isHidden = true
        lbtitleage.isHidden = true
        lbtitledept.isHidden = true
        lbtitlename.isHidden = true
        
        self.hidekeybord()
        
        textfield.delegate = self
    }
    
    
    
    func downloadImage(with url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
               print(error!)
                return
            }
            DispatchQueue.main.async {
                self.imageInQR.image = UIImage(data: data!)
            }
        }.resume()
    }
    
    @IBAction func openlb(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true, completion: nil)
        
        lbid.isHidden = false
        lbage.isHidden = false
        lbname.isHidden = false
        lbdept.isHidden = false

        lbtitleid.isHidden = false
        lbtitleage.isHidden = false
        lbtitledept.isHidden = false
        lbtitlename.isHidden = false

        
    }
    
    @IBAction func btnSave(_ sender: Any) {
    
      //  let layer = UIApplication.shared.keyWindow?.layer
        let scale = UIScreen.main.scale


       // UIGraphicsBeginImageContextWithOptions(self.imageInQR.bounds.size, self.imageInQR.isOpaque, 0.0)
        UIGraphicsBeginImageContextWithOptions((self.imageQR.bounds.size), self.imageQR.isOpaque, scale)
         self.view.drawHierarchy(in: CGRect(x: -100, y: -55, width: view.bounds.size.width, height: view.bounds.size.height), afterScreenUpdates: true)
        
//        self.imageQR.layer.render(in: UIGraphicsGetCurrentContext()!)
//        self.imageInQR.layer.render(in: UIGraphicsGetCurrentContext()!)

        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(screenshot!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)

        dismiss(animated: true, completion: nil)
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editimage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let detector: CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])!
            let ciImage: CIImage = CIImage(image:editimage)!
            var qrCodeLink = ""
            
            let features = detector.features(in: ciImage)
            for feature in features as! [CIQRCodeFeature] {
                qrCodeLink += feature.messageString!
            }
            
            if qrCodeLink == "" {
                print("nothing")
            }else{
                print("message: \(qrCodeLink)")
                
                    let docRef = Firestore.firestore().collection("Promptnow").document(qrCodeLink)
                
                    docRef.getDocument{ (document, err) in
                        if let document = document {
                            if document.exists{
                                
                                let age = document.get("age") as! String
                                let name = document.get("name") as! String
                                let docID = document.documentID
                                let dept = document.get("dept") as! String
                                
                                self.lbid.text = docID
                                self.lbdept.text = dept
                                self.lbname.text = name
                                self.lbage.text = age
                                
                            }else {
                                let alert = UIAlertController(title: "ไม่พบข้อมูล", message: nil, preferredStyle: .alert)
                                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alert.addAction(okButton)
                                self.present(alert,animated: true,completion: nil)
                                
                            }
                            
                        }
                        
                    }
            }
            imageQR.image = editimage
            
        }else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageQR.image = image
            
        }else{
            //error
            print("error")
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                self.imageQR.image = nil
                self.imageInQR.image = nil
                self.textfield.text = nil }))
            self.present(ac, animated: true)
        }
    }
    
    @IBAction func bt(_ sender: Any) {

        if textfield.text != "" {
            guard let datadb = textfield.text else {return}
            let docRef = Firestore.firestore().collection("Promptnow").document(datadb)
            
            docRef.getDocument{ (document, err) in
                if let document = document {
                    if document.exists{
                   
                        let imageurl = document.get("imageURL") as! String
                        let imageurl2 = URL(string: imageurl)
                        self.downloadImage(with: imageurl2!)

                        let age = document.get("age") as! String
                        let name = document.get("name") as! String
                        let docID = document.documentID
                        let dept = document.get("dept") as! String
                        
                      //  let qrcodedata = ("ID:\(docID)\t\t |Depatment:\(dept)\t\t |Name:\(name)\t\t |Age:\(age)")
//                        let docRef2 = Firestore.firestore()
//                        docRef2.collection("Promptnow").document(docID).updateData(["qrcode": qrcodedata])
                        
                        var data = docID.data(using: .ascii, allowLossyConversion: false)
                        
                        let filter = CIFilter(name: "CIQRCodeGenerator")
                        filter?.setValue(data, forKey: "inputMessage")
                        filter?.setValue("M", forKey: "inputCorrectionLevel")
                        guard let qrcode = filter?.outputImage else { return }
                        let scaleX = self.imageQR.frame.size.width / qrcode.extent.size.width
                        let scaleY = self.imageQR.frame.size.height / qrcode.extent.size.height
                        
                        let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
                        
                        let output = filter?.outputImage?.transformed(by: transform)
                        
                        let img = UIImage(ciImage: (output)! )
                        
                        self.imageQR.image = img
                        
                        self.btnsave.isEnabled = true

                    }else {
                        let alert = UIAlertController(title: "ไม่พบข้อมูลในการสร้าง", message: nil, preferredStyle: .alert)
                        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(okButton)
                        self.present(alert,animated: true,completion: nil)
                        
                    }
                    
                }
                
            }

        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func btnscan(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "scan") as! ScanViewController
        
        DispatchQueue.main.async(execute: {self.navigationController?.pushViewController(vc, animated: true)})
        
    }
}



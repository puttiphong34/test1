//
//  ScanViewController.swift
//  app1
//
//  Created by Promptnow on 12/2/2562 BE.
//  Copyright © 2562 Promptnow. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var imagecamera: UIImageView!
    var video = AVCaptureVideoPreviewLayer()
    var session = AVCaptureSession()
    var userData = [UserData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor.black
        
        //Define capture devcie
        let captureDevice = AVCaptureDevice.default(for: .video)
        
        do
        {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }
        catch
        {
            print ("ERROR")
        }
        
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
        video.videoGravity = .resizeAspectFill
        view.layer.addSublayer(video)
        
        self.view.bringSubviewToFront(imagecamera)
        
        session.startRunning()
       
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        session.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {return}
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            if readableObject.type == AVMetadataObject.ObjectType.qr
            {
                let alert = UIAlertController(title: "QR Code", message: stringValue, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Retake", style: .default, handler: { (nil) in
                    self.session.startRunning()
                }))
                alert.addAction(UIAlertAction(title: "Show", style: .default, handler: { (action) in
                  //  UIPasteboard.general.string = stringValue
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Detail") as! ViewController3
                    vc.isFromTab5 = true
                    let docRef = Firestore.firestore().collection("Promptnow").document(stringValue)
                    
                    docRef.getDocument{ (document, err) in
                        if let document = document {
                            if document.exists{
                                
                                let age = document.get("age") as! String
                                let name = document.get("name") as! String
                                let docID = document.documentID
                                let dept = document.get("dept") as! String
                                
                                vc.getid = docID
                                vc.getdept = dept
                                vc.getname = name
                                vc.getage = age
                                
                                print("123")
                                self.navigationController?.pushViewController(vc, animated: true)
                            
                                
                            }else {
                                let alert = UIAlertController(title: "ไม่พบข้อมูล", message: nil, preferredStyle: .alert)
                                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alert.addAction(okButton)
                                self.present(alert,animated: true,completion: nil)
                                
                            }
                            
                        }
                        
                    }
                   // self.session.startRunning()
                }))
                present(alert, animated: true, completion: nil)
            }
        }
    }

    override var shouldAutorotate: Bool {
        return false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
   

    
}

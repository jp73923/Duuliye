//
//  ImagePicker.swift
//  CookerCustomerApp
//
//  Created by Admin on 29/12/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

import MobileCoreServices

@objc protocol ImagePickerDelegate {
    func pickImageComplete(_ imageData: UIImage, sender:String)
    func pickVideoComplete(_ videoURL: URL, sender:String)
    
    @objc optional func pickDocumentComplete(_ documentURL:URL, sender:String)
}

class ImagePicker: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIDocumentPickerDelegate, UIDocumentInteractionControllerDelegate {
    
    var delegate: ImagePickerDelegate?
    var senderName = String()
    
    let imagePicker = UIImagePickerController()
    var alertVC = UIAlertController()
    
    var documentInteraction = UIDocumentInteractionController()
    
    static let sharedInstance: ImagePicker = {
        let instance = ImagePicker()
        return instance
    }()
    
    override init() {
        super.init()
        
    }
    func selectImage(sender:String,presentComplete:@escaping (Bool)->())
    {
        alertVC = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
        senderName = sender
        let lblTitle:UILabel = UILabel(frame: CGRect(x: 0, y: 15.0, width: SCREENWIDTH() - 20, height: 25))
        lblTitle.font = FontWithSize(FT_Regular, 20)
        lblTitle.textAlignment = .center
        lblTitle.text = "Select Image"
        alertVC.view.addSubview(lblTitle)
        let margin:CGFloat = 10.0
        let rect = CGRect(x: margin, y: margin, width: alertVC.view.bounds.size.width - margin * 4.0, height: 120)
        let customView = UIView(frame: rect)
        
        let btnGalleryImage:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
        btnGalleryImage.setBackgroundImage(UIImage(named: "galelry"), for: .normal)
        btnGalleryImage.addTarget(self, action: #selector(ImagePicker.btnGalleryImage), for: .touchUpInside)
        let btnCameraImage:UIButton = UIButton(frame: CGRect(x: 90, y: 0, width: 70, height: 70))
        btnCameraImage.setBackgroundImage(UIImage(named: "camera"), for: .normal)
        btnCameraImage.addTarget(self, action: #selector(ImagePicker.btnCameraImage), for: .touchUpInside)
        
        customView.addSubview(btnGalleryImage)
        customView.addSubview(btnCameraImage)
        alertVC.view.addSubview(customView)
        
        let alertControllerHeight:NSLayoutConstraint = NSLayoutConstraint(item: alertVC.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 200)
        alertVC.view.addConstraint(alertControllerHeight);
        mostTopViewController?.present(alertVC, animated: true, completion: {
            presentComplete(true)
        })
    }
    func selectImage(sender:String, allowDocument:Bool)
    {
        alertVC = UIAlertController(title: "Select image option", message: "", preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        senderName = sender
        
        let margin:CGFloat = 10.0
        
        let rect = CGRect(x: alertVC.view.center.x/4, y: margin + 30, width: 200 , height: 90)
        let customView = UIView(frame: rect)
        customView.backgroundColor = UIColor.clear
        
        var buttons:CGFloat = 2 //FOR BUTTON WIDTH MANAGEMENT
        if allowDocument { buttons = 3 }
        
        let btnGalleryImage:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: customView.frame.size.width/buttons, height: 50))
        btnGalleryImage.backgroundColor = UIColor.clear
        btnGalleryImage.setImage(UIImage(named: "attach_image"), for: .normal)
        btnGalleryImage.addTarget(self, action: #selector(ImagePicker.btnGalleryImage), for: .touchUpInside)
        
        let lblgalerry:UILabel = UILabel(frame: CGRect(x: btnGalleryImage.frame.origin.x, y: btnGalleryImage.frame.size.height + 5, width: btnGalleryImage.frame.size.width, height: 15))
        lblgalerry.font = FontWithSize(FT_Medium, 11)
        lblgalerry.textAlignment = .center
        lblgalerry.text = "GALLERY"
        lblgalerry.backgroundColor = UIColor.clear
        lblgalerry.textColor = themeGrayColor
        
        let btnCameraImage:UIButton = UIButton(frame: CGRect(x: btnGalleryImage.frame.origin.x + btnGalleryImage.frame.width, y: 0, width: customView.frame.size.width/buttons, height: 50))
        btnCameraImage.setImage(UIImage(named: "attach_cam"), for: .normal)
        btnCameraImage.backgroundColor = UIColor.clear
        btnCameraImage.addTarget(self, action: #selector(ImagePicker.btnCameraImage), for: .touchUpInside)
        
        let lblcam:UILabel = UILabel(frame: CGRect(x: btnCameraImage.frame.origin.x, y: btnCameraImage.frame.size.height + 5, width: btnCameraImage.frame.size.width, height: 15))
        lblcam.font = FontWithSize(FT_Medium, 11)
        lblcam.textColor = themeGrayColor
        lblcam.textAlignment = .center
        lblcam.text = "CAMERA"
        lblcam.backgroundColor = UIColor.clear
        
        customView.addSubview(btnGalleryImage)
        customView.addSubview(lblgalerry)
        
        customView.addSubview(btnCameraImage)
        customView.addSubview(lblcam)
        
        if allowDocument{
            
            let btnDocument:UIButton = UIButton(frame: CGRect(x: btnCameraImage.frame.origin.x + btnCameraImage.frame.width , y: 0, width: customView.frame.size.width/buttons, height: 50))
            btnDocument.setImage(UIImage(named: "attach_doc"), for: .normal)
            btnDocument.backgroundColor = UIColor.clear
            btnDocument.addTarget(self, action: #selector(ImagePicker.btnDocument), for: .touchUpInside)
            
            let lbldocument = UILabel(frame: CGRect(x: btnDocument.frame.origin.x, y: btnDocument.frame.size.height + 5, width: btnDocument.frame.size.width, height: 15))
            lbldocument.font = FontWithSize(FT_Medium, 11)
            lbldocument.textColor = themeGrayColor
            lbldocument.textAlignment = .center
            lbldocument.text = "DOCUMENT"
            lbldocument.backgroundColor = UIColor.clear
            
            customView.addSubview(btnDocument)
            customView.addSubview(lbldocument)
            
        }
        
        
        customView.center = CGPoint.init(x: alertVC.view.center.x - margin, y: 90)
        alertVC.view.addSubview(customView)
        
        let alertControllerHeight:NSLayoutConstraint = NSLayoutConstraint(item: alertVC.view, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 200)
        alertVC.view.addConstraint(alertControllerHeight);
        mostTopViewController?.present(alertVC, animated: true)
    }
    
    func SelectPhoto(sender:String, allowDocument:Bool) {
        let alert = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
                //self.openCamera()
                self.imagePicker.delegate = self
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .camera
                mostTopViewController?.present(self.imagePicker, animated: true, completion: nil)
            }))
        }
        alert.addAction(UIAlertAction(title: "Choose From Gallery", style: .default, handler: { _ in
            //self.openGallary()
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.mediaTypes = ["public.image"]
            mostTopViewController?.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        if allowDocument {
            alert.addAction(UIAlertAction(title: "Document", style: .default, handler: { _ in
                //self.btnDocument()
//                let documentPicker = UIDocumentPickerViewController.init(documentTypes: [kUTTypePDF as String, "com.microsoft.word.doc", "org.openxmlformats.wordprocessingml.document", "com.microsoft.excel.xls", kUTTypeSpreadsheet as String, kUTTypeText as String, kUTTypeRTF as String], in: .import)
                let documentPicker = UIDocumentPickerViewController.init(documentTypes: [kUTTypePDF as String], in: .import)
                documentPicker.delegate = self
                mostTopViewController?.present(documentPicker, animated: true, completion: nil)
            }))
        }
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        senderName = sender
        mostTopViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    //
    func SelectVideo(sender:String) {
        //self.openGallary()
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.mediaTypes = ["public.movie"]
        self.senderName = sender
        mostTopViewController?.present(self.imagePicker, animated: true, completion: nil)
    }
    
    
    
    @objc func btnGalleryImage() {
        alertVC.dismiss(animated: true) {
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            mostTopViewController?.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func btnCameraImage() {
        alertVC.dismiss(animated: true) {
            self.imagePicker.delegate = self
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            mostTopViewController?.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func btnDocument(){
        alertVC.dismiss(animated: true) {
            
            let documentPicker = UIDocumentPickerViewController.init(documentTypes: [kUTTypePDF as String, "com.microsoft.word.doc", "org.openxmlformats.wordprocessingml.document", "com.microsoft.excel.xls", kUTTypeSpreadsheet as String, kUTTypeText as String, kUTTypeRTF as String], in: .import)
            documentPicker.delegate = self
            mostTopViewController?.present(documentPicker, animated: true, completion: nil)
            
        }
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage
        {
            let imgData : NSData = pickedImage.jpegData(compressionQuality: 0.4)! as NSData
            print(senderName)
            //print(info[UIImagePickerControllerReferenceURL] as? NSURL)
            delegate?.pickImageComplete(UIImage.init(data: imgData as Data)!,sender: senderName)
        }
        else {
            if let url = info[.mediaURL] as? URL {
                print("movie saved")
                print(senderName)
                delegate?.pickVideoComplete(url, sender: senderName)
            }
        }
        mostTopViewController?.dismiss(animated: true, completion: nil)
    }
    
    internal func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        let newUrls = [url].compactMap { (url: URL) -> URL? in
            // Create file URL to temporary folder
            var tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
            // Apend filename (name+extension) to URL
            tempURL.appendPathComponent(url.lastPathComponent)
            do {
                // If file with same name exists remove it (replace file with new one)
                if FileManager.default.fileExists(atPath: tempURL.path) {
                    try FileManager.default.removeItem(atPath: tempURL.path)
                }
                // Move file from app_id-Inbox to tmp/filename
                try FileManager.default.moveItem(atPath: url.path, toPath: tempURL.path)
                return tempURL
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        
        documentInteraction = UIDocumentInteractionController.init(url: newUrls[0])
        documentInteraction.delegate = self
        documentInteraction.presentPreview(animated: true)
    }
    
    internal func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        print(#function)
        
        let url = controller.url!
        delegate?.pickDocumentComplete?(url, sender: senderName)
    }
    
    internal func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return mostTopViewController!
    }
    
}

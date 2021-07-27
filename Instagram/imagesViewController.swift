//
//  imagesViewController.swift
//  Instagram
//
//  Created by harshvardhan singh on 8/23/19.
//  Copyright © 2019 harshvardhan singh. All rights reserved.
//

import UIKit
import Parse

class imagesViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

 
    @IBOutlet weak var imagePost: UIImageView!
    @IBOutlet weak var captions: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    @IBAction func postButton(_ sender: Any) {
        
            if let image = imagePost.image {
            
                let post = PFObject(className: "Post")
       
                post["message"] = captions.text
                post["userid"] = PFUser.current()?.objectId
        
                if let imageData = image.jpegData(compressionQuality: 0.5)  {
                    
                    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                    
                    activityIndicator.center = self.view.center
                    activityIndicator.hidesWhenStopped = true
                    activityIndicator.style = UIActivityIndicatorView.Style.gray
                    
                    view.addSubview(activityIndicator)
                    
                    activityIndicator.isHidden = false
                    activityIndicator.startAnimating()
                    UIApplication.shared.beginIgnoringInteractionEvents()
            
                    let imageFile = PFFileObject(name: "image.png", data: imageData)
            
                    post["imageFile"] = imageFile
                    
                    post.saveInBackground { (success, error) in
                        
                        activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                        if success{
                            
                            self.displayAlert("Image Posted", message: "Image has been posted successfully")
                            
                            self.captions.text = ""
                            self.imagePost.image = nil
                            
                        }else{
                            
                            self.displayAlert("Image could not be Posted", message: error!.localizedDescription)
                            
                        }
                    }
                }
            }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            imagePost.image = image
            
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func displayAlert(_ title: String,message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

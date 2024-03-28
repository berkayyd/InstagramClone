//
//  UploadViewController.swift
//  InstagramClone
//
//  Created by Berkay Demir on 27.03.2024.
//

import UIKit
import FirebaseStorage
import FirebaseFirestoreInternal
import FirebaseAuth

class UploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var commentText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(uploadPhoto))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func uploadPhoto () {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            imageView.image = pickedImage
        }
        
        picker.dismiss(animated: true)
    }
    
    func makeAlert(titleInput : String , messageInput : String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func uploadBtnClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media") //you can do this even not creating media folder at first on firebaseStorage
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { metaData , error in
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                }else {
                    
                    imageReference.downloadURL { url, error in
                        
                        if error == nil {
                            let imageURL = url?.absoluteString
                            
                            //Database
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreReference : DocumentReference? = nil
                            
                            let firebasePost = ["imageURL" : imageURL! , "postedBy" : Auth.auth().currentUser!.email!, "postComment" : self.commentText.text! , "date" : FieldValue.serverTimestamp() , "likes" : 0 ] as [String : Any]
                            
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firebasePost, completion: { error in
                                if error != nil {
                                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                                    
                                } else {
                                    
                                    self.imageView.image = UIImage(named: "selectPhoto")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                    
                                }
                            })
                            
                        }
                        
                    }
                }
            }
        }
        
    }
    
}

//
//  MemeController.swift
//  All-Bout Meme
//
//  Created by Stephen Martinez on 1/13/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit

class MemeController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextFieldDelegate{
    
    @IBOutlet weak var memePicture: UIImageView!
    @IBOutlet weak var pickImageButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topEntry: UITextField!
    @IBOutlet weak var bottomEntry: UITextField!
    @IBOutlet weak var introMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myTextStyle: [String: Any] = [NSStrokeColorAttributeName : UIColor.black,
                                          NSForegroundColorAttributeName : UIColor.white,
                                          NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                                          NSStrokeWidthAttributeName: -0.9]
        topEntry.defaultTextAttributes = myTextStyle
        bottomEntry.defaultTextAttributes = myTextStyle
        topEntry.textAlignment = .center
        bottomEntry.textAlignment = .center
        topEntry.delegate = self
        bottomEntry.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        self.shareButton.isEnabled = (memePicture == nil)
        subscribeToKeyboardNotifications()
    }
    
    
    @IBAction func share(_ sender: Any) {
        let currentMeme = self.produceMeme()
        let sharingController = UIActivityViewController(activityItems: [currentMeme], applicationActivities: nil)
        present(sharingController, animated: true){self.saveMeme(memedImage: currentMeme)}
    }
    
    func produceMeme()-> UIImage{
        UIGraphicsBeginImageContextWithOptions(self.memePicture.frame.size, true, 0.0)
        self.memePicture.drawHierarchy(in: self.memePicture.frame, afterScreenUpdates: true)
        let meme: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return meme
    }
    
    func saveMeme(memedImage: UIImage){ // may need to be edited based on future use!
        let meme = Meme(upperEntry: topEntry.text! , lowerEntry: bottomEntry.text! , originalImage: memePicture.image! , memeImage: memedImage)
        SentMemes.shared.memesList.append(meme)
    }
    
    
    //Image delegation and selection section.............................................
    @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        let pickerOfImage = UIImagePickerController()
        pickerOfImage.delegate = self
        
        switch sender.tag{
        case 1: //Photos Button Tag
            pickerOfImage.sourceType = .photoLibrary
        case 2: //Camera Button Tag
            pickerOfImage.sourceType = .camera
        default:
            print("Check for Button tags in StoryBoard")
        }
        present(pickerOfImage, animated: true){self.introMessage.alpha = CGFloat(0)}
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.memePicture.image = info[UIImagePickerControllerOriginalImage] as! UIImage?
        dismiss(animated: true){self.shareButton.isEnabled = true}// may need to be moved!
    }
    
    //Text field delegation.............................................
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text! == "TOP" || textField.text! == "BOTTOM"{
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Keyboard Notifications...............................
    func keyboardWillShow(_ notification: Notification){
        if bottomEntry.isEditing{
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
                self.view.frame.origin.y = 0 - keyboardSize.height
            }
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
    }
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}


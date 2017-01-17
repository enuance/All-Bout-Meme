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
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    //Setting the Meme Style Fonts for text fields.......................................
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
        //May need to add nav delegate here for future implementation of pushed VC's
    }
    
    //Set Default States for buttons and intro text.......................................
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = (memePicture.image != nil)
        if shareButton.isEnabled {introMessage.alpha = CGFloat(0)}else{introMessage.alpha = CGFloat(1)}
        if topEntry.text! != "TOP" || bottomEntry.text! != "BOTTOM" || memePicture.image != nil {
            cancelButton.isEnabled = true
        }else{
            cancelButton.isEnabled = false
        }
    }
    
    //Navigation Items Functionality........................................................
    @IBAction func share(_ sender: Any) {
        //Create a meme and hand it to the Activity Controller for sharing.
        let currentMeme = produceMeme()
        let sharingController = UIActivityViewController(activityItems: [currentMeme], applicationActivities: nil)
        //Submits meme to be saved to the Singleton instance via custom completion handler
        //that checks the exception for a user selecting cancel
        sharingController.completionWithItemsHandler = {activity, success, items, error in
            if !success{return} else {self.saveMeme(memedImage: currentMeme) ; return}
        }
        present(sharingController, animated: true)
    }
    
    @IBAction func cancelEditing(_ sender: Any) {
        //Set Meme back to default values
        topEntry.text = "TOP"
        bottomEntry.text = "BOTTOM"
        introMessage.alpha = CGFloat(1)
        memePicture.image = nil
        cancelButton.isEnabled = false
        shareButton.isEnabled = false
    }
    
    //Meme image creation and Saving.......................................................
    func produceMeme()-> UIImage{
        //Used ContextWithOptions for better photo resolution.
        UIGraphicsBeginImageContextWithOptions(memePicture.bounds.size, true, 0.0)
        memePicture.drawHierarchy(in: memePicture.bounds, afterScreenUpdates: true)
        let meme: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return meme
    }
    
    func saveMeme(memedImage: UIImage){
        let meme = Meme(upperEntry: topEntry.text! , lowerEntry: bottomEntry.text! , originalImage: memePicture.image! , memeImage: memedImage)
        //Send instance of meme to singleton object property memesList
        SentMemes.shared.memesList.append(meme)
    }
    
    
    //Image delegation and selection section...............................................
    @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        let pickerOfImage = UIImagePickerController()
        pickerOfImage.delegate = self
        //Presenting appropriate Image picker by identifying the button tag
        switch sender.tag{
        case 1: //Photos Button Tag
            pickerOfImage.sourceType = .photoLibrary
        case 2: //Camera Button Tag
            pickerOfImage.sourceType = .camera
        default:
            print("Check for Button tags in StoryBoard")
        }
        //Intro Message disappears with presentation of image picker
        present(pickerOfImage, animated: true){self.introMessage.alpha = CGFloat(0)}
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.memePicture.image = info[UIImagePickerControllerOriginalImage] as! UIImage?
        dismiss(animated: true){self.shareButton.isEnabled = true; self.cancelButton.isEnabled = true}
    }
    
    //Text field delegation...............................................................
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Clear out text field upon editing if used for the first time.
        if textField.text! == "TOP" || textField.text! == "BOTTOM"{textField.text = ""}
        cancelButton.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Keyboard Notifications...............................................................
    func keyboardWillShow(_ notification: Notification){
        //Only move Main View with Keyboard if the bottom text field is in use!
        if bottomEntry.isEditing{
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
                self.view.frame.origin.y = 0 - keyboardSize.height
            }
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        //Put the Main View back in it's place when keyboard hides.
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
    }
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}


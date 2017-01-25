//
//  MemeController.swift
//  All-Bout Meme
//
//  Created by Stephen Martinez on 1/13/17.
//  Copyright © 2017 Stephen Martinez. All rights reserved.
//

import UIKit

class MemeController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextFieldDelegate,  StyleSelectionDelegate{
    
    @IBOutlet weak var memePicture: UIImageView!
    @IBOutlet weak var pickImageButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topEntry: UITextField!
    @IBOutlet weak var bottomEntry: UITextField!
    @IBOutlet weak var introMessage: UILabel!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    var textDistanceMoved: CGFloat = 0
    var memeStyleUsed: Styles!
    let allBoutMeme = MemeStyle()
    
    //Initial Set-Up and Delegation Assignement Section.......................................
    //Delegate assignment and Initial Values
    override func viewDidLoad() {
        super.viewDidLoad()
        forEntries(setStyle: .Meme)
        topEntry.delegate = self
        bottomEntry.delegate = self
        navigationController?.delegate = self
    }
    
    //Set Default States for buttons and intro text
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = (memePicture.image != nil)
        if shareButton.isEnabled {introMessage.alpha = CGFloat(0)}else{introMessage.alpha = CGFloat(1)}
        if topEntry.text! != "TOP" || bottomEntry.text! != "BOTTOM" || memePicture.image != nil || memeStyleUsed != .Meme{
            cancelButton.isEnabled = true
        }else{
            cancelButton.isEnabled = false
        }
    }
    
    //Style Selection and Set up section......................................................
    //Navigate to the Meme Styles Selection TableView
    @IBAction func memeStyleSelector(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let memeStylesVC = storyboard.instantiateViewController(withIdentifier: "StylesController")as! MemeStylesController
        //Setting the custom delegate for passing data about Styles.
        memeStylesVC.delegate = self
        navigationController!.pushViewController(memeStylesVC, animated: true)
    }
    
    //Implementation of Custom Style delegate to inform Editor of Style Selection
    func didSelectStyle(_ styleSelected: Styles) {forEntries(setStyle: styleSelected)}
    
    //Helper Method to format entry fields to Styles selected
    func forEntries(setStyle: Styles){
        let styleToBeSet = allBoutMeme.configure(topEntry, bottomEntry, setStyle)
        topEntry = styleToBeSet.first
        bottomEntry = styleToBeSet.second
        memeStyleUsed = setStyle
    }
    
    //Top Navigation Items Section............................................................
    //Create a meme and hand it to the Activity Controller for sharing.
    @IBAction func share(_ sender: Any) {
        let currentMeme = produceMeme()
        let sharingController = UIActivityViewController(activityItems: [currentMeme], applicationActivities: nil)
        //Submits meme to be saved to the Singleton instance via custom completion handler
        //that checks the exception for a user selecting cancel
        sharingController.completionWithItemsHandler = {activity, success, items, error in
            if !success{
                return
            } else {
                self.saveMeme(memedImage: currentMeme)
                self.navigationController!.popToRootViewController(animated: true)
                return
            }
        }
        present(sharingController, animated: true)
    }
    
    //Set Editor back to default values & Navigate to beginning
    @IBAction func cancelEditing(_ sender: Any) {
        topEntry.text = "TOP"
        bottomEntry.text = "BOTTOM"
        forEntries(setStyle: .Meme)
        introMessage.alpha = CGFloat(1)
        memePicture.image = nil
        cancelButton.isEnabled = false
        shareButton.isEnabled = false
        navigationController!.popToRootViewController(animated: true)
    }
    
    //Meme image selection and management Section.............................................
    //Creates a meme image using the context of the memePicture property
    func produceMeme()-> UIImage{
        //Used ContextWithOptions for better photo resolution.
        UIGraphicsBeginImageContextWithOptions(memePicture.bounds.size, true, 0.0)
        memePicture.drawHierarchy(in: memePicture.bounds, afterScreenUpdates: true)
        let meme: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return meme
    }
    
    //Saves the current meme as a Meme object and stores it in an global array
    func saveMeme(memedImage: UIImage){
        let meme = Meme(upperEntry: topEntry.text! , lowerEntry: bottomEntry.text! , originalImage: memePicture.image! , memeImage: memedImage, memeStyle: memeStyleUsed)
        //Send instance of meme to singleton object property memesList
        SentMemes.shared.memesList.append(meme)
    }
    
    //Select an image to edit in the meme editor using either album or camera
    @IBAction func pickAnImage(_ sender: UIBarButtonItem) {
        let pickerOfImage = UIImagePickerController()
        pickerOfImage.delegate = self
        //Allows User to crop photo
        pickerOfImage.allowsEditing = true
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
    
    //Delegate that informs us of the image selected for editing and updates button states
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        memePicture.image = info[UIImagePickerControllerEditedImage] as! UIImage?
        dismiss(animated: true){self.shareButton.isEnabled = true; self.cancelButton.isEnabled = true}
    }
    
    //TextField Editing Section...............................................................
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Clear out text field upon editing if used for the first time.
        if textField.text! == "TOP" || textField.text! == "BOTTOM"{textField.text = ""}
        cancelButton.isEnabled = true
    }
    
    //Hides keyboard after pressing enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Moves TextFields into desires position or returns to original location
    @IBAction func textSpacing(_ sender: Any) {
        let distance: CGFloat = 40
        let textPosition = (top: topEntry.frame.origin.y, bottom: bottomEntry.frame.origin.y)
        let newPositions = (top: (textPosition.top + distance), bottom: (textPosition.bottom - distance))
        let resetPositions = (top: textPosition.top - textDistanceMoved, bottom: textPosition.bottom + textDistanceMoved)
        if newPositions.top + distance <= newPositions.bottom{
            textDistanceMoved += distance
            topEntry.frame.origin.y = newPositions.top
            bottomEntry.frame.origin.y = newPositions.bottom
        }else{
            topEntry.frame.origin.y = resetPositions.top
            bottomEntry.frame.origin.y = resetPositions.bottom
            textDistanceMoved = 0
        }
    }
    
    //Resets the textField distance tracking property if moved to portrait or landscape
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        textDistanceMoved = 0
    }
    
    //Keyboard Management Section.............................................................
    func keyboardWillShow(_ notification: Notification){
        //Only move Main View with Keyboard if the bottom text field is in use!
        if bottomEntry.isEditing{
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
                view.frame.origin.y = 0 - keyboardSize.height
            }
        }
    }
    
    //Put the Main View back in it's place when keyboard hides.
    func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {view.frame.origin.y = 0}
    }
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

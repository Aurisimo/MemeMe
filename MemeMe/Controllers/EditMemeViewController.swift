//
//  ViewController.swift
//  MemeMe
//
//  Created by Aurelijus Lape on 27/09/2019.
//  Copyright © 2019 Aurelijus Lape. All rights reserved.
//

import UIKit
import AVFoundation

class EditMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    static let identifier = "EditMemeViewController"
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
        
    var shareButton: UIBarButtonItem!
    var cameraButton: UIBarButtonItem!
    var memedImage: UIImage!
    
    let textFieldDelegate = TextFieldDelegate()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isToolbarHidden = false

        subscribeToKeyboardWillShow()
        subscribeToKeyboardWillHide()
        
        shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        shareButton.isEnabled = false
        navigationItem.leftBarButtonItem = shareButton
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = cancelButton
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        cameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(pickImageFromCamera))
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        let albumButton = UIBarButtonItem(title: "Album", style: .plain, target: self, action: #selector(pickImageFromAlbum))
        
        toolbarItems = [space, cameraButton, albumButton, space]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardWillShow()
        unsubscribeFromKeyboardWillHide()
        navigationController?.isToolbarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create Meme"

        configureTextField(topTextField)
        configureTextField(bottomTextField)
        
        setDefaultValues()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            imageView.image = image
            shareButton.isEnabled = true
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Action Methods

    @objc func share() {
        memedImage = generateMemedImage()
        let vc = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        vc.popoverPresentationController?.barButtonItem = shareButton
        
        vc.completionWithItemsHandler = { [unowned self] (type, completed, items, error) in
            if completed { self.save() }
        }
        
        present(vc, animated: true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -(getKeyboardHeight(notification) - (navigationController?.navigationBar.bounds.height ?? 0))
        }
            
        shareButton.isEnabled = false
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }

        if imageView.image != nil {
            shareButton.isEnabled = true
        }
    }
    
    @objc func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func pickImageFromAlbum(_ sender: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        present(picker, animated: true)
    }

    @objc func pickImageFromCamera(_ sender: UIBarButtonItem) {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .authorized:
            showImagePickerForCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
                if granted {
                    DispatchQueue.main.async {
                        self.showImagePickerForCamera()
                    }
                }
            }
        case .denied:
            showAlert(title: Alerts.authorizationRestrictionError, message: Alerts.noCameraAccessGrantedMessage)
        case .restricted:
            showAlert(title: Alerts.authorizationRestrictionError, message: Alerts.restrictionToGrantCameraAccessMessage)
        return
        default:
            break
        }
    }

    //MARK: Helper Methods
    
    func configureTextField(_ textField: UITextField) {
        textField.delegate = textFieldDelegate

        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center

        let memeAttributes: [NSAttributedString.Key : Any] = [
          .strokeColor: UIColor.black,
          .foregroundColor: UIColor.white,
          .strokeWidth: -2,
          .font: UIFont(name: "impact", size: 40)!,
          .paragraphStyle: paragraph
        ]

        textField.defaultTextAttributes = memeAttributes
    }

    func setDefaultValues() {
        imageView.image = nil
        topTextField.text = Constants.topDefaultText
        bottomTextField.text = Constants.bottomDefaultText
    }

    func subscribeToKeyboardWillShow() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    func subscribeToKeyboardWillHide() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardWillShow() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardWillHide() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let keyboardScreen = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardScreen.cgRectValue.height
    }
    
    func showImagePickerForCamera() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = true
        
        present(picker, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: Alerts.dismissActionTitle, style: .default))
        present(ac, animated: true)
    }
    
    func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        navigationController?.navigationBar.isHidden = true
        navigationController?.isToolbarHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        navigationController?.navigationBar.isHidden = false
        navigationController?.isToolbarHidden = false

        return memedImage
    }
}

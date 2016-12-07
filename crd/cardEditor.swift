//
//  ViewController.swift
//  crd
//
//  Created by Beyer, Zachary on 11/10/16.
//  Copyright © 2016 zbeyer. All rights reserved.
//

import UIKit

class CardEditor: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var fieldType: UITextField!
    @IBOutlet weak var typeColor: UILabel!
    @IBOutlet weak var fieldTitle: UITextField!
    @IBOutlet weak var info: UITextView!
    @IBOutlet weak var typeColorStep: UIStepper!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBAction func onDone(_ sender: Any) {
        self.fieldTitle.endEditing(true)
        self.info.endEditing(true)
        self.didEdit()
    }
    @IBAction func onStep(_ sender: Any) {
        if self.typeColorStep.value < 0 {
            self.typeColorStep.value = 0
        }
        if self.typeColorStep.value > 7 {
            self.typeColorStep.value = 7
        }
        ApplicationState.sharedInstance.typeColorIndex = TypeColorIndex(rawValue: Int(self.typeColorStep.value))!
        self.typeColorStep.tintColor = ApplicationState.sharedInstance.typeColorForIndex.rimColor

    }
    
    let imagePicker:UIImagePickerController = UIImagePickerController()

    
    @IBAction func loadImageButtonTapped(sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ApplicationState.sharedInstance.cardImage = pickedImage
            self.thumbnail.image = ApplicationState.sharedInstance.cardImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didEdit() {
        
        if let titleString = self.fieldTitle.text {
            self.fieldTitle.text = titleString.uppercased()
            ApplicationState.sharedInstance.cardTitle = titleString.uppercased()
        }
        
        if let typeString = self.fieldType.text {
            self.fieldType.text = typeString.uppercased()
            ApplicationState.sharedInstance.cardType = typeString.uppercased()
        }
        
        ApplicationState.sharedInstance.cardInfo = self.info.text
    }
    
    @IBAction func backgroundTaped(_ sender: Any) {
        self.fieldTitle.endEditing(true)
        self.info.endEditing(true)
        
        self.didEdit()
    }
    
    @IBOutlet var previewImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backgroundTaped(_:)))
        self.view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(ApplicationState.sharedInstance.cardInfo != "") {
            self.info.text = ApplicationState.sharedInstance.cardInfo
        }
        
        if (ApplicationState.sharedInstance.cardTitle != "") {
            self.fieldTitle.text = ApplicationState.sharedInstance.cardTitle
        }
        
        if (ApplicationState.sharedInstance.cardType != "") {
            self.fieldType.text = ApplicationState.sharedInstance.cardType
        }
        
        if ((ApplicationState.sharedInstance.cardImage) != nil) {
            self.thumbnail.image = ApplicationState.sharedInstance.cardImage
        }
        
        self.typeColorStep.value = Double(ApplicationState.sharedInstance.typeColorIndex.rawValue)
        self.typeColor.text = ""
        self.typeColorStep.tintColor = ApplicationState.sharedInstance.typeColorForIndex.rimColor
        self.thumbnail.contentMode = .scaleAspectFill
        self.thumbnail.clipsToBounds = true
        
        self.info.layer.borderWidth = 0.5
        self.info.layer.cornerRadius = 2.0
        self.info.layer.borderColor = UIColor.lightGray.cgColor
        self.imagePicker.delegate = self

    }
    
    
}


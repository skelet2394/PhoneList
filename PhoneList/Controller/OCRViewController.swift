//
//  ViewController.swift
//  PhoneList
//
//  Created by Valery Silin on 13/02/2018.
//  Copyright © 2018 Valery Silin. All rights reserved.
//

import UIKit
import SwiftOCR
import CropViewController

protocol OCRVCTextFieldDelegate {
    func imeiTextRecognised (imei: String)
}

class OCRViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {
    
    var delegate : OCRVCTextFieldDelegate?

    let imagePicker = UIImagePickerController()
    let swiftOCR = SwiftOCR()
    
    var croppingStyle = CropViewCroppingStyle.default
    var croppedRect = CGRect.zero
    var croppedAngle = 0
    
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var chosenImageView: UIImageView!
    @IBOutlet weak var checkLabel: UILabel!
    
    @IBOutlet weak var recognisedTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLabel.isHidden = true
        present(imagePicker, animated: true, completion: nil)
        
        imagePicker.delegate = self
        //      Change between camera and photo library
                        imagePicker.sourceType = .camera
//        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }


    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if parent == nil {
            self.delegate?.imeiTextRecognised(imei: recognisedTextField.text!)
        }
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        //      Present image picker
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        let cropViewController = CropViewController(croppingStyle: croppingStyle, image: image)
        
        cropViewController.delegate = self
        picker.dismiss(animated: true, completion: {
            self.checkLabel.isHidden = false
            self.present(cropViewController, animated: true, completion: nil)
        })
    }
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        croppedRect = cropRect
        croppedAngle = angle
        chosenImageView.image = image
        dismiss(animated: true, completion: {
            self.recogniseTextOnImage(image: image)
        })
    }
    func recogniseTextOnImage(image: UIImage) {
        swiftOCR.characterWhiteList = "1234567890"
        swiftOCR.recognize(image) { (recognisedText) in
            DispatchQueue.main.async {
                self.recognisedTextField.text = recognisedText
            }
        }
        
    }
    
    
    
}

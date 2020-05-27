//
//  ViewController.swift
//  Fiftygram
//
//  Created by Carey Chua on 14/4/20.
//  Copyright © 2020 Carey Chua. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    let context = CIContext()
    var original: UIImage?
    var filtered: UIImage?
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var saveButton: BorderedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveEnabled(enabled: false)
    }
    
    @IBAction func choosePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            navigationController?.present(picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func revertImage() {
        // check for image
        if filtered == nil {
            return
        }
        // set to initial image
        imageView.image = original
        filtered = original
        // disable saveButton
        saveEnabled(enabled: false)
    }
    
    @IBAction func applySepia() {
        // check for image
        if original == nil {
            return
        }
        // set filter
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(0.5, forKey: kCIInputIntensityKey)
        display(filter: filter!)
    }
    
    @IBAction func applyNoir() {
        // check for image
        if original == nil {
            return
        }
        // set filter
        let filter = CIFilter(name: "CIPhotoEffectNoir")
        display(filter: filter!)
    }
    
    @IBAction func applyVintage() {
        // check for image
        if original == nil {
            return
        }
        // set filter
        let filter = CIFilter(name: "CIPhotoEffectProcess")
        display(filter: filter!)
    }
    
    @IBAction func applyBlur() {
        // check for image
        if original == nil {
            return
        }
        // set filter
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(10, forKey: kCIInputRadiusKey)
        display(filter: filter!)
    }
    
    @IBAction func savePhoto() {
        // check for image
        if imageView.image == nil {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(imageView.image!, nil, nil, nil)
        // disable saveButton
        saveEnabled(enabled: false)
    }
    
    func saveEnabled(enabled: Bool) {
        saveButton.isEnabled = enabled
    }
    
    func display(filter: CIFilter) {
        // create CIImage and apply filter
        let image = CIImage(image: filtered!)
        filter.setValue(image, forKey: kCIInputImageKey)
        
        // output CIImage with filter, create cgImage, cast to UIImage
        let output = filter.outputImage
        let cgImage = context.createCGImage(output!, from: (output?.extent)!)
        imageView.image = UIImage(cgImage: cgImage!)
        
        // enable saveButton
        saveEnabled(enabled: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        navigationController?.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            original = image
            filtered = image
        }
    }
    
}


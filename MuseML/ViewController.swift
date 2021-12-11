//
//  ViewController.swift
//  MuseML
//
//  Created by Bryan Albert on 10/24/19.
//  Copyright © 2019 Me. All rights reserved.
//

import UIKit
import CoreML
import Vision
//import SwiftyJSON
//import Alamofire
import SDWebImage
import ChameleonFramework
//import CropViewController

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var cameraView: UIImageView!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    var global = GlobalVar.global
    
    var descriptionClass = Description()
    
    let imagePicker = UIImagePickerController()
    let wikipediaURL = "https://en.wikipedia.org/w/api.php"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isIdleTimerDisabled = true
    
//        let colors : [UIColor] = [
//            UIColor(hexString: "08c0f3")!,
//            FlatWhite()
//        ]
        
//        view.backgroundColor = GradientColor(.topToBottom, frame: view.frame, colors: colors)
        
        view.backgroundColor = UIColor(named: "08c0f3")!
        
        descriptionLabel.delegate = self
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.descriptionLabel.text = "Tap the camera to capture an image of '\(self.global.pickedSongTitle),' otherwise tap Back to choose a different song."
//        }
        
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            cameraView.image = userPickedImage
           
            imagePicker.dismiss(animated: true, completion: nil)
            guard let ciImage = CIImage(image: userPickedImage) else {fatalError("Error converting UIImage to CIImage")}
            detect(image: ciImage)
           // presentCropViewController(image: userPickedImage)
        }
        

        
    }
    
    // Uncomment and apropos edit imagePickerController for CropView functionality. Deprecated.
    
    
//    func presentCropViewController(image: UIImage) {
//
//        let cropViewController = CropViewController(image: image)
//        cropViewController.delegate = self
//
//        present(cropViewController, animated: true, completion: nil)
//    }
//
//    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
//        guard let ciimage = CIImage(image: image) else {fatalError("Error converting UIImage to CIImage")}
//        cameraView.image = image
//        detect(image: ciimage)
//        cropViewController.dismiss(animated: true, completion: nil)
//    }

    @IBAction func cameraButton(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: global.pickedModel) else {fatalError("Error retrieving model")}
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let classification = request.results?.first as? VNClassificationObservation else {fatalError("Error retrieving classification")}
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.descriptionLabel.text = "Tap the camera to capture an image of '\(self.global.pickedSongTitle),' otherwise tap Back to choose a different song."
            }

            
            if classification.confidence >= 0.38 {
                let identifier = classification.identifier
                var navTitle = classification.identifier
                let range = self.global.pickedSongTitle.count
                let removeRange = navTitle.startIndex ... navTitle.index(navTitle.startIndex, offsetBy: range)
                navTitle.removeSubrange(removeRange)
                
                self.navigationItem.title = navTitle
                self.cameraView.image = UIImage.init(named: identifier)
                self.descriptionLabel.text = self.descriptionClass.measureDescription[identifier]
            }
            else {
                self.navigationItem.title = "Oops!"
                self.descriptionLabel.text = "Try Again"
            }
            //self.getJSON(flowerName: classification.identifier)
            print(request.results!)
            print(classification.confidence)
        }
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print("The handler could not perform request")
        }
    }
}


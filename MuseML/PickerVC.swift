//
//  PickerVC.swift
//  MuseML
//
//  Created by Bryan Albert on 10/24/19.
//  Copyright © 2019 Me. All rights reserved.
//

import Foundation
import CoreML
import UIKit
import ChameleonFramework

class PickerVC : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var picker: UIPickerView!
    
    var global = GlobalVar.global
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        let colors : [UIColor] = [
            UIColor(hexString: "08c0f3")!,
            FlatWhite()
        ]
        
        view.backgroundColor = GradientColor(.topToBottom, frame: view.frame, colors: colors)
        let navBar = navigationController?.navigationBar
        
        navBar?.barTintColor = UIColor(hexString: "08c0f3")!
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return global.songTitle.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return global.songTitle[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        global.pickedModel = global.songModels[row]
        global.pickedSongTitle = global.songTitle[row]
        global.globalInt = row
    }
    @IBAction func cameraButtonPressed(_ sender: Any) {
        print("before segue")
        print(global.globalInt)
        print(global.pickedModel)
        print(global.pickedSongTitle)
        performSegue(withIdentifier: "ToCamera", sender: self)
    }
}

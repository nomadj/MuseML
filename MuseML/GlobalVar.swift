//
//  File.swift
//  MuseML
//
//  Created by Bryan Albert on 10/24/19.
//  Copyright © 2019 Me. All rights reserved.
//
import Foundation
import CoreML

class GlobalVar {
    let songModels = [SkatingWaltzv2().model, Mistv2().model, LetsWaltzv2().model]
    var pickedModel = SkatingWaltzv2().model
    let songTitle = ["A Skating Waltz", "Mist", "Let's Waltz"]
    var pickedSongTitle = "A Skating Waltz"
    
    var globalInt = 0
    
    static let global = GlobalVar()
}

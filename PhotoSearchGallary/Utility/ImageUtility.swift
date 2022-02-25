//
//  ImageUtility.swift
//  PhotoSearchGallary
//
//  Created by Geetha on 25/02/22.
//

import Foundation
import UIKit

class ImageUtility: NSObject {
    static func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}

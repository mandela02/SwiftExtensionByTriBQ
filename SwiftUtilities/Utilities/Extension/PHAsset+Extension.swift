//
//  PHAsset+Extension.swift
//  
//
//  Created by TriBQ on 27/08/2022.
//

import Foundation
import UIKit
import Photos


public extension PHAsset {
    func getImage(completionHandler: @escaping (UIImage?) -> Void) {
        let imageManager = PHCachingImageManager()
        
        let options = PHImageRequestOptions()
        options.version = .current
        options.isSynchronous = true

        imageManager.requestImage(for: self,
                                  targetSize: CGSize(width: self.pixelWidth, height: self.pixelHeight),
                                  contentMode: .aspectFit,
                                  options: options,
                                  resultHandler: { image, _ in
                completionHandler(image)
        })
    }
}

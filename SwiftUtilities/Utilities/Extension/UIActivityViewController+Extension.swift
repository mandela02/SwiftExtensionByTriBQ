//
//  UIActivityController+public extension.swift
//  Cinder
//
//  Created by TriBQ on 27/8/2022.
//

import UIKit

public extension UIActivityViewController {
    static func share(appName: String, image: UIImage, at view: UIView) {
        guard let url = self.saveImage(appName: appName, image: image) else { return }
        let imageToShare = [url]
        let activityViewController = UIActivityViewController(activityItems: imageToShare,
                                                              applicationActivities: nil)
        activityViewController
            .popoverPresentationController?
            .sourceView = view
        
        UIApplication.topViewController()?
            .present(activityViewController,
                     animated: true,
                     completion: nil)
    }
    
    static private func saveImage(appName: String, image: UIImage) -> URL? {
        let fileName = appName + ".png"
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first else {
            return nil
        }
        
        let fileURL = documentsDirectory
            .appendingPathComponent(fileName)
        
        guard let data = image.jpeg(.highest) else { return nil }

        removeCaptureImage(with: fileURL)

        do {
            try data.write(to: fileURL)
            return fileURL
        } catch let error {
            print("error saving file with error", error)
            return nil
        }
    }
    
    static private func removeCaptureImage(with fileURL: URL) {
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
    }
}

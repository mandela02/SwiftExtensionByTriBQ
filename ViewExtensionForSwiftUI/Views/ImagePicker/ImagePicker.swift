//
//  ImagePicker.swift
//  Cinder
//
//  Created by TriBQ on 27/08/2022.
//

import Foundation
import UIKit
import PhotosUI
import Photos

public protocol ImagePickerDelegate: AnyObject {
    func didPickImage(images: [UIImage])
    func onCancel()
}

typealias CameraPickerDelegate = UIImagePickerControllerDelegate & UINavigationControllerDelegate

public class ImagePickerHelper: NSObject {
    private var title: String
    private var message: String
    private var isMultiplePick: Bool
    
    private var namesForPickerOption: [ImageAction: String] = [:]
    private var messagesForPickerOption: [ImageAction: String] = [:]

    private lazy var configuration: PHPickerConfiguration = {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        if isMultiplePick {
            configuration.selectionLimit = 10
        } else {
            configuration.selectionLimit = 1
        }
        configuration.filter = .images
        return configuration
    }()
    
    private lazy var imagePicker: PHPickerViewController = {
        var imagePicker =  PHPickerViewController(configuration: configuration)
        imagePicker.delegate = self
        return imagePicker
    }()
    
    private lazy var cameraPicker: UIImagePickerController = {
        var imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        return imagePicker
    }()

    public weak var delegate: ImagePickerDelegate?

    public init(title: String,
         message: String,
         isMultiplePick: Bool = false,
         namesForPickerOption: [ImageAction: String] = [:],
         messagesForPickerOption: [ImageAction: String] = [:]) {
        self.title = title
        self.message = message
        self.isMultiplePick = isMultiplePick
        self.namesForPickerOption = namesForPickerOption
        self.messagesForPickerOption = messagesForPickerOption
    }
    
    public func showActionSheet() {
        UIAlertController.showActionSheet(source: ImageAction.self,
                                          title: title,
                                          message: message) { [weak self] action in
            guard let self = self else { return }
            self.imagePickerTapped(action: action)
        }
    }
}

public extension ImagePickerHelper {
    private func imagePickerTapped(action: ImageAction) {
        switch action {
        case .camera:
            checkCameraPermission {  [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    UIApplication.topViewController()?.present(self.cameraPicker, animated: true, completion: nil)
                }
            }
        case .library:
            checkPhotoLibraryPermission { [weak self] in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    UIApplication.topViewController()?.present(self.imagePicker, animated: true, completion: nil)
                }
            }
        }
    }
    
    func checkPhotoLibraryPermission(onSuccess: @escaping () -> Void) {
       let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .limited:
            onSuccess()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ [weak self] (status) -> Void in
               switch status {
               case .authorized, .limited:
                   onSuccess()
               default:
                   self?.unauthorizationHandle(action: .library)
               }
            })
        case .denied, .restricted:
            self.unauthorizationHandle(action: .library)
        @unknown default:
            self.unauthorizationHandle(action: .library)
        }
    }
    
    func checkCameraPermission(onSuccess: @escaping () -> Void) {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            onSuccess()
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] granted in
                if granted {
                    onSuccess()
                } else {
                    self?.unauthorizationHandle(action: .camera)
                }
            })
        }
    }
}

extension ImagePickerHelper: PHPickerViewControllerDelegate {
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: { [weak self] in
            guard let self = self else { return }
            self.fetchImage(from: picker, results: results)
        })
    }
    private func fetchImage(from picker: PHPickerViewController, results: [PHPickerResult]) {
        guard !results.isEmpty else {
            return
        }
        
        let identifier = results.compactMap(\.assetIdentifier)
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifier, options: nil)
        
        var resultCount = 0
        var images: [UIImage] = []
                
        fetchResult.enumerateObjects { [weak self] (asset, _, _) in
            guard let self = self else { return }
            resultCount += 1
            
            asset.getImage { image in
                if let image = image {
                    images.append(image)
                    
                    if images.count == resultCount {
                        self.delegate?.didPickImage(images: images)
                    }
                }
            }
        }
    }
}

extension ImagePickerHelper: CameraPickerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.delegate?.onCancel()
        }
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true) {
            guard let image = info[.originalImage] as? UIImage else {
                return
            }
            self.delegate?.didPickImage(images: [image])
        }
    }
}

public extension ImagePickerHelper {
    func unauthorizationHandle(action: ImageAction) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController(title: "Access Requested",
                                          message: self.messagesForPickerOption[action] ?? action.getMessage(),
                                          preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Settings", style: .default) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            })

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            })

            guard let vc = UIApplication.topViewController() else {
                return
            }

            vc.present(alert, animated: true, completion: nil)
        }
    }
}

public extension ImagePickerHelper {
    enum ImageAction: CaseIterable, EnumName {
        case library
        case camera
        
        public func getName() -> String {
            switch self {
            case .camera:
                return "Take a picture"
            case .library:
                return "Choose from library"
            }
        }

        func getMessage() -> String {
            switch self {
            case .camera:
                return "This app access your camera to get you a new   picture. You can change this in Settings app"
            case .library:
                return "This app access your photo album to get you a new profile picture. You can change this in Settings app"
            }
        }
    }
}

extension UIAlertController {
    static func showActionSheet<T: CaseIterable & EnumName>(source: T.Type,
                                                            title: String,
                                                            message: String,
                                                            optionTitle: [T: String] = [:],
                                                            cancelButtontTitle: String = "Cancel",
                                                            onTap: @escaping (T) -> Void) {
        let actionSheet: UIAlertController = UIAlertController(title: title,
                                                               message: message,
                                                               preferredStyle: .actionSheet)
        
        actionSheet.overrideUserInterfaceStyle = .light
        
        for action in T.allCases {
            let alertAction = UIAlertAction(title: optionTitle[action] ?? action.getName(),
                                            style: .default,
                                            handler: { _ in
                                                onTap(action)
                                            })
            actionSheet.addAction(alertAction)
        }
        
        let cancelAlertAction = UIAlertAction(title: cancelButtontTitle,
                                              style: .cancel,
                                              handler: {_ in })
        
        actionSheet.addAction(cancelAlertAction)
        
        UIApplication.topViewController()?.present(actionSheet, animated: true, completion: nil)
    }
}

protocol EnumName {
    func getName() -> String
}

extension UIApplication {
    static func topViewController(base: UIViewController? = UIViewController.window?.rootViewController) -> UIViewController? {
        if let navigationController = base as? UINavigationController {
            return topViewController(base: navigationController.visibleViewController)
        }
        if let tabBarController = base as? UITabBarController {
            if let selected = tabBarController.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

public extension UIViewController {
    static var window: UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        else { return nil }
        
        return (windowScene.delegate as? WindowDetector)?.window
    }
}

public protocol WindowDetector {
    var window: UIWindow? { get set }
}

extension PHAsset {
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

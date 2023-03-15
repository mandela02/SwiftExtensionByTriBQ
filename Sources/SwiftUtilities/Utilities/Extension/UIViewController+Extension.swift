//
//  UIViewController+public extension.swift
//  Hamyabi
//
//  Created by TriBQ on 14/12/2021.
//

import UIKit

public protocol HasWindow {
    var window: UIWindow? { get set }
}

public extension UIViewController {
    static var appDelegate: UIApplicationDelegate? {
        return UIApplication.shared.delegate
    }
    
    static var sceneDelegate: UISceneDelegate? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate else { return nil }
        return delegate
    }
}

public extension UIViewController {
    static var window: UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        else { return nil }
        
        return (windowScene.delegate as? HasWindow)?.window
    }
}

public extension UIViewController {
    class func vc() -> Self {
        return self.init(nibName: String(describing: self), bundle: nil)
    }
    
    class func instantiate<T: UIViewController>(_: T.Type, storyboard: String) -> T {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        guard let ViewController = storyboard.instantiateViewController(withIdentifier: T.className) as? T else {
            fatalError("Can not instantiate viewcontroller from storyboard \(storyboard)")
        }
        return ViewController
    }
    
    static func instantiateFromStoryboard(identifier: String = "") -> Self {
        return instantiateFromStoryboard(viewControllerClass: self, identifier: identifier)
    }
    
    private static func instantiateFromStoryboard<T: UIViewController>(viewControllerClass: T.Type, identifier: String = #function, line: Int = #line, file: String = #file) -> T {
        var storyboardName = ""
        var controllerIdentifer = ""
        if identifier != "" {
            storyboardName = identifier
            controllerIdentifer = (viewControllerClass as UIViewController.Type).className
        } else {
            storyboardName = (viewControllerClass as UIViewController.Type).className
            controllerIdentifer = storyboardName
        }
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        guard let scene = storyboard.instantiateViewController(withIdentifier: controllerIdentifer) as? T else {
            fatalError("ViewController with identifier \(storyboardName), not found in \(storyboardName) Storyboard.\nFile : \(file) \nLine Number : \(line)")
        }
        return scene
    }
    
    func getImagePickerViewController(sourceType: UIImagePickerController.SourceType, barButtonItem: UIBarButtonItem) -> UIImagePickerController? {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else {
            return nil
        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.modalPresentationStyle = .popover
        let popoverPresentationController = imagePickerController.popoverPresentationController
        if traitCollection.horizontalSizeClass == .regular {
            popoverPresentationController?.barButtonItem = barButtonItem
        } else {
            popoverPresentationController?.sourceView = self.view
        }
        return imagePickerController
    }
    
    func addChildViewController(containerView: UIView, childViewController: UIViewController) {
        childViewController.view.frame = containerView.bounds
        childViewController.willMove(toParent: self)
        containerView.addSubview(childViewController.view)
        addChild(childViewController)
        childViewController.didMove(toParent: self)
    }
    
    func removeFromParentViewController() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
    var isTopViewController: Bool {
        return UIApplication.topViewController() === self
    }
    
    var isModal: Bool {
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        let presentingIsSplitView = splitViewController?.presentingViewController is UISplitViewController
        
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar || presentingIsSplitView
    }

}

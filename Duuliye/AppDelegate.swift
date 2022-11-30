//
//  AppDelegate.swift
//  Duuliye
//
//  Created by Jay on 02/06/22.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?
    var appNavigation:UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        
        UITextField.appearance().tintColor = .green
        
        
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
       
        
        UserDefaults.standard.setValue(false, forKey:"_UIConstraintBasedLayoutLogUnsatisfiable")
      /*  //Tmp Commment
        let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idTabbarVC)
        APP_DELEGATE.appNavigation = UINavigationController(rootViewController: vc)
        APP_DELEGATE.appNavigation?.interactivePopGestureRecognizer?.delegate = nil
        APP_DELEGATE.appNavigation?.interactivePopGestureRecognizer?.isEnabled = true
        APP_DELEGATE.appNavigation?.isNavigationBarHidden = true
        APP_DELEGATE.window?.rootViewController = APP_DELEGATE.appNavigation
        APP_DELEGATE.window?.makeKeyAndVisible()*/
        return true
    }
}


//
//  CustomSplashVC.swift
//  Duuliye
//
//  Created by Jay on 02/06/22.
//

import UIKit

class CustomSplashVC: UIViewController {
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.view.layoutSubviews()
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "Splash_Screen", withExtension: "gif")!)
        let advTimeGif = UIImage.gifImageWithData(imageData!)
        let imageView2 = UIImageView(image: advTimeGif)
        imageView2.frame = CGRect(x: 0, y: -100, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height + 100)
        self.view.addSubview(imageView2)
        DispatchQueue.main.asyncAfter(deadline: .now() + 16.0) {
            self.initialNavigationFlow()
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            self.initialNavigationFlow()
//        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        
    }

    //MARK:- Cutom Functions
    func initialNavigationFlow() {
        if UserDefaultManager.getBooleanFromUserDefaults(key: kIsLoggedIn) {
            let vc = loadVC(strStoryboardId: SB_TABBAR, strVCId: idTabbarVC)
            APP_DELEGATE.appNavigation = UINavigationController(rootViewController: vc)
            APP_DELEGATE.appNavigation?.interactivePopGestureRecognizer?.delegate = nil
            APP_DELEGATE.appNavigation?.interactivePopGestureRecognizer?.isEnabled = true
            APP_DELEGATE.appNavigation?.isNavigationBarHidden = true
            APP_DELEGATE.window?.rootViewController = APP_DELEGATE.appNavigation
            APP_DELEGATE.window?.makeKeyAndVisible()
        } else {
            let vc = loadVC(strStoryboardId: SB_MAIN, strVCId: idLoginVC)
            APP_DELEGATE.appNavigation = UINavigationController(rootViewController: vc)
            APP_DELEGATE.appNavigation?.interactivePopGestureRecognizer?.delegate = nil
            APP_DELEGATE.appNavigation?.interactivePopGestureRecognizer?.isEnabled = true
            APP_DELEGATE.appNavigation?.isNavigationBarHidden = true
            APP_DELEGATE.window?.rootViewController = APP_DELEGATE.appNavigation
            APP_DELEGATE.window?.makeKeyAndVisible()
        }
    }
}

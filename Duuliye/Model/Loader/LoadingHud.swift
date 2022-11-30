//
//  LoadingHud.swift
//  OneLifeToGo
//
//  Created by Admin on 16/03/18.
//  Copyright © 2018 el. All rights reserved.
//

import Foundation
import UIKit
import Lottie

/*class LoadingHud  : NSObject{
    
    static var bgview = UIView()
    static var anim = LoadingAnimationView.init(frame: CGRect.zero, color: UIColor.clear)
    static var lbl  = UILabel()
    static let view = UIApplication.shared.windows[0]
    static let frame = CGRect.init(x: view.frame.size.width/2 - 30, y: view.center.y - 30 , width: 60, height: 60)
    
    class func showHUDIn() {
    
        //REMOVE IF ALREADY EXIST
        bgview.removeFromSuperview()
        bgview.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        bgview.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        anim.removeFromSuperview()
    
        anim = LoadingAnimationView.init(frame:frame, type: .ballRotate ,color: UIColor.white, size: CGSize.init(width: 60, height: 60))
        anim.setupAnimation()
        bgview.addSubview(anim)
        view.addSubview(bgview)
    }
    
    class func showHUD(){
        LoadingHud.showHUDIn()
    }
    
    class func showDefaultHUD(){
        LoadingHud.showHUD()
    }
    
    class func showHUDText(){
         LoadingHud.showHUD()
    }
    
    class func dismissHUD(){
       bgview.removeFromSuperview()
    }
}*/


class LoadingHud  : NSObject{
    
   // static var animationView:AnimationView = AnimationView()
   // static var animationView:UIView = UIView()

    static var bgview = UIView()
    static var anim1 = LoadingAnimationView.init(frame: CGRect.zero, color: .clear)
    static var lbl  = UILabel()
    class func showHUDIn(view:UIView, withText text:String){
        bgview.removeFromSuperview()
        let colorset : [UIColor] = [
           themeGreenColor,
            themeGrayColor,
            UIColor.init(red: 241/255, green: 93/255, blue: 52/255, alpha: 1)
        ]
        bgview.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        bgview.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)

        var animationView:AnimationView = AnimationView()
        animationView = AnimationView(name: "Loader")
        animationView.frame = CGRect(x:  bgview.frame.width/2-50, y: bgview.frame.height/2-50, width:100, height: 100)
        animationView.center = self.bgview.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop //loop //playOnce //autoReverse
        animationView.stop()
        self.bgview.removeSubviews()
        self.bgview.addSubview(animationView)
        animationView.play()
        
        //SHOW IN VIEW
        view.addSubview(bgview)
    }
    
    class func showHUD(withText text:String){
        LoadingHud.showHUDIn(view: UIApplication.shared.windows[0], withText: text)
    }
    
    class func showDefaultHUD(){
        LoadingHud.showHUD(withText: "")
    }
    
    class func showHUD(){
        LoadingHud.showHUD(withText: "")
    }
    
    class func showHUDText(){
         LoadingHud.showHUD()
    }
    class func dismissHUD(){
       bgview.removeFromSuperview()
    }
    
}

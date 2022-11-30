//
//  LoadingAnimationView.swift
//  LoadingView
//
//  Created by Admin on 15/03/18.
//  Copyright © 2018 el. All rights reserved.
//

import UIKit
public enum LoadingAnimationType {
    case ballRotate
}

class AnimationFactory {
    class func animationForType(_ type: LoadingAnimationType) -> NVActivityIndicatorAnimationDelegate {
        switch type {
        case .ballRotate:
            return NVActivityIndicatorAnimationBallRotate()
        }
    }
}

protocol NVActivityIndicatorAnimationDelegate {
    func setUpAnimation(in layer: CALayer, size: CGSize, color: UIColor)
}

open class LoadingAnimationView: UIView {
    fileprivate static let defaultType = LoadingAnimationType.ballRotate
    fileprivate static let defaultColor = UIColor.black
    fileprivate static let defaultSize = CGSize(width: 60, height: 60)
    
    fileprivate var type: LoadingAnimationType
    fileprivate var color: UIColor
    fileprivate var Size: CGSize
    
    required public init?(coder aDecoder: NSCoder) {
        self.type = LoadingAnimationView.defaultType
        self.color = LoadingAnimationView.defaultColor
        self.Size = LoadingAnimationView.defaultSize
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect, type: LoadingAnimationType = defaultType,color :UIColor, size: CGSize = defaultSize) {
        self.type = type
        self.color = color
        self.Size = size
        super.init(frame: frame)
    }
    
    func setupAnimation() {
        let animation = AnimationFactory.animationForType(type)
        layer.sublayers = nil
        animation.setUpAnimation(in: layer, size: self.Size, color: color)
    }
}

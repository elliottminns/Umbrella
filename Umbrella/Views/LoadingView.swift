//
//  LoadingView.swift
//  Umbrella
//
//  Created by Elliott Minns on 09/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import UIKit

private class LoadingViewInternal: UIView {
    
    let activityIndicator: UIActivityIndicatorView
    let visualEffectView: UIVisualEffectView
    
    private init() {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        let blur = UIBlurEffect(style: .Light)
        visualEffectView = UIVisualEffectView(effect: blur)
        super.init(frame: CGRectZero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(visualEffectView)
        addSubview(activityIndicator)
        
        
        activityIndicator.startAnimating()
        
        layer.cornerRadius = 6
        layer.masksToBounds = true
        loadConstraints()
    }
    
    func loadConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 9.0, *) {
            NSLayoutConstraint.activateConstraints([
                activityIndicator.centerXAnchor.constraintEqualToAnchor(centerXAnchor),
                activityIndicator.centerYAnchor.constraintEqualToAnchor(centerYAnchor),
                visualEffectView.topAnchor.constraintEqualToAnchor(topAnchor),
                visualEffectView.bottomAnchor.constraintEqualToAnchor(bottomAnchor),
                visualEffectView.leftAnchor.constraintEqualToAnchor(leftAnchor),
                visualEffectView.rightAnchor.constraintEqualToAnchor(rightAnchor)
            ])
        } else {
            
        }
    }
}

class LoadingView {
    
    private static var currentView: LoadingViewInternal?
    
    // Hide the initialiser
    private init() {}
    
    static func dismiss() {
        guard let currentView = currentView else { return }
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut,
                                   animations: {
                                    currentView.alpha = 0.0
        }) { completed in
            currentView.removeFromSuperview()
        }
    }
    
    static func show() {
        guard let window = UIApplication.sharedApplication().windows.first,
            view = window.subviews.last else {
            return
        }
        
        dismiss()
        show(inView: view)
    }
    
    static func show(inView view: UIView) {
        let loadingView = LoadingViewInternal()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        currentView = loadingView
        view.addSubview(loadingView)
        
        let height: CGFloat = 75
        let width: CGFloat = 150
        
        if #available(iOS 9.0, *) {
            NSLayoutConstraint.activateConstraints([
                loadingView.heightAnchor.constraintEqualToConstant(height),
                loadingView.widthAnchor.constraintEqualToConstant(width),
                loadingView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor),
                loadingView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor)
            ])
        } else {
            
        }
    }
}
//
//  PlaeryDetails+Gestures.swift
//  PodCastApp
//
//  Created by Sherif  Wagih on 9/30/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
extension PlayerDetailsView
{
    func setupAllGestures()
    {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesutre))
        addGestureRecognizer(panGestureRecognizer)
        containerStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(stackViewDismissal)))
    }
    @objc func stackViewDismissal(gesture:UIPanGestureRecognizer)
    {

        guard let rooController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {return}
        guard let height =  rooController.height else {return}
        guard let superViewHeight = superview?.frame.height else {return}
        if gesture.state == .changed
        {
            let translate = gesture.translation(in: self.superview)
            rooController.maximizeLayoutConstraint.constant = -(superViewHeight) + translate.y
            self.miniPlayerView.alpha =  translate.y / (superViewHeight - 150)
            self.containerStackView.alpha = 1 - translate.y / ( superViewHeight - 150 )
        }
        if gesture.state == .ended
        {
            let translateY = gesture.translation(in: self.superview).y
            if translateY > 64
            {
                rooController.maximizePlayerView(maximize: false)
                self.containerStackView.alpha = 0
                rooController.maximizeLayoutConstraint.constant = -height-64
                panGestureRecognizer.isEnabled = true
            }
        }
    }
    @objc func handleTapMaximize()
    {
        let rootController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        rootController?.maximizePlayerView(maximize: true)
        panGestureRecognizer.isEnabled = false
    }
    func panGestureChanged(rooController:MainTabBarController,gesture:UIPanGestureRecognizer,height:CGFloat)
    {
        let translate = gesture.translation(in: self.superview)
        rooController.maximizeLayoutConstraint.constant = translate.y-height-64
        self.miniPlayerView.alpha = 1 + translate.y / 200
        self.containerStackView.alpha = -translate.y / 200
    }
    func panGestureEnded(rooController:MainTabBarController,gesture:UIPanGestureRecognizer,height:CGFloat)
    {
        let translateY = gesture.translation(in: self.superview).y
        if translateY < -200 || gesture.velocity(in: superview).y < -500
        {
            rooController.maximizePlayerView(maximize: true)
            self.miniPlayerView.alpha = 0
            guard let selfSuperViewHeight = superview?.frame.height else {return}
            rooController.maximizeLayoutConstraint.constant = -selfSuperViewHeight
        }
        else
        {
            rooController.maximizePlayerView(maximize: false)
            self.containerStackView.alpha = 0
            rooController.maximizeLayoutConstraint.constant = -height-64
        }
        
    }
    @objc func handlePanGesutre(gesture:UIPanGestureRecognizer)
    {
        let rooController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        guard let height =  rooController?.height else {return}
        guard let wrapperRootController = rooController else {return}

        if gesture.state == .began
        {
            
        }
        else if gesture.state == .changed
        {
            panGestureChanged(rooController: wrapperRootController, gesture: gesture, height: height)
        }
        else if gesture.state == .ended
        {
            panGestureEnded(rooController: wrapperRootController, gesture: gesture, height: height)
        }
     
    }
}

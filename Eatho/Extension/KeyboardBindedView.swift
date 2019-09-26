//
//  KeyboardBindedView.swift
//  Eatho
//
//  Created by Серафима Зыкова on 01/08/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import UIKit

var delta: CGFloat = 0

extension UIView {
    
    /**
     WARNING:: use one bind at the time
     */
    
    func bindPositionToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardOpenHandle(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHideHandle(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func bindHeightToKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardSizeChangeHandle(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardPositionChangeHandle(_ notification: Notification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let curFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = targetFrame.origin.y - curFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }) { (true) in
            self.layoutIfNeeded()
        }
    }
    
    @objc func keyboardOpenHandle(_ notification: Notification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    
        var deltaY: CGFloat = 0
        if self.frame.maxY > targetFrame.minY {
            deltaY = targetFrame.minY - self.frame.maxY
        }
        delta = deltaY
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }) { (true) in
            self.layoutIfNeeded()
        }
    }
    
    @objc func keyboardHideHandle(_ notification: Notification) {
        if delta == 0 {
            return
        }
        
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        
        let deltaY = -delta
        delta = 0
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }) { (true) in
            self.layoutIfNeeded()
        }
    }
    
    @objc func keyboardSizeChangeHandle(_ notification: Notification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        
        let curFrame = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = targetFrame.origin.y - curFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: curve), animations: {
            self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width, height: self.frame.height + deltaY)
        }) { (true) in
            self.layoutIfNeeded()
        }
    }
}

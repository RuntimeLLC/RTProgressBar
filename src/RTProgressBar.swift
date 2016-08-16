//
//  RTProgressBar.swift
//  RTProgressBar
//
//  Created by Daniyar Salakhutdinov on 01.08.16.
//  Copyright © 2016 Daniyar Salakhutdinov. All rights reserved.
//

import Cocoa
import QuartzCore

let kRTProgressBarMaxProgressValue: Double = 100

class RTProgressBar: NSView {
    
    private let sublayer = CALayer()
    private let inlayer = CAGradientLayer()
    private let lock = NSLock()
    
    private var progressValue: Double = 0
    var progress: Double { // from 0 to 100
        set(value) {
            setProgress(value, animated: false)
        }
        get {
            return progressValue
        }
    }
    
    var color: NSColor = NSColor.blueColor() {
        didSet {
            updateColor()
        }
    }
    
    var animationColor: NSColor? = nil {
        didSet {
            updateColor()
        }
    }
    
    var backgroundColor: NSColor = NSColor.clearColor() {
        didSet {
            layer?.backgroundColor = backgroundColor.CGColor
        }
    }
    
    var animating: Bool = false {
        didSet {
            if !indeterminate && animating {
                return
            }
            updateColor()
            if animating {
                inlayer.backgroundColor = nil
                inlayer.locations = [0, 0.001, 0.009, 0.1, 1.1]
                let animation = CABasicAnimation(keyPath: "locations")
                animation.repeatCount = .infinity
                animation.duration = 1.5
                animation.fromValue = inlayer.locations
                animation.toValue = [0, 1, 1.1, 1.11, 1.12]
                inlayer.addAnimation(animation, forKey: "locations")
            } else {
                inlayer.removeAllAnimations()
                inlayer.locations = nil
                inlayer.colors = nil
                inlayer.backgroundColor = color.CGColor
            }
        }
    }
    
    var indeterminate: Bool = false {
        didSet {
            if !indeterminate {
                animating = false
            }
            sublayer.hidden = indeterminate
            inlayer.hidden = !indeterminate
        }
    }
    
    // MARK: - view lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        //
        wantsLayer = true
        sublayer.anchorPoint = CGPointZero
        layer!.backgroundColor = backgroundColor.CGColor
        layer!.addSublayer(sublayer)
        inlayer.anchorPoint = CGPointZero
        inlayer.startPoint = CGPoint(x: 0, y: 0.5)
        inlayer.endPoint = CGPoint(x: 1, y: 0.5)
        inlayer.frame = bounds
        layer!.addSublayer(inlayer)
        inlayer.hidden = true
        updateColor()
        updateLayerAnimated(false)
    }
    
    override func layout() {
        super.layout()
        //
        updateLayerAnimated(false)
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        inlayer.frame = bounds
        CATransaction.commit()
    }
    
    // MARK: - progress value setters
    func append(progress: Double, animated: Bool) {
        let value = progressValue + progress
        setProgress(value, animated: animated)
    }
    
    func setProgress(progress: Double, animated: Bool) {
        // set new value
        progressValue = progress > kRTProgressBarMaxProgressValue ? kRTProgressBarMaxProgressValue : progress
        updateLayerAnimated(animated)
    }
    
    // MARK: - inner methods
    private func updateColor() {
        sublayer.backgroundColor = color.CGColor
        let rightColor = animationColor ?? NSColor.clearColor()
        let inColor = animating ? rightColor : color
        inlayer.colors = [color.CGColor, color.CGColor, inColor.CGColor, color.CGColor, color.CGColor]
    }
    
    private func updateLayerAnimated(animated: Bool) {
        // synchronize
        lock.lock()
        defer {
            lock.unlock()
        }
        // frame
        let size = bounds.size
        let value = progressValue / kRTProgressBarMaxProgressValue
        let layerWidth = CGFloat(Double(size.width) * value)
        if animated {
            // add animation
            let toValue = CGRect(origin: CGPointZero, size: CGSize(width: layerWidth, height: size.height))
            let animation = CABasicAnimation(keyPath: "frame")
            animation.duration = 0.3
            animation.fromValue = NSValue(rect: sublayer.frame)
            animation.toValue = NSValue(rect: toValue)
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            sublayer.frame = toValue
            sublayer.addAnimation(animation, forKey: "frame")
        } else {
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            sublayer.frame = CGRect(origin: CGPointZero, size: CGSize(width: layerWidth, height: size.height))
            CATransaction.commit()
        }
    }
}

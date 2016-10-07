//
//  ViewController.swift
//  RTProgressBar
//
//  Created by Daniyar Salakhutdinov on 01.08.16.
//  Copyright © 2016 Daniyar Salakhutdinov. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet fileprivate weak var progressBar: RTProgressBar!
    @IBOutlet fileprivate weak var startButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.color = NSColor(calibratedRed: 0.1, green: 0.1, blue: 0.8, alpha: 0.6)
        progressBar.backgroundColor = NSColor.lightGray
        progressBar.animationColor = NSColor.white
    }
    
    @IBAction func buttonDidClick(_ sender: NSButton) {
        startButton.isEnabled = false
        progressBar.alphaValue = 1
        progressBar.progress = 0
        startProgressIteration()
    }
    
    @IBAction func checkBoxDidClick(_ sender: NSButton) {
        startButton.isEnabled = true
        let indeterminate = sender.state == NSOnState
        progressBar.indeterminate = indeterminate
    }
    
    // MARK: - dealing with progress
    fileprivate func startProgressIteration() {
        if progressBar.indeterminate {
            progressBar.animating = true
        } else {
            let value = Double(arc4random_uniform(5) + 8)
            let delay = TimeInterval(arc4random_uniform(15)) / 10
            appendProgress(value, afterDelay: delay)
        }
    }
    
    fileprivate func appendProgress(_ progress: Double, afterDelay delay: TimeInterval) {
        // calculate time
        let interval = Int64(UInt64(delay) * NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(interval) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.appendProgress(progress)
        }
    }
    
    fileprivate func appendProgress(_ progress: Double) {
        progressBar.append(progress, animated: true)
        if progressBar.progress >= 100 {
            NSAnimationContext.runAnimationGroup({ context in
                self.progressBar.animator().alphaValue = 0
                self.startButton.isEnabled = true
                context.duration = 0.3
            }, completionHandler: nil)
        } else {
            startProgressIteration()
        }
    
    }
}


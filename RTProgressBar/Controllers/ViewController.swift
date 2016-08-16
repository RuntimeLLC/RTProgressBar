//
//  ViewController.swift
//  RTProgressBar
//
//  Created by Daniyar Salakhutdinov on 01.08.16.
//  Copyright © 2016 Daniyar Salakhutdinov. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet private weak var progressBar: RTProgressBar!
    @IBOutlet private weak var startButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.color = NSColor(calibratedRed: 0.1, green: 0.1, blue: 0.8, alpha: 0.6)
        progressBar.backgroundColor = NSColor.lightGrayColor()
        progressBar.animationColor = NSColor.whiteColor()
    }

    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func buttonDidClick(sender: NSButton) {
        startButton.enabled = false
        progressBar.alphaValue = 1
        progressBar.progress = 0
        startProgressIteration()
    }
    
    @IBAction func checkBoxDidClick(sender: NSButton) {
        startButton.enabled = true
        let indeterminate = sender.state == NSOnState
        progressBar.indeterminate = indeterminate
    }
    
    // MARK: - dealing with progress
    private func startProgressIteration() {
        if progressBar.indeterminate {
            progressBar.animating = true
        } else {
            let value = Double(arc4random_uniform(5) + 8)
            let delay = NSTimeInterval(arc4random_uniform(15)) / 10
            appendProgress(value, afterDelay: delay)
        }
    }
    
    private func appendProgress(progress: Double, afterDelay delay: NSTimeInterval) {
        // calculate time
        let interval = Int64(UInt64(delay) * NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, interval)
        dispatch_after(time, dispatch_get_main_queue()) {
            self.appendProgress(progress)
        }
    }
    
    private func appendProgress(progress: Double) {
        progressBar.append(progress, animated: true)
        if progressBar.progress >= 100 {
            NSAnimationContext.runAnimationGroup({ context in
                self.progressBar.animator().alphaValue = 0
                self.startButton.enabled = true
                context.duration = 0.3
            }, completionHandler: nil)
        } else {
            startProgressIteration()
        }
    
    }
}


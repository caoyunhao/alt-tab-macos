//
//  MiniPanel.swift
//  alt-tab-macos
//
//  Created by Yunhao on 2021/11/21.
//  Copyright © 2021 lwouis. All rights reserved.
//

import Cocoa

fileprivate let padding: Int = 10
fileprivate let appSize: Int = 40
//let appIconSize: Int = 50

class MiniPanel: NSPanel {
    fileprivate var view: PanelView! = PanelView();

    convenience init() {
        self.init(contentRect: .zero, styleMask: [], backing: .buffered, defer: false)
        
        isFloatingPanel = true
        hidesOnDeactivate = false
        contentView!.addSubview(view)
        backgroundColor = .clear
        collectionBehavior = .canJoinAllSpaces
    }
    
    func updateViews(_ windows: [Window], in screen: NSScreen) {
        view.subviews.removeAll()
        let count = windows.count
        
        if count <= 1 {
            setFrameSize(.zero)
            return
        }
        
        let appWidth = appSize + padding * 2
        let appDirectLength = count * (appSize + padding) + padding
        
        setFrameOrigin(NSPoint(x: padding, y: Int(screen.frame.height) / 2 - (appDirectLength) / 2))
        setFrameSize(NSSize(width: appWidth, height: appDirectLength))
        
        for (i, window) in windows.enumerated() {
            let appView = AppView();
//            appView.frame.origin = NSPoint(x: (padding + appSize) * i + padding, y: padding)
            appView.frame.origin = NSPoint(x: padding, y: appDirectLength - ((padding + appSize) * (i + 1)))
            appView.frame.size = NSSize(width: appSize, height: appSize)
            appView.onClick = { e in
                window.focus()
            }
            
            let imageView = NSImageView()
            imageView.image = window.icon
            let size = NSSize(width: appSize, height: appSize)
            imageView.image?.size = size
            imageView.frame.size = size
            appView.addSubview(imageView)

            view.addSubview(appView)
        }
    }
    
    func show() {
        orderFront(nil)
    }
    
    func hide() {
        
    }
    
    func setFrameSize(_ size: NSSize) {
        view.frame.size = size
        setContentSize(size)
    }
}

fileprivate class PanelView: NSView {
    convenience init() {
        self.init(frame: .zero)
        wantsLayer = true
        layer!.cornerRadius = 5
        layer!.backgroundColor = CGColor.init(gray: 0.2, alpha: 0.2)
    }
}

fileprivate class AppView: NSView {
    var onClick: ((NSEvent) -> ())?
    
    convenience init() {
        self.init(frame: .zero)
        wantsLayer = true
        layer!.cornerRadius = 5
        layer!.backgroundColor = .clear
    }
    
    override func mouseDown(with event: NSEvent) {
        print("on click")
        onClick?(event)
    }
}

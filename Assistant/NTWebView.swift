//
//  NTWebView.swift
//  Assistant
//
//  Created by mathieu on 26.08.18.
//  Copyright © 2018 Mathieu Knecht. All rights reserved.
//

import Foundation
import WebKit

protocol NTWebViewDelegate {
    func didScroll()
}

class NTWebView: WKWebView {
    
    var delegate: NTWebViewDelegate?
    var isSending = false
    var timer: Timer?
    var preventScroll = false
    
    override func scrollWheel(with event: NSEvent) {
        if !self.preventScroll {
            super.scrollWheel(with: event)
            if !self.isSending{
                self.isSending = true
                self.timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { (timer) in
                    self.delegate?.didScroll()
                    self.isSending = false
                })
            }
        }
    }
}

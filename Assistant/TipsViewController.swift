//
//  TipsViewController.swift
//  Assistant
//
//  Created by mathieu on 26.08.18.
//  Copyright © 2018 Mathieu Knecht. All rights reserved.
//

import Foundation
import Cocoa
import WebKit

class TipsViewController: NSViewController, WKNavigationDelegate, NTWebViewDelegate {
    
    @IBOutlet weak var webview: NTWebView!
    var command: String?
    var height: Float?
    
    @IBOutlet weak var btBot: NSButton!
    @IBOutlet weak var btTop: NSButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func didScroll() {
        self.webview.evaluateJavaScript("document.body.scrollTop", completionHandler: { (res, err) in
            if err == nil {
                if let pos = res as? NSNumber {
                    
                    if let height = self.height {
                        
                        self.btTop.isHidden = false
                        self.btBot.isHidden = false
                        
                        if pos.floatValue <= 0 {
                            self.btTop.isHidden = true
                        }
                        
                        if height <= pos.floatValue+Float(self.webview.frame.height) {
                            self.btBot.isHidden = true
                        }
                    }
                }
                
            }
        })
    }
    
    /*func displayTip (tip: [String: Any]) {
        guard let indexPath = tip["indexPath"] as? String
            else{
                return
        }
        
        self.webview.delegate = self
        self.webview.navigationDelegate = self
        
        //LogManager.shared.log(line: "Assistant display "+indexPath)
        self.webview.load(URLRequest(url: URL(fileURLWithPath: indexPath)))
        self.btBot.alphaValue = 0.6
        self.btTop.alphaValue = 0.6
        if let buttons = tip["buttons"] as? [[String: Any]] {
            for button in buttons {
                if let bt = self.getButton(dic: button) {
                    self.view.addSubview(bt)
                }
            }
        }
    }*/
    
    func displayTip (tip: String) {
        
        self.webview.delegate = self
        self.webview.navigationDelegate = self
        
        //LogManager.shared.log(line: "Assistant display "+indexPath)
        self.webview.load(URLRequest(url: URL(fileURLWithPath: tip)))
        self.btBot.alphaValue = 0.6
        self.btTop.alphaValue = 0.6
    }
    
    @IBAction func btBotTouched(_ sender: Any) {
        self.btTop.isHidden = false
        self.webview.evaluateJavaScript("window.scrollBy({top: 100,left: 0,behavior: \"smooth\"});") { (res, err) in
            self.webview.evaluateJavaScript("document.body.scrollTop", completionHandler: { (res, err) in
                if err == nil {
                    if let pos = res as? NSNumber {
                        
                        if let height = self.height {
                            if height <= pos.floatValue+Float(self.webview.frame.height) {
                                self.btBot.isHidden = true
                            }
                        }
                    }
                    
                }
            })
        }
    }
    
    @IBAction func btTopTouched(_ sender: Any) {
        self.btBot.isHidden = false
        self.webview.evaluateJavaScript("window.scrollBy({top: -100,left: 0,behavior: \"smooth\"});") { (res, err) in
            self.webview.evaluateJavaScript("document.body.scrollTop", completionHandler: { (res, err) in
                if err == nil {
                    if let pos = res as? NSNumber {
                        if pos.floatValue <= 0 {
                            self.btTop.isHidden = true
                        }
                    }
                    
                }
            })
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webview.evaluateJavaScript("document.body.scrollHeight") { (res, err) in
            if err == nil{
                if let height = res as? NSNumber {
                    self.height = height.floatValue
                    if height.floatValue > Float(self.webview.frame.height) {
                        self.btBot.isHidden = false
                        
                    }else{
                        self.webview.preventScroll = true
                    }
                }
            }
        }
    }
    
    func getButton(dic: [String: Any]) -> NSButton? {
        guard let frame = dic["frame"] as? [String: Float],
            let x = frame["x"],
            let y = frame["y"],
            let width = frame["width"],
            let height = frame["height"],
            let type = dic["type"] as? String,
            let label = dic["label"] as? String
            else{
                return nil
        }
        
        let bt = NSButton(frame: NSRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(width), height: CGFloat(height)))
        bt.title = label
        
        switch type{
        case "script":
            if let command = dic["command"] as? String {
                self.command = command
                bt.action = #selector(execScript)
            }
            break;
        case "close":
            bt.action = #selector(close)
            break;
        case "terminate":
            bt.action = #selector(terminate)
            break;
        default:
            break;
        }
        
        return bt
    }
    
    @objc func close(){
        if let app = NSApplication.shared.delegate as? AppDelegate {
            app.closeWindow()
        }
    }
    
    @objc func execScript() {
        if let sc = self.command {
            ScriptManager.run(script: sc, lang: .bash, out: { (out) in
                print(out)
            }, err: { (err) in
                print(err)
            }) { (code) in
                print(code)
            }
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    @objc func terminate(){
        exit(0)
    }
}

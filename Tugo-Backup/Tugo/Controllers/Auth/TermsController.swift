//
//  TermsController.swift
//  Tugo
//
//  Created by Alex on 27/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import WebKit
import NVActivityIndicatorView

class TermsController: UIViewController, WKNavigationDelegate, NVActivityIndicatorViewable{
    // MARK: - Let-Var
    
    // MARK: - Outlets
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
    
    
    // MARK: - SetUps / Funcs
    func setUpUI(){}
    
    func setUpActions(){
        //Delegating webview
        webView.navigationDelegate = self
        
        //Setting up url
        guard let url = URL(string: K.termsSite) else {return}
        webView.load(URLRequest(url: url))
        
        //Set refresh button at Webview
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        toolbarItems = [refresh]
        navigationController?.isToolbarHidden = false
    }
    
    private func gettingData(){}
    
    //Webview
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        customLoading()
        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.splashTimeOut(sender:)), userInfo: nil, repeats: false)
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {}
    
    //Indicator
    
    //Custom loading
    func customLoading(){
        let size = CGSize(width: 30, height: 30)
        self.startAnimating(size, message: "...", type: NVActivityIndicatorType.orbit)
    }
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Objective C
    @objc func splashTimeOut(sender : Timer){
        self.stopAnimating()
    }
}

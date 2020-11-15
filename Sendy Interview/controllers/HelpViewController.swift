//
//  HelpViewController.swift
//  Sendy Interview
//
//  Created by Boaz James on 13/11/2020.
//  Copyright © 2020 Boaz James. All rights reserved.
//

import UIKit
import WebKit

class HelpViewController: UIViewController {
    
    private var navBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.isTranslucent = false
        if var textAttributes = navBar.titleTextAttributes {
            textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.black
            navBar.titleTextAttributes = textAttributes
        }
        return navBar
    }()
    
    var navItem = {
        return UINavigationItem(title: "Help")
    }()
    
    private var webView: WKWebView = {
        let wbView = WKWebView()
        wbView.translatesAutoresizingMaskIntoConstraints = false
        return wbView
    }()
    
    var layoutGuide: UILayoutGuide {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide
        } else {
            return view.layoutMarginsGuide
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        loadHtml()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(navBar)
        view.addSubview(webView)
        
        navBar.setItems([navItem], animated: false)
        
        NSLayoutConstraint.activate([navBar.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
                                     navBar.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
                                     navBar.topAnchor.constraint(equalTo: layoutGuide.topAnchor)])
        
        NSLayoutConstraint.activate([webView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
        webView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
        webView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 10),
        webView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -10)
        ])
        
    }
    
    private func loadHtml() {
        let html = "<html><header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header><body><p><strong> Selecting Location </strong></p><p>You can select location by following the following text:</p><ol><li>Click on add button of far right.</li><li>Click any point on the map to select the location.</li><li>Click save button when done.</li></ol><p><strong> Viewing Weather </strong></p><p>To view weather of a location just click on the location.</p><p>You can change the units on the settings page.</p><p><strong> Deleting location </strong></p><p>You can delete location by swiping the item to the left.</p></body></html>"
        webView.loadHTMLString(html, baseURL: nil)
    }

}

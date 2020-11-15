//
//  ViewController.swift
//  Sendy Interview
//
//  Created by Boaz James on 13/11/2020.
//  Copyright © 2020 Boaz James. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeViewController = HomeViewController()
                
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home")?.renderResizedImage(25.0), tag: 0)

        let helpViewController = HelpViewController()

        helpViewController.tabBarItem = UITabBarItem(title: "Help", image: UIImage(named: "question")?.renderResizedImage(25.0), tag: 1)


        let settingsViewController = HelpViewController()
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings")?.renderResizedImage(25.0), tag: 2)


        let tabBarList = [homeViewController, helpViewController, settingsViewController]
        
        viewControllers = tabBarList
    }


}


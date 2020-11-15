//
//  SettingsViewController.swift
//  Sendy Interview
//
//  Created by Boaz James on 13/11/2020.
//  Copyright © 2020 Boaz James. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {
    private var selectedUnitView: UnitView!
    
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
        return UINavigationItem(title: "Settings")
    }()
    
    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        return view
    }()
    
    private var clearView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private var lblClear: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Futura", size: 17)
        label.text = "Clear saved locations"
        return label
    }()
    
    private var unitTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Futura", size: 17)
        label.text = "Units"
        return label
    }()
    
    private var standardView: UnitView = {
        let view = UnitView()
        view.unit = UNIT_STANDARD
        view.label.text = UNIT_STANDARD.capitalized
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imgView.isHidden = Configuration.getUnits() != UNIT_STANDARD
        return view
    }()
    
    private var metricView: UnitView = {
        let view = UnitView()
        view.unit = UNIT_METRIC
        view.label.text = UNIT_METRIC.capitalized
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imgView.isHidden = Configuration.getUnits() != UNIT_METRIC
        return view
    }()
    
    private var imperialView: UnitView = {
        let view = UnitView()
        view.unit = UNIT_IMPERIAL
        view.label.text = UNIT_IMPERIAL.capitalized
        view.translatesAutoresizingMaskIntoConstraints = false
        view.divider.isHidden = true
        view.imgView.isHidden = Configuration.getUnits() != UNIT_IMPERIAL
        return view
    }()
    
    var divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        return view
    }()
    
    var divider1: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        return view
    }()
    
    var divider2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        return view
    }()
    
    var divider3: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        return view
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .white
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        setupUnits()
        setupGestures()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(navBar)
        view.addSubview(containerView)
        containerView.addSubview(unitTitle)
        containerView.addSubview(stackView)
        containerView.addSubview(divider)
        containerView.addSubview(divider1)
        containerView.addSubview(clearView)
        clearView.addSubview(lblClear)
        clearView.addSubview(divider2)
        clearView.addSubview(divider3)
        
        navBar.setItems([navItem], animated: false)
        
        NSLayoutConstraint.activate([
            navBar.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            navBar.topAnchor.constraint(equalTo: layoutGuide.topAnchor)])
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            containerView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            unitTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            unitTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
        ])
        
        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            divider.topAnchor.constraint(equalTo: unitTitle.bottomAnchor, constant: 10),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: divider.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            divider1.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            divider1.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            divider1.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            divider1.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            clearView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            clearView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            clearView.topAnchor.constraint(equalTo: divider1.bottomAnchor, constant: 20),
        ])
        
        NSLayoutConstraint.activate([
            divider2.leadingAnchor.constraint(equalTo: clearView.leadingAnchor),
            divider2.trailingAnchor.constraint(equalTo: clearView.trailingAnchor),
            divider2.topAnchor.constraint(equalTo: clearView.topAnchor),
            divider2.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            lblClear.leadingAnchor.constraint(equalTo: clearView.leadingAnchor, constant: 20),
            lblClear.topAnchor.constraint(equalTo: divider2.bottomAnchor, constant: 10),
        ])
        
        NSLayoutConstraint.activate([
            divider3.leadingAnchor.constraint(equalTo: clearView.leadingAnchor),
            divider3.trailingAnchor.constraint(equalTo: clearView.trailingAnchor),
            divider3.topAnchor.constraint(equalTo: lblClear.bottomAnchor, constant: 10),
            divider3.heightAnchor.constraint(equalToConstant: 1),
            divider3.bottomAnchor.constraint(equalTo: clearView.bottomAnchor)
        ])
        
    }
    
    private func setupUnits() {
        stackView.addArrangedSubview(standardView)
        stackView.addArrangedSubview(metricView)
        stackView.addArrangedSubview(imperialView)
        
        standardView.delegate = self
        metricView.delegate = self
        imperialView.delegate = self
        
        if Configuration.getUnits() == UNIT_STANDARD {
            selectedUnitView = standardView
        } else if Configuration.getUnits() == UNIT_IMPERIAL {
            selectedUnitView = imperialView
        } else {
            selectedUnitView = metricView
        }
    }
    
    private func setupGestures() {
        clearView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showConfirmationAlert)))
    }
    
}

// MARK: UnitSelectionDelegate
extension SettingsViewController: UnitSelectionDelegate {
    func unitView(didselectUnit unit: String) {
        if unit != Configuration.getUnits() {
            selectedUnitView.imgView.isHidden = true
            Configuration.setUnits(unit)
            if unit == UNIT_STANDARD {
                selectedUnitView = standardView
            } else if Configuration.getUnits() == UNIT_IMPERIAL {
                selectedUnitView = imperialView
            } else {
                selectedUnitView = metricView
            }
            
            selectedUnitView.imgView.isHidden = false
        }
    }
    
    @objc private func showConfirmationAlert() {
        self.showWarningAlert(title: "Delete", message: "Do you want to clear all saved locations?", actionButtonClosure: clearLocations)
    }
    
    private func clearLocations() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.databaseContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Location")
        
        do {
            let locations = try managedContext.fetch(fetchRequest)
            if locations.isEmpty {
                showAlert(title: "Oops!!", message: "No locations to clear")
                return
            }
            locations.forEach { (item) in
                managedContext.delete(item)
            }
            
            do {
                try managedContext.save()
                NotificationCenter.default.post(name: .onDeleteLocations, object: nil)
                showAlert(title: "Success", message: "Locations cleared successfully")
            } catch {
                showAlert("Could not clear locations")
            }
        } catch let error as NSError {
            showAlert("Could not clear locations")
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}

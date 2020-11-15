//
//  AddLocationViewController.swift
//  Sendy Interview
//
//  Created by Boaz James on 13/11/2020.
//  Copyright © 2020 Boaz James. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class AddLocationViewController: UIViewController {
    private var mapView: MKMapView!
    private var btnCancel: UIButton!
    private var btnDone: UIButton!
    private var cvLocate: CardView!
    private var selectedAddress = ""
    private var selectedCoordidate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    private var selectedPoint: MKPointAnnotation?
    var saveLocationDelegate: SaveLocationDelegate!
    
    lazy var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.distanceFilter = 10
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupGestures()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showCurrentLocation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager.stopUpdatingLocation()
    }
    
    private func setupViews() {
        var layoutGuide: UILayoutGuide {
            if #available(iOS 11.0, *) {
                return view.safeAreaLayoutGuide
            } else {
                return view.layoutMarginsGuide
            }
        }
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mapView)
        mapView.pinToView(parentView: view)
        
        
        btnCancel = UIButton()
        btnCancel.translatesAutoresizingMaskIntoConstraints = false
        btnCancel.setTitle("Cancel", for: .normal)
        btnCancel.setTitleColor(UIColor.red, for: .normal)
        view.addSubview(btnCancel)
        btnCancel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 15).isActive = true
        btnCancel.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 10).isActive = true
        
        btnDone = UIButton()
        btnDone.translatesAutoresizingMaskIntoConstraints = false
        btnDone.setTitle("Save", for: .normal)
        btnDone.setTitleColor(btnDone.tintColor, for: .normal)
        view.addSubview(btnDone)
        btnDone.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -15).isActive = true
        btnDone.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 10).isActive = true
        
        cvLocate = CardView()
        cvLocate.translatesAutoresizingMaskIntoConstraints = false
        cvLocate.isUserInteractionEnabled = true
        cvLocate.backgroundColor = .white
        cvLocate.cornerRadius = 20
        view.addSubview(cvLocate)
        cvLocate.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -15).isActive = true
        cvLocate.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -30).isActive = true
        cvLocate.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cvLocate.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        let ivNavigation = UIImageView()
        ivNavigation.translatesAutoresizingMaskIntoConstraints = false
        ivNavigation.image = UIImage(named: "cursor")
        ivNavigation.contentMode = .scaleToFill
        cvLocate.addSubview(ivNavigation)
        ivNavigation.pinToView(parentView: cvLocate, constant: 8)
        
    }
    
    private func setupGestures() {
        self.btnCancel.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        self.btnDone.addTarget(self, action: #selector(saveLocation), for: .touchUpInside)
        self.cvLocate.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCurrentLocation)))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(onMapLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.1
        self.mapView.addGestureRecognizer(longPressGesture)
    }
    
    private func updateLocationOnMap(to location: CLLocation, with name: String?) {
        selectedCoordidate = location.coordinate
        selectedAddress = name ?? "Could not find address"
        self.mapView.removeAnnotations(self.mapView.annotations)
        selectedPoint = MKPointAnnotation()
        selectedPoint?.title = name
        selectedPoint?.coordinate = location.coordinate
        self.mapView.addAnnotation(selectedPoint!)
        
        let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        self.mapView.setRegion(viewRegion, animated: true)
    }
    
    @objc private func showCurrentLocation() {
        guard let currentLocation = locationManager.location
            else { return }
        
        currentLocation.lookUpLocationName { (name) in
            self.updateLocationOnMap(to: currentLocation, with: name)
        }
    }
    
    @objc private func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func saveLocation() {
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        
        let managedContext = appDelegate.databaseContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Location", in: managedContext)!
        
        let location = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        location.setValue(selectedAddress, forKeyPath: "address")
        location.setValue(selectedCoordidate.latitude, forKeyPath: "lat")
        location.setValue(selectedCoordidate.longitude, forKeyPath: "lng")
        
        do {
          try managedContext.save()
            self.saveLocationDelegate.didSaveLocation()
            self.dismissController()
        } catch let error as NSError {
            showAlert("Could not save address")
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    @objc func onMapLongPress(_ sender: UIGestureRecognizer){
        print("long tap")
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let coordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            location.lookUpLocationName { (name) in
                self.updateLocationOnMap(to: location, with: name)
            }
        }
    }

}

// MARK: CLLocationManagerDelegate
extension AddLocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
}

protocol SaveLocationDelegate: AnyObject {
    func didSaveLocation()
}

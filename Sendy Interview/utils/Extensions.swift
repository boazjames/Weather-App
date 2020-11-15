//
//  Extensions.swift
//  Sendy Interview
//
//  Created by Boaz James on 13/11/2020.
//  Copyright © 2020 Boaz James. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation

extension UIImage {
    func renderResizedImage (_ newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1)
        defer { UIGraphicsEndImageContext() }

        self.draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
        
    }
    
}

extension UIView {
    func pinToView(parentView: UIView, leading: Bool = true, trailing: Bool = true, top: Bool = true, bottom: Bool = true) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = leading
        self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = trailing
        self.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = top
        self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = bottom
    }
    
    func pinToView(parentView: UIView, constant: CGFloat, leading: Bool = true, trailing: Bool = true, top: Bool = true, bottom: Bool = true) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: constant).isActive = leading
        self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -constant).isActive = trailing
        self.topAnchor.constraint(equalTo: parentView.topAnchor, constant: constant).isActive = top
        self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -constant).isActive = bottom
    }
    
    func centerOnView(parentView: UIView, centerX: Bool = true, centerY: Bool = true) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = centerX
        self.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = centerY
    }
}

extension CLLocation {
    
    func lookUpPlaceMark(_ handler: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "en_KE")
        if #available(iOS 11.0, *) {
            geocoder.reverseGeocodeLocation(self, preferredLocale: locale) { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    handler(firstLocation)
                }
                else {
                    handler(nil)
                }
            }
        } else {
            geocoder.reverseGeocodeLocation(self) { (placemarks, error) in
                if error == nil {
                    let firstLocation = placemarks?[0]
                    handler(firstLocation)
                }
                else {
                    handler(nil)
                }
            }
        }
    }
    
    func lookUpLocationName(_ handler: @escaping (String?) -> Void) {
        
        lookUpPlaceMark { (placemark) in
            print(placemark)
            handler(placemark?.name)
        }
    }
}

extension UIViewController {
    func showNetworkError( actionButtonClosure: @escaping () -> Void) {
        let alert = UIAlertController(title: "Network Error", message: "Please check your internet connection", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) in
            actionButtonClosure()
        }))
        
        self.present(alert, animated: true)
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        
        self.present(alert, animated: true)
    }
}

extension UIImageView {
    func load(link: String) {
        if let url = URL(string: link) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    }
                }
            }
        }
    }
}

var vSpinner : UIView?
extension UIViewController {
    func showProgress(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        spinnerView.backgroundColor = .white
        spinnerView.isUserInteractionEnabled = false
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.color = onView.tintColor
        ai.startAnimating()
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            ai.centerOnView(parentView: spinnerView)
            onView.addSubview(spinnerView)
            
            spinnerView.pinToView(parentView: onView)
        }
        
        vSpinner = spinnerView
    }
    
    func hideProgress() {
        DispatchQueue.main.async {
            vSpinner?.isUserInteractionEnabled = true
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}

extension Date {
    static func currentDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else { return Date() }

        return localDate
    }
    
    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: self) else { return self }

        return localDate
    }
}

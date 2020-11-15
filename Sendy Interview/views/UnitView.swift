//
//  UnitView.swift
//  Sendy Interview
//
//  Created by Boaz James on 15/11/2020.
//  Copyright © 2020 Boaz James. All rights reserved.
//

import UIKit

class UnitView: UIView {
    var unit: String!
    var delegate: UnitSelectionDelegate!
    
    var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "tick")
        imgView.contentMode = .scaleToFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    var label: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Futura", size: 17)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = .white
        self.addSubview(imgView)
        self.addSubview(label)
        self.addSubview(divider)
        NSLayoutConstraint.activate([
            imgView.heightAnchor.constraint(equalToConstant: 20),
            imgView.widthAnchor.constraint(equalToConstant: 20),
            imgView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            imgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            imgView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: imgView.leadingAnchor, constant: -10),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        NSLayoutConstraint.activate([
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            divider.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            divider.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupGestures() {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectUnit)))
    }
    
    @objc func didSelectUnit() {
        delegate.unitView(didselectUnit: unit)
    }
    
}

protocol UnitSelectionDelegate: AnyObject {
    func unitView(didselectUnit unit: String)
}

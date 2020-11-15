//
//  LocationCell.swift
//  Sendy Interview
//
//  Created by Boaz James on 13/11/2020.
//  Copyright © 2020 Boaz James. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "location")
        imgView.contentMode = .scaleToFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    var lblAddress: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Futura", size: 17)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addSubview(imgView)
        self.addSubview(lblAddress)
        NSLayoutConstraint.activate([
            imgView.heightAnchor.constraint(equalToConstant: 20),
            imgView.widthAnchor.constraint(equalToConstant: 20),
            imgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            imgView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            lblAddress.leadingAnchor.constraint(equalTo: self.imgView.trailingAnchor, constant: 10),
            lblAddress.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            lblAddress.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

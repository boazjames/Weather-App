//
//  WeatherCell.swift
//  Sendy Interview
//
//  Created by Boaz James on 14/11/2020.
//  Copyright © 2020 Boaz James. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {
    var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleToFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    var lblTemp: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Futura", size: 25)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "25°C"
        return lbl
    }()
    
    var lblHum: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Futura", size: 17)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Humidity: 50%"
        return lbl
    }()
    
    var lblPrecip: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Futura", size: 17)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Precipitation: 50%"
        return lbl
    }()
    
    var lblTime: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Futura", size: 17)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "10:30 am"
        return lbl
    }()
    
    var lblWind: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Futura", size: 17)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Wind: 20 km/h"
        return lbl
    }()
    
    var cardView: CardView = {
        let view = CardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.cornerRadius = 5
        view.backgroundColor = .white
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addSubview(cardView)
        cardView.pinToView(parentView: self, constant: 10)
        cardView.addSubview(imgView)
        cardView.addSubview(lblTemp)
        cardView.addSubview(lblTime)
        cardView.addSubview(lblHum)
        cardView.addSubview(lblPrecip)
        cardView.addSubview(lblWind)
        NSLayoutConstraint.activate([
            imgView.heightAnchor.constraint(equalToConstant: 80),
            imgView.widthAnchor.constraint(equalToConstant: 80),
            imgView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            imgView.topAnchor.constraint(equalTo: cardView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            lblTemp.leadingAnchor.constraint(equalTo: self.imgView.trailingAnchor, constant: 10),
            lblTemp.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            lblTemp.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            lblTime.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            lblTime.topAnchor.constraint(equalTo: imgView.bottomAnchor),
            lblTime.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            lblPrecip.leadingAnchor.constraint(equalTo: lblTemp.trailingAnchor, constant: 10),
            lblPrecip.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            lblPrecip.topAnchor.constraint(equalTo: lblTemp.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            lblHum.leadingAnchor.constraint(equalTo: lblPrecip.leadingAnchor),
            lblHum.trailingAnchor.constraint(equalTo: lblPrecip.trailingAnchor, constant: -10),
            lblHum.topAnchor.constraint(equalTo: lblPrecip.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            lblWind.leadingAnchor.constraint(equalTo: lblPrecip.leadingAnchor),
            lblWind.trailingAnchor.constraint(equalTo: lblPrecip.trailingAnchor, constant: -10),
            lblWind.topAnchor.constraint(equalTo: lblHum.bottomAnchor, constant: 10)
        ])
    }

}

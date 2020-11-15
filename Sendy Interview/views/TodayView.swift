//
//  TodayView.swift
//  Sendy Interview
//
//  Created by Boaz James on 14/11/2020.
//  Copyright © 2020 Boaz James. All rights reserved.
//

import UIKit

class TodayView: UIView {
    
    var lblToday: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Futura-Bold", size: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Today"
        return lbl
    }()
    
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
        lbl.text = "_"
        return lbl
    }()
    
    var lblHum: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Futura", size: 17)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Humidity: _"
        return lbl
    }()
    
    var lblDsc: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Futura", size: 17)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "_"
        lbl.textColor = .gray
        return lbl
    }()
    
    var lblWind: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Futura", size: 17)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Wind: _"
        return lbl
    }()
    
    var cardView: CardView = {
        let view = CardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.cornerRadius = 5
        view.backgroundColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addSubview(cardView)
        cardView.pinToView(parentView: self, constant: 10)
        cardView.addSubview(lblToday)
        cardView.addSubview(imgView)
        cardView.addSubview(lblTemp)
        cardView.addSubview(lblHum)
        cardView.addSubview(lblDsc)
        cardView.addSubview(lblWind)
        NSLayoutConstraint.activate([
            lblToday.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            lblToday.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            imgView.heightAnchor.constraint(equalToConstant: 80),
            imgView.widthAnchor.constraint(equalToConstant: 80),
            imgView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            imgView.topAnchor.constraint(equalTo: lblToday.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            lblTemp.leadingAnchor.constraint(equalTo: self.imgView.trailingAnchor, constant: 10),
            lblTemp.topAnchor.constraint(equalTo: lblToday.bottomAnchor, constant: 10),
            lblTemp.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            lblHum.leadingAnchor.constraint(equalTo: lblTemp.trailingAnchor, constant: 10),
            lblHum.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -10),
            lblHum.topAnchor.constraint(equalTo: lblTemp.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            lblWind.leadingAnchor.constraint(equalTo: lblHum.leadingAnchor),
            lblWind.trailingAnchor.constraint(equalTo: lblHum.trailingAnchor, constant: -10),
            lblWind.topAnchor.constraint(equalTo: lblHum.bottomAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            lblDsc.leadingAnchor.constraint(equalTo: lblHum.leadingAnchor),
            lblDsc.trailingAnchor.constraint(equalTo: lblHum.trailingAnchor, constant: -10),
            lblDsc.topAnchor.constraint(equalTo: lblWind.bottomAnchor, constant: 10),
            lblDsc.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -10)
        ])
    }

}

//
//  DayCell.swift
//  Sendy Interview
//
//  Created by Boaz James on 14/11/2020.
//  Copyright © 2020 Boaz James. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {
    
    var cardView: CardView = {
        let view = CardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.cornerRadius = 5
        view.backgroundColor = .white
        return view
    }()
    
    var label: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Futura", size: 17)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Sat, Nov 14"
        return lbl
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
        cardView.pinToView(parentView: self, constant: 0)
        cardView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: cardView.centerXAnchor)
        ])
    }
}

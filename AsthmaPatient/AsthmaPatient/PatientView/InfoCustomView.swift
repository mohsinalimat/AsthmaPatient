//
//  InfoView.swift
//  AsthmaPatient
//
//  Created by Glotov Michael on 03/03/2019.
//  Copyright © 2019 Glotov Michael. All rights reserved.
//

import Foundation
import UIKit
import Reusable

class InfoCustomView: UIView, NibLoadable {
    var dateLabel: UILabel
    var descLabel: UITextView
    var medcineLabel: UITextView
    var stackView: UIStackView
    override init(frame: CGRect) {
        stackView = UIStackView(frame: CGRect(x: 0.0, y: 0.0, width: frame.width, height: 400.0))
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        dateLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: frame.width, height: 30.0))
        
        descLabel = UITextView(frame: CGRect(x: 0.0, y: 30.0, width: frame.width, height: 300.0))
        descLabel.isScrollEnabled = false
        
        medcineLabel = UITextView(frame: CGRect(x: 0.0, y: 330.0, width: frame.width, height: 300.0))
        medcineLabel.isScrollEnabled = false
        super.init(frame: frame)
        
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        stackView.addSubview(dateLabel)
        stackView.addSubview(descLabel)
        descLabel.snp.makeConstraints { (make) in
            make.width.equalTo(frame.width - 40.0)
        }
        stackView.addSubview(medcineLabel)
        medcineLabel.snp.makeConstraints { (make) in
            make.width.equalTo(frame.width - 40.0)
        }
        layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

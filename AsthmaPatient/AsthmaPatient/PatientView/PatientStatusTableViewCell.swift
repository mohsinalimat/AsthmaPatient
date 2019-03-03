//
//  PatientStatusTableViewCell.swift
//  AsthmaPatient
//
//  Created by Glotov Michael on 23/02/2019.
//  Copyright © 2019 Glotov Michael. All rights reserved.
//

import UIKit
import Reusable
import SnapKit

class PatientStatusTableViewCell: UITableViewCell, Reusable {
    
    private lazy var infoView = InfoCustomView(frame: contentView.frame)
    private lazy var stateView = UIView(frame: contentView.frame)
    private lazy var stackView = UIStackView(frame: contentView.frame)
    
    func setupView(_ sizeClass: UIUserInterfaceSizeClass, state: PatientStatus) {
//        contentView.addSubview(stackView)
        infoView.dateLabel.text = state.createdDate
        infoView.descLabel.text = state.description
        contentView.addSubview(infoView)
        infoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
//        stackView.distribution = .fillProportionally
//        stackView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
        
        switch sizeClass{
        case .compact:
//            stackView.axis = .vertical
//            stackView.insertSubview(infoView, at: 0)
//            stackView.insertSubview(stateView, at: 1)
            break
        case .regular:
            stackView.axis = .horizontal
            break
        case .unspecified:
            break
        }
    }
}

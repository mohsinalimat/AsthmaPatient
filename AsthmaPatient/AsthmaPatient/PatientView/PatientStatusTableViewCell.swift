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
    
    private lazy var infoView = InfoCustomView.loadFromNib()
    private lazy var stateView = ParametersCustomView.loadFromNib()
    
    private lazy var stackView = UIStackView(frame: contentView.frame)
    
    func setupView(_ sizeClass: UIUserInterfaceSizeClass, state: PatientStatus) {
        addSubview(infoView)
        addSubview(stateView)
        
        stateView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(6.0)
        }
        
        infoView.snp.makeConstraints { (make) in
            make.top.equalTo(stateView.snp.bottom).offset(18.0)
            make.left.right.equalToSuperview().inset(6.0)
            make.bottom.equalToSuperview()
        }
        
        infoView.dateLabel.text = "Дата записи: " + state.createdDate!
        infoView.descLabel.text = "Описание: " + state.description
        infoView.medcinesLabel.text = state.medcinesString ?? ""
        
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        
        guard let spO2 = state.parameters?.spO2, let pef = state.parameters?.pef else {
            return
        }
        
        stateView.opf2ValueLabel.text = nf.string(from: NSNumber(value: spO2))
        stateView.pefValueLabel.text = nf.string(from: NSNumber(value: pef))
        stateView.hasCoughSwitch.isOn = state.parameters?.isWheezing ?? false
        stateView.hospitalizedSwitch.isOn = state.parameters?.isHospitalized ?? false
//
//        switch sizeClass{
//        case .compact:
//            break
//        case .regular:
//            stackView.axis = .horizontal
//            break
//        case .unspecified:
//            break
//        }
    }
}

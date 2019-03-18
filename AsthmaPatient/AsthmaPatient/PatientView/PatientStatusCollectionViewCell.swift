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

class PatientStatusCollectionViewCell: UICollectionViewCell, Reusable {
    
    private lazy var infoView = InfoCustomView.loadFromNib()
    private lazy var stateView = ParametersCustomView.loadFromNib()
    
    private lazy var stackView = UIStackView(frame: frame)
    
    func setupView(_ sizeClass: UIUserInterfaceSizeClass, state: PatientStatus) {
        addSubview(infoView)
        addSubview(stateView)
        backgroundColor = UIColor.white
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateStr = dateFormatter.string(from: state.formatedDate)
        let dateCaption = "Дата записи: "
        
        infoView.dateLabel.text = dateCaption + dateStr
        infoView.descLabel.text = "Описание: " + state.description
        if let medStr = state.medcinesString {
            infoView.medcinesLabel.text = "Лекарства: " + medStr
        }
        
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        
        guard let spO2 = state.parameters?.spO2, let pef = state.parameters?.pef else {
            return
        }
        
        stateView.opf2ValueLabel.text = nf.string(from: NSNumber(value: spO2))
        stateView.pefValueLabel.text = nf.string(from: NSNumber(value: pef))
        stateView.hasCoughSwitch.isOn = state.parameters?.isWheezing ?? false
        stateView.hospitalizedSwitch.isOn = state.parameters?.isHospitalized ?? false
        
        switch sizeClass{
        case .compact:
            stateView.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.left.right.equalToSuperview().inset(6.0)
            }
            
            infoView.snp.makeConstraints { (make) in
                make.top.equalTo(stateView.snp.bottom).offset(6.0)
                make.left.right.equalToSuperview().inset(6.0)
                make.bottom.equalToSuperview()
            }
            break
        case .regular:
            stateView.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.bottom.lessThanOrEqualToSuperview()
                make.height.equalTo(240)
                make.right.equalToSuperview().inset(6.0)
                make.width.equalToSuperview().dividedBy(2)
            }
            
            infoView.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalToSuperview().inset(6.0)
                make.width.equalToSuperview().dividedBy(2)
            }
            break
        case .unspecified:
            break
        }
        layoutIfNeeded()
    }
}

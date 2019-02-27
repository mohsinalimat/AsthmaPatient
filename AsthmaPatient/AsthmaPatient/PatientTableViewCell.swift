//
//  PatientTableViewCell.swift
//  AsthmaPatient
//
//  Created by Glotov Michael on 23/02/2019.
//  Copyright © 2019 Glotov Michael. All rights reserved.
//

import UIKit
import Reusable

class PatientTableViewCell: UITableViewCell, Reusable {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateOfBirthLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    
    private var patient: Patient!
    
    func setup(with patient: Patient) {
        nameLabel.text = "\(patient.lastName) \(patient.firstName)"
        if let middleName = patient.middleName {
            nameLabel.text?.append(" \(middleName)")
        }
        
        dateOfBirthLabel.text = patient.dateOfBirth
//        sexLabel.text = patient.
    }
}

//
//  Patient.swift
//  AsthmaPatient
//
//  Created by Glotov Michael on 20/02/2019.
//  Copyright © 2019 Glotov Michael. All rights reserved.
//

import Foundation

struct Patient: Codable {
    var patientId: Int
    var firstName: String
    var lastName: String
    var middleName: String?
    var dateOfBirth: String?
    var symptom: Symptom?
    var medicines: [Medicine]?
    var notes: String?
}

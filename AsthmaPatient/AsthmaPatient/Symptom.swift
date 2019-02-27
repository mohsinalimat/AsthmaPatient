//
//  Symptom.swift
//  AsthmaPatient
//
//  Created by Glotov Michael on 20/02/2019.
//  Copyright © 2019 Glotov Michael. All rights reserved.
//

import Foundation

struct Symptom: Codable {
    var isWheezing: Bool
    var PEF: Float
    var SpO2: Float
    var noChange: Bool
    var shouldBeHospitalized: Bool
}

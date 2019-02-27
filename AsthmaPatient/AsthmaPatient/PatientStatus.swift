//
//  PatientState.swift
//  AsthmaPatient
//
//  Created by Glotov Michael on 23/02/2019.
//  Copyright © 2019 Glotov Michael. All rights reserved.
//

import Foundation

struct PatientStatus: Codable {
    var statusId: Int
    var description: String
    var medcines: [Medicine]?
    var createdDate: String?
    var parameters: Parameter?
    
    struct Parameter: Codable {
        var isWheezing: Bool
        var isHospitalized: Bool
        var pef: Float
        var spO2: Float
    }
}

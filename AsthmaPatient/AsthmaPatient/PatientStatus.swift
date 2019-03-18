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
    var medicines: [Medicine]?
    var createdDate: String?
    var parameters: Parameter?
    
    struct Parameter: Codable {
        var isWheezing: Bool
        var isHospitalized: Bool
        var pef: Float
        var spO2: Float
    }
    
    var medcinesString: String? {
        get {
            if medicines != nil {
                var result = ""
                for medcine in medicines! {
                    result.append(medcine.name + medcine.description + "\n")
                }
                return result
            }
            return nil
        }
    }
    
    var formatedDate: Date {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"
            return dateFormatter.date(from: createdDate!)!
        }
    }
}

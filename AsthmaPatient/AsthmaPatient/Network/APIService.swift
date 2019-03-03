//
//  APIService.swift
//  AsthmaPatient
//
//  Created by Glotov Michael on 20/02/2019.
//  Copyright © 2019 Glotov Michael. All rights reserved.
//

import Foundation

class APIService {
    
    private let host = "http://77.234.215.138:49002/"
    
    private enum path: String {
        case patients = "/patients"
        case hisotry = "/patients/history"
    }
    
    func getPatients(_ completionHandler: @escaping ([Patient]?) -> (Void)) {
        let urlSession = URLSession.shared
        guard let requestUrl = URL(string: "\(host)\(path.patients)") else {
            return
        }
        
        let request = URLRequest(url: requestUrl)
        let urlTask = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            var jsonData: Any?
            do {
                jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            } catch {
                print("Failed to parse JSON with error \(error)")
                completionHandler(nil)
            }
            
            guard let jsonDict = jsonData as? [String : Any],
                  let patientsData = jsonDict["data"] as? [String : Any],
                  let patients = patientsData["patients"] as? [String : Any],
                  let listOfPatients = patients["list"] as? [[String : Any]] else {
                completionHandler(nil)
                return
            }
            
            do {
                let patientsData = try JSONSerialization.data(withJSONObject: listOfPatients,
                                                              options: .prettyPrinted)
                
                let patients = try JSONDecoder().decode([Patient].self, from: patientsData)
                completionHandler(patients)
            } catch {
                print("Failed to to decode model with error \(error)")
                completionHandler(nil)
            }
        }
        urlTask.resume()
    }
    
    func getPatientsHistory(id: Int, completionHandler: @escaping ([PatientStatus]?) -> (Void)) {
        let urlSession = URLSession.shared
        guard let requestUrl = URL(string: "\(host)patients/\(id)/history") else {
            return
        }
        
        let request = URLRequest(url: requestUrl)
        let urlTask = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            var jsonData: Any?
            do {
                jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            } catch {
                print("Failed to parse JSON with error \(error)")
                completionHandler(nil)
            }
            
            guard let jsonDict = jsonData as? [String : Any],
                let patientsData = jsonDict["data"] as? [String : Any],
                let patients = patientsData["history"] as? [String : Any],
                let listOfPatients = patients["statuses"] as? [String : Any],
                let list = listOfPatients["list"] as? [[String : Any]] else {
                    completionHandler(nil)
                    return
            }
            
            do {
                let patientsData = try JSONSerialization.data(withJSONObject: list,
                                                              options: .prettyPrinted)
                
                let statuses = try JSONDecoder().decode([PatientStatus].self, from: patientsData)
                completionHandler(statuses)
            } catch {
                print("Failed to to decode model with error \(error)")
                completionHandler(nil)
            }
        }
        urlTask.resume()
    }
}




//
//  APIPatients.swift
//  AsthmaPatient
//
//  Created by Glotov Michael on 27/02/2019.
//  Copyright © 2019 Glotov Michael. All rights reserved.
//

import Foundation
import PromiseKit

class APIPatients {
    
    // MARK: Promises
    
    static func getPatients(completionHandler: @escaping ([Patient]?) -> (Void)) {
        let endpoint = Endpoint(env: Environment.main(), path: "/patients", httpMehod: .get, timeout: TimeInterval(10))
        let request = APIRequest(with: endpoint, on: endpoint.env)
        Dispatcher.shared.dispatchPromise(request: request)
            .done { (json) in
                guard let patientsData = json["data"] as? [String : Any],
                      let patients = patientsData["patients"] as? [String : Any],
                      let listOfPatients = patients["list"] as? [[String : Any]] else {
                    completionHandler(nil)
                    return
                }
                do {
                    let patientsData = try JSONSerialization.data(withJSONObject: listOfPatients, options: .prettyPrinted)
                    let patients = try JSONDecoder().decode([Patient].self, from: patientsData)
                    completionHandler(patients)
                } catch {
                    completionHandler(nil)
                }
            }.catch { (error) in
                completionHandler(nil)
            }
    }
    
    static func createPatient(data: Data, completionHandler: @escaping (Bool) -> (Void)) {
        let endpoint = Endpoint(env: Environment.main(), path: "/patients", httpMehod: .post, body: data, timeout: TimeInterval(10))
        let request = APIRequest(with: endpoint, on: endpoint.env)
        Dispatcher.shared.dispatchPromise(request: request)
            .done { (json) in
                completionHandler(true)
            }.catch { (error) in
                completionHandler(false)
            }
    }
    
    static func getPatientsHistory(patientID: Int, completionHandler: @escaping ([PatientStatus]?) -> (Void)) {
        let endpoint = Endpoint(env: Environment.main(), path: "/patients/\(patientID)/history", httpMehod: .get, timeout: TimeInterval(10))
        let request = APIRequest(with: endpoint, on: endpoint.env)
        Dispatcher.shared.dispatchPromise(request: request)
            .done { (json) in
                guard let patientsData = json["data"] as? [String : Any],
                      let patients = patientsData["history"] as? [String : Any],
                      let listOfPatients = patients["statuses"] as? [String : Any],
                      let list = listOfPatients["list"] as? [[String : Any]] else {
                        completionHandler(nil)
                        return
                }
                
                do {
                    let patientsData = try JSONSerialization.data(withJSONObject: list, options: .prettyPrinted)
                    let statuses = try JSONDecoder().decode([PatientStatus].self, from: patientsData)
                    completionHandler(statuses)
                } catch {
                    completionHandler(nil)
                }
            }.catch { (error) in
                print(error)
                completionHandler(nil)
        }
    }
    
    static func createNewStatus(patientID: Int, data: Data, completionHandler: @escaping (Bool) -> (Void)) {
        let endpoint = Endpoint(env: Environment.main(), path: "/patients/\(patientID)/status", httpMehod: .post, body: data, timeout: TimeInterval(10))
        let request = APIRequest(with: endpoint, on: endpoint.env)
        Dispatcher.shared.dispatchPromise(request: request)
            .done { (json) in
                completionHandler(true)
            }.catch { (error) in
                completionHandler(false)
        }
    }
}

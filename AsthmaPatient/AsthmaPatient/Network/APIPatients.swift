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
    static func getAllPatients() {
        let endpoint = Endpoint(env: Environment.main(),
                                path: "/patients",
                                httpHeaders: nil,
                                query: nil,
                                body: nil,
                                timeout: TimeInterval(10))
        let request = APIRequest(with: endpoint, on: endpoint.env)
        Dispatcher.shared.dispatch(request: request) { (result) in
            print(result.value)
        }
    }
}

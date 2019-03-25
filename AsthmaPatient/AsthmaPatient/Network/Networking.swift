//
//  Networking.swift
//  AsthmaPatient
//
//  Created by Glotov Michael on 27/02/2019.
//  Copyright © 2019 Glotov Michael. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class Environment {
    
    var httpProtocol: String
    var host: String
    var fullHost: String { return httpProtocol + host }
    
    init(httpProtocol: String, host: String) {
        self.httpProtocol = httpProtocol
        self.host = host
    }
    
    static func main() -> Environment {
        return Environment(httpProtocol: "http://", host: "77.234.215.138:49002")
    }
}

class Endpoint {
    
    //MARK: Request parameters
    var env: Environment
    var path: String
    var httpMehod: HTTPMethod
    var httpHeaders: HTTPHeaders?
    
    //MARK: Query and Body
    var query: Parameters?
    var body: Data?
    
    //MARK: Response
    var contentType: String
    let timeout: TimeInterval
    let statusCodes: [Int]
    
    //MARK: Serialization
    //var serializaer
    
    init(env: Environment, path: String, httpMehod: HTTPMethod = .get, httpHeaders: HTTPHeaders? = ["Content-Type" : "application/json"], query: Parameters? = nil,
         body: Data? = nil, contentType: String = "application/json", timeout: TimeInterval,
         statusCodes:[Int] = Array(200..<300)) {
        self.env = env
        self.path = path
        self.httpMehod = httpMehod
        self.httpHeaders = httpHeaders
        self.query = query
        self.body = body
        self.contentType = contentType
        self.timeout = timeout
        self.statusCodes = statusCodes
    }
}

class APIRequest {
    
    let endpoint: Endpoint
    let env: Environment
    var url: String {
        return env.fullHost + endpoint.path
    }

    init(with endpoint: Endpoint, on env: Environment) {
        self.endpoint = endpoint
        self.env = env
    }
}

extension APIRequest: Alamofire.URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        var request = try URLRequest(url: url, method: endpoint.httpMehod, headers: endpoint.httpHeaders)
        let encoding = URLEncoding(destination: .queryString, arrayEncoding: .noBrackets, boolEncoding: .numeric)
        request = try encoding.encode(request, with: endpoint.query)
        request.httpBody = endpoint.body
        request.timeoutInterval = endpoint.timeout
        return request
    }
}

class Dispatcher {
    static let shared = Dispatcher()
    
    @discardableResult
    func dispatch(request: APIRequest, completion: @escaping (Alamofire.Result<Any>) -> Void) -> Request {
        var afrequest = Alamofire.request(request as Alamofire.URLRequestConvertible)
        afrequest = afrequest.validate(contentType: [request.endpoint.contentType])
        return afrequest
            .validate(statusCode: request.endpoint.statusCodes)
            .responseJSON(completionHandler: { (response) in
                //TODO: add option to handle errors manually
                completion(response.result)
            })
    }
    
    func dispatchPromise(request: APIRequest) -> Promise<[String : Any]> {
        var afrequest = Alamofire.request(request as Alamofire.URLRequestConvertible)
        afrequest = afrequest.validate(contentType: [request.endpoint.contentType])
        return Promise { seal in
            afrequest
                .validate(statusCode: request.endpoint.statusCodes)
                .responseJSON { response in
                    switch response.result {
                    case .success(let json):
                        guard let json = json  as? [String: Any] else {
                            return seal.reject(AFError.responseValidationFailed(reason: .dataFileNil))
                        }
                        seal.fulfill(json)
                    case .failure(let error):
                        seal.reject(error)
                    }
            }
        }
    }
}


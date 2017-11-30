//
//  RealNetworkRequest.swift
//  BNForm
//
//  Created by Darin Williams on 11/25/17.
//  Copyright © 2017 dwilliams. All rights reserved.
//

import Foundation
import Alamofire

class RealNetworkRequest: NetworkRequest {
    
    func request(_ url: URL, method: HTTPMethod, parameters: [String : Any]?, headers: [String : String]?, completion: @escaping (Results<Json>) -> Void) {
        
        Alamofire.request(url,
                          method: method,
                          parameters: parameters,
                          encoding: URLEncoding.default,
                          headers: headers).responseJSON(completionHandler: { (response) in
                            if let value = response.result.value, let result = Json(json: value) {
                                completion(.success(result))
                            } else {
                                completion(.error)
                            }
                          })
    }
}

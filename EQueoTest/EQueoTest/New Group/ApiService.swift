//
//  ApiService.swift
//  EQueoTest
//
//  Created by Alexander Filippov on 8/4/19.
//  Copyright © 2019 Alexander Filippov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreData

class ApiService {
    
    static let shared = ApiService()
    
    public func getPhoto(completion: ((Swift.Result<[Photo], Error>) -> Void)? = nil) {
        let baseUrl = "https://api.unsplash.com"
        let path = "/search/photos"
        
        let params: Parameters = [
            "client_id": "df323d9b6f1542e39224aed966bd4baf6c24ec14248f09b403a7dea55dfac24d",
            "query": "flower",
            "page": 1,
            "per_page": 5,
            "auto": "format",
        ]
        
        Alamofire.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let photos = json.arrayValue.map { Photo($0) }
                completion?(.success(photos))
                
            case .failure(let error):
                completion?(.failure(error))
                print(error)
            }
        }
    }
}

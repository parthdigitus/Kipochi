//
//  APIClient.swift
//  Ucherr
//
//  Created by macbook on 3/30/19.
//  Copyright © 2019 Digitus. All rights reserved.
//

import Foundation
import Alamofire
import EVReflection


func callDataResponse<T:EVObject>(urlPath:String,method:HTTPMethod,param:Parameters?,headers:HTTPHeaders?,modal:T.Type,completion: @escaping ((T) -> ()),failure:@escaping ((_ httpresponse: HTTPURLResponse?,_ errorMessage: String) -> ()))  {

    Alamofire.request(baseURL + urlPath,method:method , parameters: param, headers: headers)
        .responseObject { (response: DataResponse<T>) in
            
            switch response.result {
            case .success:
                let responseValue = response.result.value
                completion(responseValue!)
                break
            case .failure(let error):
                failure(response.response, error.localizedDescription)
                break
            }
    }
}

func callDataResponse<T:EVObject>(urlPath:URLS,method:HTTPMethod,param:Parameters?,headers:HTTPHeaders?,modal:T.Type,completion: @escaping ((T) -> ()),failure:@escaping ((_ httpresponse: HTTPURLResponse?,_ errorMessage: String) -> ()))  {
    
    callDataResponse(urlPath: urlPath.rawValue, method: method, param: param, headers: headers, modal: modal, completion: completion, failure: failure)
}


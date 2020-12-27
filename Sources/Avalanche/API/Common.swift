//
//  File.swift
//  
//
//  Created by Daniel Leping on 27/12/2020.
//

import Foundation

import RPC

struct SuccessResponse: Decodable {
    let success: Bool
    
    func toResult<P: Encodable, E: Decodable>() -> Result<Nil, RequestError<P, E>> {
        success ? .success(.nil) : .failure(.custom(description: "Service returned success = false", cause: nil))
    }
}

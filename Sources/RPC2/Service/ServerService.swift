//
//  File.swift
//  
//
//  Created by Daniel Leping on 15/12/2020.
//

import Foundation

public protocol ServerServiceDelegate {
    func request<R: Encodable, E: Encodable & Error>(id: Int, method: String, params: Data, response: Callback<R, E>)
    func notification(method: String, params: Data)
}

public protocol ServerService {
    associatedtype Delegate: ServerServiceDelegate
    
    var delegate: Delegate {get}
}

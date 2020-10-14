//
//  Connection.swift
//  
//
//  Created by Yehor Popovych on 9/5/20.
//

import Foundation

public protocol AvalancheConnectionFactory {
    var baseURL: URL { get set }
    var defaultHeaders: Dictionary<String, String> { get set }
    var responseQueue: DispatchQueue { get set }
    
    init(url: URL, headers: Dictionary<String, String>, responseQueue: DispatchQueue)
    
    func restConnection(for path: String) -> AvalancheRestConnection
    func httpRpcConnection(for path: String) -> AvalancheRpcConnection
    func wsRpcConnection(for path: String) -> AvalancheRpcConnection
}

public enum AvalancheConnectionError: Error {
    case httpError(code: Int, message: String)
    case socketError(error: Error)
    case callError(method: String, params: Any, message: String)
    case encodingError(error: EncodingError)
    case decodingError(error: DecodingError)
}

public typealias AvalancheConnectionCallback<R> = AvalancheResponseCallback<R, AvalancheConnectionError>

public protocol AvalancheRestConnection {
    var url: URL { get }
    var responseQueue: DispatchQueue { get }
    var defaultHeaders: Dictionary<String, String> { get set }
    
    init(url: URL, headers: Dictionary<String, String>, responseQueue: DispatchQueue)
    
    func get<Res: Decodable>(
        _ path: String, headers: Dictionary<String, String>?,
        response: @escaping AvalancheConnectionCallback<Res>
    )
    
    func post<Req: Encodable, Res: Decodable>(
        _ path: String, data: Req?, headers: Dictionary<String, String>?,
        response: @escaping AvalancheConnectionCallback<Res>
    )
    
    // TODO: Add more REST methods when needed
}

public protocol AvalancheRpcConnection {
    var url: URL { get }
    var responseQueue: DispatchQueue { get }
    var defaultHeaders: Dictionary<String, String> { get set }
    
    init(url: URL, headers: Dictionary<String, String>, responseQueue: DispatchQueue)
    
    func call<Params: Encodable, Res: Decodable>(
        method: String, params: Params,
        result: @escaping AvalancheConnectionCallback<Res>
    )
}

public protocol AvalancheJsonRpcConnection: AvalancheRpcConnection {
    var jsonRpcVersion: String { get set }
}

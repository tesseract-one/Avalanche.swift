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
    func wsRpcConnection(for path: String) -> AvalancheSubscribableRpcConnection
}

public enum AvalancheConnectionError: Error {
    case badHttpCode(code: Int, data: Data?)
    case transportError(error: Error)
    case encodingError(error: EncodingError)
    case decodingError(error: DecodingError)
    case unknownError(error: Error?)
}

public enum AvalancheRpcConnectionError<P: Encodable, E: Decodable>: Error {
    case connectionError(error: AvalancheConnectionError)
    case callError(method: String, params: P, error: E)
}

public typealias AvalancheConnectionCallback<R> = AvalancheResponseCallback<R, AvalancheConnectionError>
public typealias AvalancheRpcConnectionCallback<P: Encodable, R: Decodable, E: Decodable> =
    AvalancheResponseCallback<R, AvalancheRpcConnectionError<P, E>>

public protocol AvalancheRestConnection {
    var url: URL { get }
    var responseQueue: DispatchQueue { get }
    var defaultHeaders: Dictionary<String, String> { get }
    
    init(url: URL, headers: Dictionary<String, String>, responseQueue: DispatchQueue)
    
    func get<Res: Decodable>(
        _ path: String, headers: Dictionary<String, String>?, _ type: Res.Type,
        response: @escaping AvalancheConnectionCallback<Res>
    )
    
    func post<Req: Encodable, Res: Decodable>(
        _ path: String, data: Req, headers: Dictionary<String, String>?, _ type: Res.Type,
        response: @escaping AvalancheConnectionCallback<Res>
    )
    
    // TODO: Add more REST methods when needed
}

public protocol AvalancheRpcConnection {
    var url: URL { get }
    var responseQueue: DispatchQueue { get }
    var defaultHeaders: Dictionary<String, String> { get }
    
    init(url: URL, headers: Dictionary<String, String>, responseQueue: DispatchQueue)
    
    func call<Params: Encodable, Res: Decodable, Err: Decodable>(
        method: String, params: Params, _ res: Res.Type,
        response: @escaping AvalancheRpcConnectionCallback<Params, Res, Err>
    )
}

public protocol AvalancheSubscribableRpcConnection: AvalancheRpcConnection {
    func subscribe(listener: @escaping (Data, AvalancheSubscribableRpcConnection) -> Void) -> UInt
    func unsubscribe(id: UInt)
    
    // Method for incoming event parsing.
    func parseInfo<P: Decodable>(from message: Data, _ params: P.Type) throws -> (method: String, params: P)
}

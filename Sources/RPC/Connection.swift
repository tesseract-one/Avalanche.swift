//
//  Connection.swift
//  
//
//  Created by Yehor Popovych on 9/5/20.
//

import Foundation

public typealias Callback<R, E: Error> = (Result<R, E>) -> ()

public protocol AvalancheConnectionFactory {
    var baseURL: URL { get set }
    var defaultHeaders: Dictionary<String, String> { get set }
    var responseQueue: DispatchQueue { get set }
    
    func restConnection(for path: String) -> AvalancheRestConnection
    func httpRpcConnection(for path: String) -> AvalancheRpcConnection
    func wsRpcConnection(for path: String) -> AvalancheSubscribableRpcConnection
}

public enum RequestError: Error {
    case http(code: Int, message: Data)
    case network(error: Error)
    case encoding(error: EncodingError)
    case decoding(error: DecodingError)
    case unknown(error: Error?)
}

public enum RpcError<P: Encodable, E: Decodable>: Error {
    case request(error: RequestError)
    case call(method: String, params: P, error: E)
}

public typealias AvalancheConnectionCallback<R> = Callback<R, RequestError>
public typealias AvalancheRpcConnectionCallback<P: Encodable, R, E: Decodable> =
    Callback<R, RpcError<P, E>>

public protocol AvalancheRestConnection {
    var url: URL { get }
    var responseQueue: DispatchQueue { get }
    var defaultHeaders: Dictionary<String, String> { get }
    
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

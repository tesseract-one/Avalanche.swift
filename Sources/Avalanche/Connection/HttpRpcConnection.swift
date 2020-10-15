//
//  HttpRpcConnection.swift
//  
//
//  Created by Yehor Popovych on 10/15/20.
//

import Foundation

public class AvalancheDefaultHttpRpcConnection: AvalancheRpcConnection {
    private var http: AvalancheRestConnection
    
    public var url: URL { http.url }
    public var responseQueue: DispatchQueue { http.responseQueue }
    public var defaultHeaders: Dictionary<String, String> { http.defaultHeaders }
    
    public init(
        url: URL, headers: Dictionary<String, String>,
        session: URLSession, responseQueue: DispatchQueue,
        encoder: JSONEncoder, decoder: JSONDecoder
    ) {
        http = AvalancheDefaultRestConnection(
            url: url, headers: headers, session: session,
            responseQueue: responseQueue,
            encoder: encoder, decoder: decoder
        )
    }
    
    public func call<Params: Encodable, Res: Decodable, Err: Decodable>(
        method: String, params: Params, _ res: Res.Type,
        response: @escaping AvalancheRpcConnectionCallback<Params, Res, Err>
    ) {
        let call = AvalancheRpcRequest(jsonrpc: "2.0", id: 1, method: method, params: params)
        http.post("", data: call, headers: nil, AvalancheRpcResponse<Res, Err>.self) { res in
            let mapped: Result<Res, AvalancheRpcConnectionError<Params, Err>> = res
                .mapError { .connectionError(error: $0) }
                .flatMap {
                    $0.error != nil
                        ? .failure(.callError(method: method, params: params, error: $0.error!))
                        : .success($0.result!)
                }
            response(mapped)
        }
    }
}

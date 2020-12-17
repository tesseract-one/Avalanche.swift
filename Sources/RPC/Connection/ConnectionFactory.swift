//
//  ConnectionFactory.swift
//  
//
//  Created by Yehor Popovych on 10/15/20.
//

import Foundation

public class AvalancheDefaultConnectionFactory: AvalancheConnectionFactory {
    public var baseURL: URL
    public var defaultHeaders: Dictionary<String, String>
    public var responseQueue: DispatchQueue
    public var decoder: RpcMessageDecoder
    public var encoder: RpcMessageEncoder
    public var session: URLSession
    
    public init(
        url: URL, headers: Dictionary<String, String> = [:],
        responseQueue: DispatchQueue = .main,
        session: URLSession = .shared,
        encoder: RpcMessageEncoder = JSONEncoder.rpcDefault,
        decoder: RpcMessageDecoder = JSONDecoder.rpcDefault
    ) {
        self.session = session
        self.baseURL = url
        self.defaultHeaders = headers
        self.responseQueue = responseQueue
        self.decoder = decoder
        self.encoder = encoder
    }
    
    public func restConnection(for path: String) -> AvalancheRestConnection {
        let url = URL(string: path, relativeTo: baseURL)!
        return AvalancheDefaultRestConnection(
            url: url,
            headers: defaultHeaders, session: session,
            responseQueue: responseQueue,
            encoder: encoder, decoder: decoder
        )
    }
    
    public func httpRpcConnection(for path: String) -> AvalancheRpcConnection {
        let url = URL(string: path, relativeTo: baseURL)!
        return AvalancheDefaultHttpRpcConnection(
            url: url,
            headers: defaultHeaders, session: session,
            responseQueue: responseQueue,
            encoder: encoder, decoder: decoder
        )
    }
    
    public func wsRpcConnection(for path: String) -> AvalancheSubscribableRpcConnection {
        fatalError("Not implemented yet!")
    }
}

//
//  RpcMessages.swift
//  
//
//  Created by Yehor Popovych on 10/15/20.
//

import Foundation

public struct AvalancheRpcRequest<P: Encodable>: Encodable {
    public let jsonrpc: String
    public let id: UInt32
    public let method: String
    public let params: P
}

public struct AvalancheRpcResponse<R: Decodable, E: Decodable>: Decodable {
    public let jsonrpc: String
    public let id: UInt32
    public let result: R?
    public let error: E?
}

public struct AvalancheRpcEvent<M: Decodable>: Decodable {
    public let jsonrpc: String
    public let method: String
    public let params: M
}

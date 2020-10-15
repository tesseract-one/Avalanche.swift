//
//  RPCMessages.swift
//  
//
//  Created by Yehor Popovych on 10/15/20.
//

import Foundation

public struct AvalancheRPCRequest<P: Encodable>: Encodable {
    let jsonrpc: String
    let id: UInt32
    let method: String
    let params: P
}

public struct AvalancheRPCResponse<R: Decodable, E: Decodable>: Decodable {
    let jsonrpc: String
    let id: UInt32
    let result: R?
    let error: E?
}

public struct AvalancheRPCEvent<M: Decodable>: Decodable {
    let jsonrpc: String
    let method: String
    let params: M
}

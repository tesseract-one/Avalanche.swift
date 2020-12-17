//
//  File.swift
//  
//
//  Created by Daniel Leping on 14/12/2020.
//

import Foundation

public enum ServiceError: Swift.Error {
    case connection(cause: ConnectionError)
    case codec(cause: CodecError)
    case envelope(header: EnvelopeHeader, description: String)
    case unregisteredResponse(id: RPCID, body: Data)
}

public protocol ServiceProtocol {
    associatedtype Connection
    
    var queue: DispatchQueue {get}
    var connection: Self.Connection {get}
    
    var encoder: ContentEncoder {get}
    var decoder: ContentDecoder {get}
}

public typealias ResponseClosure = (Data)->Void

public class Service<Connection, Delegate>: ServiceProtocol {
    public var queue: DispatchQueue
    public var connection: Connection
    
    public var encoder: ContentEncoder
    public var decoder: ContentDecoder
    
    public var delegate: Delegate
    
    var responseClosures = Dictionary<RPCID, ResponseClosure>()
    
    init(queue:DispatchQueue, connection: Connection, encoder: ContentEncoder, decoder:ContentDecoder, delegate: Delegate) {
        self.queue = queue
        self.connection = connection
        self.encoder = encoder
        self.delegate = delegate
        self.decoder = decoder
    }
}

extension Service: ClientService where Connection: ClientConnection {
}

extension Service: ServerService where Connection: ServerConnection, Delegate: ServerServiceDelegate {
}

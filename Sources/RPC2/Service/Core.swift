//
//  File.swift
//  
//
//  Created by Daniel Leping on 14/12/2020.
//

import Foundation

public protocol ServiceCoreProtocol {
    associatedtype Connection
    associatedtype Delegate
    
    var queue: DispatchQueue {get}
    var connection: Self.Connection {get}
    
    var encoder: ContentEncoder {get}
    var decoder: ContentDecoder {get}
    
    var delegate: Delegate? {get set}
    
}

public typealias ResponseClosure = (Data)->Void

public class ServiceCore<Connection, Delegate>: ServiceCoreProtocol {
    public var queue: DispatchQueue
    public var connection: Connection
    
    public var encoder: ContentEncoder
    public var decoder: ContentDecoder
    
    public var delegate: Delegate?
    
    var responseClosures = Dictionary<RPCID, ResponseClosure>()
    
    init(connection: Connection, queue:DispatchQueue, encoder: ContentEncoder, decoder:ContentDecoder) {
        self.connection = connection
        
        self.queue = queue
        
        self.encoder = encoder
        self.decoder = decoder
        
        self.delegate = nil
    }
}

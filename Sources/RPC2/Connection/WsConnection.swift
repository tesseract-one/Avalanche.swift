//
//  File.swift
//  
//
//  Created by Daniel Leping on 15/12/2020.
//

import Foundation

public class WsConnection: PersistentConnection {
    private let queue: DispatchQueue
    
    public var sink: ConnectionCallback
    
    init(url: URL, queue: DispatchQueue, sink: @escaping ConnectionCallback) {
        self.queue = queue
        self.sink = sink
    }
    
    private func flush(result: Result<Data?, ConnectionError>) {
        let sink = self.sink
        queue.async {
            sink(result)
        }
    }
    
    private func flush(data: Data?) {
        flush(result: .success(data))
    }
    
    private func flush(error: ConnectionError) {
        flush(result: .failure(error))
    }
    
    public func send(data: Data) {
        flush(data: Data.init(base64Encoded: "ewoJImpzb25ycGMiOiAiMi4wIiwKCSJyZXN1bHQiOiB7CgkJIm1lc3NhZ2UiOiAic21va2luZyBraWxscyIKCX0sCgkiaWQiOiAyCn0="))
    }
}

///Factory

public struct WsConnectionFactory : PersistentConnectionFactory {
    public typealias Connection = WsConnection
    
    public let url: URL
    
    public func connection(queue: DispatchQueue, sink: @escaping ConnectionCallback) -> Connection {
        WsConnection(url: url, queue: queue, sink: sink)
    }
}

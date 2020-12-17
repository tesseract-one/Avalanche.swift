//
//  File.swift
//  
//
//  Created by Daniel Leping on 16/12/2020.
//

import Foundation

public protocol ConnectionFactory {
    associatedtype Connection
}

public struct ConnectionFactoryProvider<Factory: ConnectionFactory> {
    public let factory: Factory
}

extension ConnectionFactoryProvider: ConnectionFactory {
    public typealias Connection = Factory.Connection
}

///Single Shot Connection

public protocol SingleShotConnectionFactory: ConnectionFactory {
    func create(queue: DispatchQueue) -> Connection
}

extension ConnectionFactoryProvider: SingleShotConnectionFactory where Factory: SingleShotConnectionFactory {
    public func create(queue: DispatchQueue) -> Factory.Connection {
        factory.create(queue: queue)
    }
}

///Persistent Connection

public protocol PersistentConnectionFactory: ConnectionFactory {
    func create(queue: DispatchQueue, sink: @escaping ConnectionCallback) -> Connection
}

extension ConnectionFactoryProvider: PersistentConnectionFactory where Factory: PersistentConnectionFactory {
    public func create(queue: DispatchQueue, sink: @escaping ConnectionCallback) -> Factory.Connection {
        factory.create(queue: queue, sink: sink)
    }
}

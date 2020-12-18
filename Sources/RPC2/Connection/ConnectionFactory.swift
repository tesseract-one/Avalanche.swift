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
    func create(queue: DispatchQueue, headers: Dictionary<String, String>) -> Connection
}

extension ConnectionFactoryProvider: SingleShotConnectionFactory where Factory: SingleShotConnectionFactory {
    public func create(queue: DispatchQueue, headers: Dictionary<String, String>) -> Factory.Connection {
        factory.create(queue: queue, headers: headers)
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

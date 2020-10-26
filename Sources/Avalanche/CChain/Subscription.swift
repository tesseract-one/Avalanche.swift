//
//  Subscription.swift
//  
//
//  Created by Yehor Popovych on 10/15/20.
//

import Foundation

public class CChainSubscription<Params: Encodable, Message: Decodable> {
    private struct SData: Decodable {
        let result: Message
    }
    
    public let id: String
    private var listeners: Dictionary<UInt, ((Result<Message, Error>) -> Void)>
    private var lasListenerId: UInt
    private let lock: NSLock
    private weak var api: AvalancheCChainApi?
    
    public init(id: String, api: AvalancheCChainApi) {
        self.id = id
        self.listeners = [:]
        self.lock = NSLock()
        self.api = api
        self.lasListenerId = 0
    }
    
    public func on(listener: @escaping (Result<Message, Error>) -> Void) -> UInt {
        lock.lock()
        defer { lock.unlock() }
        lasListenerId += 1
        listeners[lasListenerId] = listener
        return lasListenerId
    }
    
    public func off(id: UInt) {
        lock.lock()
        defer { lock.unlock() }
        listeners.removeValue(forKey: id)
    }
    
    public func unsubscribe(cb: @escaping AvalancheRpcConnectionCallback<String, Bool, CChainError>) {
        api?.eth_unsubscribe(self, result: cb)
    }
    
    public var handler: (Data) -> Void {
        return { data in
            self.lock.lock()
            defer { self.lock.unlock() }
            guard let connection = self.api?.network else { return }
            do {
                let (_, params) = try connection.parseInfo(from: data, SData.self)
                for listener in self.listeners.values {
                    listener(.success(params.result))
                }
            } catch {
                for listener in self.listeners.values {
                    listener(.failure(error))
                }
            }
        }
    }
}

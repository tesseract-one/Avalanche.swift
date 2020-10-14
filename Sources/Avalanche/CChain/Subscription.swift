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
    private var listener: ((Result<Message, Error>) -> Void)?
    
    public init(id: String) {
        self.id = id
        self.listener = nil
    }
    
    public func on(listener: @escaping (Result<Message, Error>) -> Void) {
        self.listener = listener
    }
    
    public func off() {
        self.listener = nil
    }
    
    public var handler: (Data, AvalancheSubscribableRpcConnection) -> Void {
        return { data, connection in
            do {
                let (_, params) = try connection.parseInfo(from: data, SData.self)
                self.listener?(.success(params.result))
            } catch {
                self.listener?(.failure(error))
            }
        }
    }
}

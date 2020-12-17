//
//  File.swift
//  
//
//  Created by Daniel Leping on 14/12/2020.
//

import Foundation

public enum ConnectionError: Error {
    case network(cause: Error)
    case http(code: Int, message: Data?)
    case unknown(cause: Error?)
}

public typealias ConnectionCallback = Callback<Data?, ConnectionError>


///markers

public protocol ClientConnection {
}

public protocol ServerConnection {
}

///connections

public protocol SingleShotConnection : ClientConnection {
    func request(data: Data?, response: @escaping ConnectionCallback)
}

public protocol PersistentConnection : ClientConnection, ServerConnection {
    var sink: ConnectionCallback {get set}
    
    func send(data: Data)
}

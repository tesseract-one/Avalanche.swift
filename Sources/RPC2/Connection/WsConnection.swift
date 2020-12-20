//
//  File.swift
//  
//
//  Created by Daniel Leping on 15/12/2020.
//

import Foundation

import WebSocket
import NIOConcurrencyHelpers

fileprivate extension ConnectableState {
    //have to do it this ugly way to keep original ConnectableState clean
    static let intConnected:Int8 = 0
    static let intDisconnected:Int8 = 1
    static let intConnecting:Int8 = 2
    static let intDisconnecting:Int8 = 3
    
    init(int: Int8) {
        switch int {
        case ConnectableState.intConnected:
            self = .connected; break
        case ConnectableState.intConnecting:
            self = .connecting; break
        case ConnectableState.intDisconnected:
            self = .disconnected; break
        case ConnectableState.intDisconnecting:
            self = .disconnecting; break
        default:
            fatalError("Congrats! You broke it. Change this file back to what it was.")
        }
    }
    
    var int: Int8 {
        switch self {
        case .connected:
            return ConnectableState.intConnected
        case .disconnected:
            return ConnectableState.intDisconnected
        case .connecting:
            return ConnectableState.intConnecting
        case .disconnecting:
            return ConnectableState.intDisconnecting
        }
    }
}

public class WsConnection: PersistentConnection, Connectable {
    private let queue: DispatchQueue
    private let sendq: DispatchQueue
    
    private let url: URL
    private let ws: WebSocket
    
    private var dead: NIOAtomic<Bool>
    private var _connected: NIOAtomic<Int8>
    
    public var sink: ConnectionCallback
    
    init(url: URL, autoconnect: Bool, queue: DispatchQueue, pool: DispatchQueue, sink: @escaping ConnectionCallback) {
        self.dead = .makeAtomic(value: false)
        self._connected = .makeAtomic(value: ConnectableState.disconnected.int)
        
        self.url = url
        self.queue = queue
        self.sink = sink
        
        self.sendq = DispatchQueue(label: "one.tesseract.rpc.send-queue", qos: .userInitiated, attributes: .concurrent, target: pool)
        self.sendq.suspend() //don't change to .initiallyInactive. This is different
        
        self.ws = WebSocket(callbackQueue: queue)
        
        let sendq = self.sendq
        let connected = self._connected
        
        ws.onConnected = { _ in
            connected.store(ConnectableState.connected.int)
            sendq.resume()
        }
        
        ws.onDisconnected = { (_, _) in
            sendq.suspend()
            connected.store(ConnectableState.disconnected.int)
        }
        
        ws.onText = { [weak self] (string, _) in
            self?.flush(string: string)
        }
        
        ws.onData = { [weak self] (data, _) in //make Either<Data, String>
            self?.flush(data: data)
        }
        
        if autoconnect {
            self.connect()
        }
    }
    
    deinit {
        dead.store(true)
        if connected != .disconnected {
            //TODO: this is a correct behaviour and should not be modified as we need to keep the socket alive till we're sure it's disconnected. Though, a bug in WebSocket should be fixed (crash if deinitialized NOT in its own thread).
            //So, why is this message here? Don't change this behaviour even after the bug in WebSocket is fixed.
            var keepWsAlive:WebSocket? = ws
            ws.onDisconnected = { (_, _) in
                if let _ = keepWsAlive {
                    keepWsAlive = nil
                }
            }
            
            if connected != .disconnecting {
                ws.disconnect()
            }
        } else {
            sendq.resume()
            //we resume if we were disconnected. Apple is ponting that if we don't, queues have undefined behaviour
        }
    }
    
    public var connected: ConnectableState {
        ConnectableState(int: _connected.load())
    }
    
    public func connect() {
        if connected == .disconnected || connected == .disconnecting {
            _connected.store(ConnectableState.connecting.int)
            ws.connect(url: url)
        }
    }
    
    public func disconnect() {
        if connected == .connected || connected == .connecting {
            _connected.store(ConnectableState.disconnecting.int)
            ws.disconnect()
        }
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
    
    private func flush(string: String) {
        flush(data: string.data(using: .utf8))
    }
    
    private func flush(error: ConnectionError) {
        flush(result: .failure(error))
    }
    
    public func send(data: Data) {
        let ws = self.ws
        let dead = self.dead
        
        sendq.async { [weak ws] in
            // dead is better that just weak ws, because we can get it earlier and avoid scheduled calls execution when already dead
            if dead.load() {
                return
            }
            
            ws?.send(data) //TODO: ask Yehor to provide error (last check if disconnected to resend on error)
        }
    }
}

///Factory

public struct WsConnectionFactory : PersistentConnectionFactory {
    public typealias Connection = WsConnection
    
    public let url: URL
    public let autoconnect: Bool
    public let pool: DispatchQueue
    
    public func connection(queue: DispatchQueue, sink: @escaping ConnectionCallback) -> Connection {
        WsConnection(url: url, autoconnect: autoconnect, queue: queue, pool: pool, sink: sink)
    }
}

extension ConnectionFactoryProvider where Factory == WsConnectionFactory {
    public static func ws(url: URL, autoconnect:Bool = true, pool: DispatchQueue = .global(qos: .utility)) -> Self {
        return Self(factory: WsConnectionFactory(url: url, autoconnect: autoconnect, pool: pool))
    }
}

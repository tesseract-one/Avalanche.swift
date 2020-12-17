//
//  File.swift
//  
//
//  Created by Daniel Leping on 17/12/2020.
//

import Foundation

public protocol ResponseClosuresRegistry {
    func register(id: RPCID, closure: @escaping ResponseClosure)
    func remove(id: RPCID, result: @escaping (ResponseClosure?)->Void)
}

extension Service: ResponseClosuresRegistry where Connection: PersistentConnection {
    public func register(id: RPCID, closure: @escaping ResponseClosure) {
        queue.async {
            self.responseClosures[id] = closure
        }
    }
    
    public func remove(id: RPCID, result: @escaping (ResponseClosure?)->Void) {
        queue.async {
            result(self.responseClosures.removeValue(forKey: id))
        }
    }
}

extension Service where Connection: PersistentConnection {
    func process(error: ServiceError) {
        //TODO: flush it to a proper disposal
    }
    
    func process(header: EnvelopeHeader, data: Data) {
        switch header.metadata {
        case .malformed:
            process(error: .envelope(header: header, description: "RPC message has to have at least either: 'id' or 'method'"))
            break
        case .unknown(version: let version):
            process(error: .envelope(header: header, description: "Unknown RPC version: " + version))
            break
        case .request(id: let id, method: let method):
            break
        case .response(id: let id):
            self.process(response: data, id: id) { [weak self] in
                self?.process(error: .unregisteredResponse(id: id, body: data))
            }
            break
        case .notification(method: let method):
            break
        }
    }
    
    func process(data: Data) {
        let metadata = decoder.tryDecode(EnvelopeHeader.self, from: data)
        switch metadata {
        case .success(let header):
            process(header: header, data: data)
            break
        case .failure(let codecError):
            process(error: .codec(cause: codecError))
            break
        }
    }
    
    func process(_ result: Result<Data?, ConnectionError>) {
        switch result {
        case .success(let data?):
            process(data: data)
            break
        case .failure(let error):
            process(error: .connection(cause: error))
            break
        default:
            //ignoring empty data. a fluke? certainly not a thing I would want to know about
            break
        }
    }
}

public extension Service where Connection: PersistentConnection {
    convenience init<F: PersistentConnectionFactory>(factory: F, queue: DispatchQueue, encoder: ContentEncoder, decoder:ContentDecoder, delegate: Delegate) where F.Connection == Connection {
        
        var this:WeakRef<Service> = WeakRef(ref: nil)
        
        let conn = factory.create(queue: queue) { res in
            guard let this = this.ref else {
                //we're dead here
                return
            }
            
            this.process(res)
        }
    
        
        self.init(queue: queue, connection: conn, encoder: encoder, decoder: decoder, delegate: delegate)
        //for our sink closure
        this.ref = self
    }
    
    convenience init<CF: PersistentConnectionFactory>(_ cfp: ConnectionFactoryProvider<CF>, queue: DispatchQueue, encoder: ContentEncoder, decoder:ContentDecoder, delegate: Delegate) where CF.Connection == Connection {
        self.init(factory: cfp.factory, queue: queue, encoder: encoder, decoder: decoder, delegate: delegate)
    }
}

public extension Service where Connection: PersistentConnection, Delegate == Void {
    convenience init<F: PersistentConnectionFactory>(factory: F, queue: DispatchQueue, encoder: ContentEncoder, decoder:ContentDecoder) where F.Connection == Connection {
        self.init(factory: factory, queue: queue, encoder: encoder, decoder: decoder, delegate: ())
    }
    
    convenience init<F: PersistentConnectionFactory>(_ cfp: ConnectionFactoryProvider<F>, queue: DispatchQueue, encoder: ContentEncoder, decoder:ContentDecoder) where F.Connection == Connection {
        self.init(cfp, queue: queue, encoder: encoder, decoder: decoder, delegate: ())
    }
}

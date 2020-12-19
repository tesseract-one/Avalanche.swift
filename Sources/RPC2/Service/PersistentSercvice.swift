//
//  File.swift
//  
//
//  Created by Daniel Leping on 17/12/2020.
//

import Foundation

typealias ResponseClosure = (Data)->Void

protocol ResponseClosuresRegistry {
    func register(id: RPCID, closure: @escaping ResponseClosure)
    func remove(id: RPCID, result: @escaping (ResponseClosure?)->Void)
}

extension ServiceCore: ResponseClosuresRegistry where Connection: PersistentConnection {
    func register(id: RPCID, closure: @escaping ResponseClosure) {
        queue.async {
            self.responseClosures[id] = closure
        }
    }
    
    func remove(id: RPCID, result: @escaping (ResponseClosure?)->Void) {
        queue.async {
            result(self.responseClosures.removeValue(forKey: id))
        }
    }
}

extension ServiceCore where Connection: PersistentConnection {
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

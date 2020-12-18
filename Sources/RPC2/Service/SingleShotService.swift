//
//  File.swift
//  
//
//  Created by Daniel Leping on 17/12/2020.
//

import Foundation

public extension Service where Connection: SingleShotConnection, Delegate == Void {
    convenience init<F: SingleShotConnectionFactory>(factory: F, queue: DispatchQueue, encoder: ContentEncoder, decoder:ContentDecoder) where F.Connection == Connection {
        var headers = Dictionary<String, String>()
        
        headers["Content-Type"] = encoder.contentType.rawValue
        headers["Accept"] = decoder.contentType.rawValue
        
        self.init(queue: queue, connection: factory.create(queue: queue, headers: headers), encoder: encoder, decoder: decoder, delegate: ())
    }
    
    convenience init<F: SingleShotConnectionFactory>(_ cfp: ConnectionFactoryProvider<F>, queue: DispatchQueue, encoder: ContentEncoder, decoder:ContentDecoder) where F.Connection == Connection {
        self.init(factory: cfp.factory, queue: queue, encoder: encoder, decoder: decoder)
    }
}

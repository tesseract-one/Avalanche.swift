//
//  File.swift
//  
//
//  Created by Daniel Leping on 17/12/2020.
//

import Foundation

public extension Service where Connection: SingleShotConnection, Delegate == Void {
    convenience init<F: SingleShotConnectionFactory>(factory: F, queue: DispatchQueue, encoder: ContentEncoder, decoder:ContentDecoder) where F.Connection == Connection {
        self.init(queue: queue, connection: factory.create(queue: queue), encoder: encoder, decoder: decoder, delegate: ())
    }
    
    convenience init<F: SingleShotConnectionFactory>(_ cfp: ConnectionFactoryProvider<F>, queue: DispatchQueue, encoder: ContentEncoder, decoder:ContentDecoder) where F.Connection == Connection {
        self.init(factory: cfp.factory, queue: queue, encoder: encoder, decoder: decoder)
    }
}

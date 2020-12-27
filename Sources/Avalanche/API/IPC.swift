//
//  IPC.swift
//  
//
//  Created by Daniel Leping on 27/12/2020.
//

import Foundation
import Serializable
#if !COCOAPODS
import RPC
#endif

public struct AvalancheIPCApiInfo: AvalancheApiInfo {
    public let apiPath: String = "/ext/ipcs"
}

public class AvalancheIPCApi: AvalancheApi {
    public typealias Info = AvalancheIPCApiInfo

    private let service: Client

    public required init(avalanche: AvalancheCore, network: AvalancheNetwork, hrp: String, info: AvalancheIPCApiInfo) {
        let settings = avalanche.settings
        let url = avalanche.url(path: info.apiPath)
            
        self.service = JsonRpc(.http(url: url, session: settings.session, headers: settings.headers), queue: settings.queue, encoder: settings.encoder, decoder: settings.decoder)
    }
    
    public struct IPCRequestParams: Encodable {
        let blockchainID: String
    }
    
    public struct PublishBlockchainResponse: Decodable {
        let consensusURL: String
        let decisionsURL: String
    }
    
    public func publishBlockchain(blockchainID: String, cb: @escaping RequestCallback<IPCRequestParams, PublishBlockchainResponse, SerializableValue>) {
        service.call(
            method: "ipcs.publishBlockchain",
            params: IPCRequestParams(blockchainID: blockchainID),
            PublishBlockchainResponse.self,
            SerializableValue.self,
            response: cb
        )
    }
    
    public func unpublishBlockchain(blockchainID: String, cb: @escaping RequestCallback<IPCRequestParams, Nil, SerializableValue>) {
        service.call(
            method: "ipcs.unpublishBlockchain",
            params: IPCRequestParams(blockchainID: blockchainID),
            SuccessResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.flatMap { $0.toResult() })
        }
    }
}

extension AvalancheCore {
    public var ipc: AvalancheIPCApi {
        try! self.getAPI()
    }
}

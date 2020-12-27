//
//  File.swift
//  
//
//  Created by Daniel Leping on 27/12/2020.
//

import Foundation

import RPC
import Serializable

public struct AvalancheMetricsApiInfo: AvalancheApiInfo {
    public let apiPath: String = "/ext/metrics"
}

public class AvalancheMetricsApi: AvalancheApi {
    public typealias Info = AvalancheMetricsApiInfo
    
    private let connection: SingleShotConnection
    private let decoder: ContentDecoder
    
    public required init(avalanche: AvalancheCore, network: AvalancheNetwork, hrp: String, info: AvalancheMetricsApiInfo) {
        let settings = avalanche.settings
        let url = avalanche.url(path: info.apiPath)
        
        self.connection = HttpConnection(url: url, queue: settings.queue, headers: [:], session: settings.session)
        self.decoder = settings.decoder
    }
    
    public func getMetrics(cb: @escaping RequestCallback<Nil, SerializableValue, SerializableValue>) {
        let decoder = self.decoder
        connection.request(data: nil) { response in
            cb(response.mapError {
                .service(error: .connection(cause: $0))
            }.flatMap { data in
                guard let data = data else {
                    return .failure(RequestError.empty)
                }
                return decoder.tryDecode(SerializableValue.self, from: data).mapError { ce in
                    .service(error: .codec(cause: ce))
                }
            })
        }
    }
}

extension AvalancheCore {
    public var metrics: AvalancheMetricsApi {
        try! self.getAPI()
    }
}

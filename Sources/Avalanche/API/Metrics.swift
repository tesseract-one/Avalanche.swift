//
//  Metrics.swift
//  
//
//  Created by Daniel Leping on 27/12/2020.
//

import Foundation
import Serializable
#if !COCOAPODS
import RPC
#endif

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
    
    public enum MetricsError: Decodable {
        public init(from decoder: Decoder) throws {
            fatalError("conformance only. Should never be called")
        }
        
        case malformed(data: Data, message: String)
    }
    
    public func getMetrics(cb: @escaping RequestCallback<Nil, String, MetricsError>) {
        connection.request(data: nil) { response in
            cb(response.mapError {
                .service(error: .connection(cause: $0))
            }.flatMap { data in
                guard let data = data else {
                    return .failure(RequestError.empty)
                }
                return String(data: data, encoding: .utf8).map {.success($0)} ?? .failure(.custom(description: .decodeError, cause: .malformed(data: data, message: .decodeError)))
            })
        }
    }
}

private extension String {
    static var decodeError: String {
        "Unable to decode Data to String"
    }
}

extension AvalancheCore {
    public var metrics: AvalancheMetricsApi {
        try! self.getAPI()
    }
}

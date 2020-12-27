//
//  File.swift
//  
//
//  Created by Daniel Leping on 27/12/2020.
//

import Foundation

import RPC
import Serializable

public struct AvalancheAuthApiInfo: AvalancheApiInfo {
    public let apiPath: String = "/ext/auth"
}

public class AvalancheAuthApi: AvalancheApi {
    public typealias Info = AvalancheAuthApiInfo

    private let service: Client

    public required init(avalanche: AvalancheCore, network: AvalancheNetwork, hrp: String, info: AvalancheAuthApiInfo) {
        let settings = avalanche.settings
        let url = avalanche.url(path: info.apiPath)
            
        self.service = JsonRpc(.http(url: url, session: settings.session, headers: settings.headers), queue: settings.queue, encoder: settings.encoder, decoder: settings.decoder)
    }
    
    public struct NewTokenParams: Encodable {
        let password: String
        let endpoints: [String]
    }
    
    public func newToken(password: String, endpoints: [String], cb: @escaping RequestCallback<NewTokenParams, String, SerializableValue>) {
        struct NewTokenResponse: Decodable {
            let token: String
        }
        
        service.call(
            method: "auth.newToken",
            params: NewTokenParams(password: password, endpoints: endpoints),
            NewTokenResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.map { $0.token })
        }
    }
    
    
    public struct RevokeTokenParams: Encodable {
        let password: String
        let token: String
    }
    
    public func revokeToken(password: String, token: String, cb: @escaping RequestCallback<RevokeTokenParams, Nil, SerializableValue>) {
        service.call(
            method: "auth.revokeToken",
            params: RevokeTokenParams(password: password, token: token),
            SuccessResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.flatMap { $0.toResult() })
        }
    }
    
    
    public struct ChangePasswordParams: Encodable {
        let oldPassword: String
        let newPassword: String
    }
    
    public func changePassword(password: String, newPassword: String, cb: @escaping RequestCallback<ChangePasswordParams, Nil, SerializableValue>) {
        service.call(
            method: "auth.changePassword",
            params: ChangePasswordParams(oldPassword: password, newPassword: newPassword),
            SuccessResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.flatMap { $0.toResult() })
        }
    }
}

extension AvalancheCore {
    public var auth: AvalancheAuthApi {
        try! self.getAPI()
    }
}

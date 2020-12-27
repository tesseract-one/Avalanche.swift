//
//  File.swift
//  
//
//  Created by Daniel Leping on 27/12/2020.
//

import Foundation

import RPC
import Serializable

public struct AvalancheKeystoreApiInfo: AvalancheApiInfo {
    public let apiPath: String = "/ext/keystore"
}

public class AvalancheKeystoreApi: AvalancheApi {
    public typealias Info = AvalancheKeystoreApiInfo

    private let service: Client

    public required init(avalanche: AvalancheCore, network: AvalancheNetwork, hrp: String, info: AvalancheKeystoreApiInfo) {
        let settings = avalanche.settings
        let url = avalanche.url(path: info.apiPath)
            
        self.service = JsonRpc(.http(url: url, session: settings.session, headers: settings.headers), queue: settings.queue, encoder: settings.encoder, decoder: settings.decoder)
    }
    
    public struct CredentialsParams: Encodable {
        let username: String
        let password: String
    }
    
    public func createUser(username: String, password: String, cb: @escaping RequestCallback<CredentialsParams, Nil, SerializableValue>) {
        service.call(
            method: "keystore.createUser",
            params: CredentialsParams(username: username, password: password),
            SuccessResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.flatMap { $0.toResult() })
        }
    }
    
    public func deleteUser(username: String, password: String, cb: @escaping RequestCallback<CredentialsParams, Nil, SerializableValue>) {
        service.call(
            method: "keystore.deleteUser",
            params: CredentialsParams(username: username, password: password),
            SuccessResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.flatMap { $0.toResult() })
        }
    }
    
    public enum ExportEncoding: String, Encodable, Decodable {
        public typealias RawValue = String
        
        case cb58 = "cb58"
        case hex = "hex"
    }
    
    public struct ExportUserParams: Encodable {
        let username: String
        let password: String
        
        let encoding: ExportEncoding?
    }
    
    public struct ExportUserResponse: Decodable {
        let user: String
        let encoding: ExportEncoding
    }
    
    public func exportUser(username: String, password: String, encoding: ExportEncoding? = nil, cb: @escaping RequestCallback<ExportUserParams, ExportUserResponse, SerializableValue>) {
        service.call(
            method: "keystore.exportUser",
            params: ExportUserParams(username: username, password: password, encoding: encoding),
            ExportUserResponse.self,
            SerializableValue.self,
            response: cb
        )
    }
    
    public struct ImportUserParams: Encodable {
        let username: String
        let password: String
        let user: String
        
        let encoding: ExportEncoding?
    }
    
    public func importUser(username: String, password: String, user: String, encoding: ExportEncoding? = nil, cb: @escaping RequestCallback<ImportUserParams, Nil, SerializableValue>) {
        service.call(
            method: "keystore.importUser",
            params: ImportUserParams(username: username, password: password, user: user, encoding: encoding),
            SuccessResponse.self,
            SerializableValue.self
        ) { response in
            cb(response.flatMap { $0.toResult() })
        }
    }
    
    public func listUsers(cb: @escaping RequestCallback<Nil, [String], SerializableValue>) {
        struct Response: Decodable {
            let users: [String]
        }
        
        service.call(
            method: "keystore.listUsers",
            params: .nil,
            Response.self,
            SerializableValue.self
        ) { response in
            cb(response.map { $0.users })
        }
    }
}

extension AvalancheCore {
    public var keystore: AvalancheKeystoreApi {
        try! self.getAPI()
    }
}

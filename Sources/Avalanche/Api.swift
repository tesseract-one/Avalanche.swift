//
//  Api.swift
//  
//
//  Created by Yehor Popovych on 9/5/20.
//

import Foundation

public protocol AvalancheApi {
    associatedtype Info: AvalancheApiInfo
    
    init(avalanche: AvalancheCore, network: AvalancheNetwork, hrp: String, info: Info)
    
    static var id: String { get }
}

extension AvalancheApi {
    public static var id: String {
        return String(describing: self)
    }
}

public protocol AvalancheApiInfo {
    var blockchainId: String { get }
    var alias: String? { get }
    var vm: String { get }
}

public class AvalancheBaseApiInfo: AvalancheApiInfo {
    public let blockchainId: String
    public let alias: String?
    public let vm: String
    
    public init(bId: String, alias: String?, vm: String) {
        self.blockchainId = bId
        self.alias = alias
        self.vm = vm
    }
    
    public var apiPath: String {
        return "/ext/bc/\(alias ?? blockchainId)"
    }
}

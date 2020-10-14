//
//  Network.swift
//  
//
//  Created by Yehor Popovych on 10/14/20.
//

import Foundation

public struct AvalancheNetwork: Equatable, Hashable {
    public let networkId: UInt
    
    public init(netId: UInt) {
        networkId = netId
    }
    
    public static let manhattan = AvalancheNetwork(netId: 0)
    public static let avalanche = AvalancheNetwork(netId: 1)
    public static let cascade = AvalancheNetwork(netId: 2)
    public static let denali = AvalancheNetwork(netId: 3)
    public static let everest = AvalancheNetwork(netId: 4)
    public static let fuji = AvalancheNetwork(netId: 5)
    
    public static let main = Self.avalanche
    public static let test = Self.fuji
    public static let local = AvalancheNetwork(netId: 12345)
}

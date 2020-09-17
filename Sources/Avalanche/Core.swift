//
//  File.swift
//  
//
//  Created by Yehor Popovych on 9/5/20.
//

import Foundation

public protocol AvalancheCore: class {
    var network: AvalancheNetworkProvider { get }
    
    init(network: AvalancheNetworkProvider);
    
    func getAPI<A: AvalancheAPI>() -> A;
}

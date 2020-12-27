//
//  Settings.swift
//  
//
//  Created by Daniel Leping on 17/12/2020.
//

import Foundation
#if !COCOAPODS
import RPC
#endif

public struct AvalancheSettings {
    let queue: DispatchQueue
    let session: URLSession
    let headers: Dictionary<String, String>
    let encoder: ContentEncoder
    let decoder: ContentDecoder
    
    public static let `default` = AvalancheSettings(queue: .main, session: .shared, headers: [:], encoder: JSONEncoder.rpc, decoder: JSONDecoder.rpc)
}

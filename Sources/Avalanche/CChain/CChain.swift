//
//  CChain.swift
//  
//
//  Created by Yehor Popovych on 10/14/20.
//

import Foundation
import BigInt

public class AvalancheCChainApiInfo: AvalancheBaseApiInfo {
    public let gasPrice: BigUInt
    public let chainId: UInt32
    
    public init(
        gasPrice: BigUInt, chainId: UInt32, bId: String,
        alias: String? = nil, vm: String = "evm"
    ) {
        self.gasPrice = gasPrice
        self.chainId = chainId
        super.init(bId: bId, alias: alias, vm: vm)
    }
    
    override public var apiPath: String {
        return super.apiPath + "/rpc"
    }
    
    public var wsApiPath: String {
        return super.apiPath + "/ws"
    }
}

public class AvalancheCChainApi: AvalancheApi {
    public typealias Info = AvalancheCChainApiInfo
    
    private struct SubscriptionId: Decodable {
        let subscription: String
    }
    
    private var subscriptions: Dictionary<String, (Data, AvalancheSubscribableRpcConnection) -> Void>
    private var subscriptionId: UInt?
    private let network: AvalancheSubscribableRpcConnection
    public let keychain: AvalancheEthereumKeychain
    
    public required init(avalanche: AvalancheCore, network: AvalancheNetwork, hrp: String, info: Info) {
        self.network = avalanche.connections.wsRpcConnection(for: info.wsApiPath)
        self.keychain = avalanche.keychains.avaEthereumKeychain(network: network, chainId: info.chainId)
        self.subscriptions = [:]
        self.subscriptionId = nil
    }
    
    private func processMessage(data: Data) {
        do {
            let (_, id) = try network.parseInfo(from: data, SubscriptionId.self)
            guard let handler = subscriptions[id.subscription] else {
                return
            }
            handler(data, network)
        } catch {}
    }
    
    private func subscribeIfNeeded() {
        guard subscriptionId == nil else { return }
        self.subscriptionId = network.subscribe { [weak self] data, _ in
            self?.processMessage(data: data)
        }
    }
    
    private func unsubscribeIfNeeded() {
        guard let subId = subscriptionId, subscriptions.count == 0 else { return }
        subscriptionId = nil
        network.unsubscribe(id: subId)
    }
    
    // Subscription Example. Should be updated to proper types
//    public func eth_subscribe<P: Encodable>(type:  params: P, result: @escaping AvalancheConnectionCallback<CChainSubscription<String>>) {
//        network.call(method: "eth_subscribe", params: params, String.self) { res in
//            result(res.map {
//                let sub = CChainSubscription<String>(id: $0)
//                self.subscriptions[$0] = sub.handler
//                return sub
//            })
//        }
//    }
//
//    public func eth_unsubscribe<S: CChainSubscription<P, M>, P: Encodable, M: Decodable>(
//        subcription: S, result: @escaping AvalancheConnectionCallback<Bool>
//    ) {
//        self.subscriptions.removeValue(forKey: subcription.id)
//        self.unsubscribeIfNeeded()
//        network.call(method: "eth_unsubscribe", params: subcription.id, Bool.self, result: result)
//    }
}

extension AvalancheCore {
    public var CChain: AvalancheCChainApi {
        return try! self.getAPI()
    }
    
    public func CChain(network: AvalancheNetwork, hrp: String, info: AvalancheCChainApi.Info) -> AvalancheCChainApi {
        return self.createAPI(network: network, hrp: hrp, info: info)
    }
}

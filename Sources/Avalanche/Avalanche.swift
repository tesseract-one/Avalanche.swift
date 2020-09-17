import Foundation

public class Avalanche: AvalancheCore {
    private var apis: [String: AvalancheAPI];
    
    public var network: AvalancheNetworkProvider;
    
    required public init(network: AvalancheNetworkProvider) {
        self.apis = [:];
        self.network = network;
    }
    
    public func getAPI<A: AvalancheAPI>() -> A {
        if let api = self.apis[A.id] as? A {
            return api
        }
        let api = A(avalanche: self)
        self.apis[A.id] = api
        return api
    }
}


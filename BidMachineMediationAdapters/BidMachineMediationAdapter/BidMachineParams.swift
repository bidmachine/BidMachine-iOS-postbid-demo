//
//  BidMachineNeworkParams.swift
//  BidMachineMediationAdapter
//
//  Created by Ilia Lozhkin on 09.06.2022.
//

import BidMachineMediationModule

struct BidMachineNeworkParams: MediationNetworkParamsProtocol, Codable {
    
    let sourceId: String
}

extension Dictionary {
    
    func decode<T: Codable>() -> T? {
        let data = try? JSONSerialization.data(withJSONObject: self)
        return data.flatMap { try? JSONDecoder().decode(T.self, from: $0) }
    }
    
}

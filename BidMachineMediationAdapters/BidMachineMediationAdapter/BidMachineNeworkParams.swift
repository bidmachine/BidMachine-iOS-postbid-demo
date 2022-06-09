//
//  BidMachineNeworkParams.swift
//  BidMachineMediationAdapter
//
//  Created by Ilia Lozhkin on 09.06.2022.
//

import BidMachineMediationModule

class BidMachineNeworkParams: MediationNetworkParams {
    
    private enum Constants {
        
        static let sourceId = "source_id"
    }
    
    let sourceId: String?
    
    required init(_ params: MediationParams) {
        sourceId = params[Constants.sourceId].flatMap { $0 as? String }
        super.init(params)
    }
}

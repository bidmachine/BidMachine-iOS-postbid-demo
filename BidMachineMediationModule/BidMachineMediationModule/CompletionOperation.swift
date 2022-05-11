//
//  CompletionOperation.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 09.05.2022.
//

import Foundation

typealias CompletionBlock = (MediationAdapter?) -> Void

class CompletionOperation: AsyncOperation {
    
    private let completion: CompletionBlock
    
    init(_ _completion: @escaping CompletionBlock) {
        completion = _completion
    }
    
    override func main() {
        Logging.log("----- Start mediation block")
        
        let adaptors:[MediationAdapter] = self.dependencies.compactMap { $0 as? BidOperation }.flatMap { $0.adaptors() }
        let adaptor = adaptors.maxPriceAdaptor()
        
        Logging.log("------------ Loaded adapters: \(adaptors.adaptorsParams.prettyParams)")
        if let adaptor = adaptor {
            Logging.log("------------ 🔥🥳 Max price adapter 🥳🔥: \(adaptor.params.pretty) 🎉🎉🎉")
        } else {
            Logging.log("------------ ❌❌ Adaptor not loaded (no fill) ❌❌")
        }
        
        Logging.log("----- Complete mediation block")
        
        completion(adaptor)
        self.state = .finished
    }
}

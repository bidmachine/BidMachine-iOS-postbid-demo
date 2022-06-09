//
//  CompletionOperation.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 09.05.2022.
//

import Foundation

typealias CompletionBlock = (MediationAdapterWrapper?) -> Void

class CompletionOperation: AsyncOperation {
    
    private let completion: CompletionBlock
    
    init(_ _completion: @escaping CompletionBlock) {
        completion = _completion
    }
    
    override func main() {
        Logging.log("----- Start mediation block")
        
        let wrappers:[MediationAdapterWrapper] = self.dependencies.compactMap { $0 as? BidOperation }.flatMap { $0.adaptorWrappers() }
        let wrapper = wrappers.maxPriceWrapper()
        
        Logging.log("------------ Loaded adapters: \(wrappers)")
        if let wrapper = wrapper {
            Logging.log("------------ 🔥🥳 Max price adapter 🥳🔥: \(wrapper) 🎉🎉🎉")
        } else {
            Logging.log("------------ ❌❌ Adaptor not loaded (no fill) ❌❌")
        }
        
        Logging.log("----- Complete mediation block")
        
        completion(wrapper)
        self.state = .finished
    }
}

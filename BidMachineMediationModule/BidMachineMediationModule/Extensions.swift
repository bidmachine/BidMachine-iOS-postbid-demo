//
//  Extensions.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 09.05.2022.
//

import Foundation

extension Array where Element == MediationAdapterWrapper {
    
    func maxPriceWrapper() -> Element? {
        return self.sorted { $0.price >= $1.price }.first
    }
}

//extension MediationAdapter {
//    
//    var params: MediationAdaptorsParams {
//        return MediationAdaptorsParams(name: self.name, price: self.price)
//    }
//}
//
//extension Array where Element == MediationAdapter {
//    
//    var adaptorsParams : [MediationAdaptorsParams] {
//        return self.compactMap { $0.params }
//    }
//}
//
//extension Array where Element == MediationAdaptorsParams {
//    
//    var prettyParams : [String] {
//        return self.compactMap { $0.pretty }
//    }
//}

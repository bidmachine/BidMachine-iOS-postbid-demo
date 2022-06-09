//
//  MediationAdapterWrapper.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 08.06.2022.
//

import Foundation

class MediationAdapterWrapper: NSObject {
    
    private let adapterName: String
    
    private let adapter: MediationAdapter
    
    private let params: MediationAdapterParams
    
    private weak var loadingDelegate: MediationAdapterWrapperLoadingDelegate?
    
    private weak var displayDelegate: MediationAdapterWrapperDisplayDelegate?
    
    
    init?(_ pair: MediationPair, _ request: Request, _ _type: MediationType) {
        let registeredNetwork = NetworkRegistration.shared.network(pair.name)
        let registeredAdapterClass = registeredNetwork?.adapter(_type, request.placement)
        
        guard let registeredAdapterClass = registeredAdapterClass else { return nil }
        
        let adapterParams = registeredAdapterClass.T.init(pair.params)
        let registeredAdapter = registeredAdapterClass.init(adapterParams)
        
        adapter = registeredAdapter
        params = type(of: adapter).T.init(pair.params)
        adapterName = pair.name
        
        params.price = request.priceFloor
        params.size = request.size
        params.controller = request.controller
        params.container = request.container
    }
    
    override var description: String {
        return ("< \(name) : \(price) >")
    }
}

extension MediationAdapterWrapper {
    
    var name: String {
        return adapterName
    }
    
    var price: Double {
        return adapter.adapterPrice
    }
    
    var isReady: Bool {
        return adapter.adapterReady
    }
    
    func load(_ price: Double = 0, _ delegate: MediationAdapterWrapperLoadingDelegate) {
        self.loadingDelegate = delegate
        adapter.loadingDelegate = self
        params.price = price
        adapter.load()
    }
    
    func present(_ delegate: MediationAdapterWrapperDisplayDelegate) {
        self.displayDelegate = delegate
        adapter.displayDelegate = self
        adapter.present()
    }
}

extension MediationAdapterWrapper: MediationAdapterLoadingDelegate {
    
    func didLoad(_ adapter: MediationAdapter) {
        self.loadingDelegate.flatMap { $0.didLoad(self) }
        self.loadingDelegate = nil
    }
    
    func failLoad(_ adapter: MediationAdapter, _ error: Error) {
        self.loadingDelegate.flatMap { $0.failLoad(self, error) }
        self.loadingDelegate = nil
    }
}

extension MediationAdapterWrapper: MediationAdapterDisplayDelegate {
    
    func willPresentScreen(_ adapter: MediationAdapter) {
        self.displayDelegate.flatMap { $0.willPresentScreen(self) }
    }
    
    func didFailPresent(_ adapter: MediationAdapter, _ error: Error) {
        self.displayDelegate.flatMap { $0.didFailPresent(self, error) }
    }
    
    func didDismissScreen(_ adapter: MediationAdapter) {
        self.displayDelegate.flatMap { $0.didDismissScreen(self) }
    }
    
    func didTrackImpression(_ adapter: MediationAdapter) {
        self.displayDelegate.flatMap { $0.didTrackImpression(self) }
    }
    
    func didTrackInteraction(_ adapter: MediationAdapter) {
        self.displayDelegate.flatMap { $0.didTrackInteraction(self) }
    }
    
    func didTrackReward(_ adapter: MediationAdapter) {
        self.displayDelegate.flatMap { $0.didTrackReward(self) }
    }
    
    func didTrackExpired(_ adapter: MediationAdapter) {
        self.displayDelegate.flatMap { $0.didTrackExpired(self) }
    }
}

//
//  MediationAdapterWrapper.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 08.06.2022.
//

import Foundation

class MediationAdapterWrapper: NSObject {
    
    private let adapterName: String
    
    private var adapter: MediationAdapterProtocol
    
    private weak var loadingDelegate: MediationAdapterWrapperLoadingDelegate?
    
    private weak var displayDelegate: MediationAdapterWrapperDisplayDelegate?
    
    
    init?(_ pair: MediationPair, _ request: Request, _ _type: MediationType) {
        let registeredNetwork = NetworkRegistration.shared.network(pair.name)
        let registeredAdapterClass = registeredNetwork?.adapter(_type, request.placement)
        
        guard let registeredAdapterClass = registeredAdapterClass else { return nil }
        
        let registeredAdapter = registeredAdapterClass.init(pair.params)
        
        adapterName = pair.name
        adapter = registeredAdapter
        
        adapter.adapterParams.price = request.priceFloor
        adapter.adapterParams.size = request.size
        adapter.adapterParams.controller = request.controller
        adapter.adapterParams.container = request.container
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
        
        adapter.adapterParams.price = price
        adapter.load()
    }
    
    func present(_ delegate: MediationAdapterWrapperDisplayDelegate) {
        self.displayDelegate = delegate
        adapter.displayDelegate = self
        adapter.present()
    }
}

extension MediationAdapterWrapper: MediationAdapterLoadingDelegate {
    
    func didLoad(_ adapter: MediationAdapterProtocol) {
        self.loadingDelegate.flatMap { $0.didLoad(self) }
        self.loadingDelegate = nil
    }
    
    func failLoad(_ adapter: MediationAdapterProtocol, _ error: Error) {
        self.loadingDelegate.flatMap { $0.failLoad(self, error) }
        self.loadingDelegate = nil
    }
}

extension MediationAdapterWrapper: MediationAdapterDisplayDelegate {
    
    func willPresentScreen(_ adapter: MediationAdapterProtocol) {
        self.displayDelegate.flatMap { $0.willPresentScreen(self) }
    }
    
    func didFailPresent(_ adapter: MediationAdapterProtocol, _ error: Error) {
        self.displayDelegate.flatMap { $0.didFailPresent(self, error) }
    }
    
    func didDismissScreen(_ adapter: MediationAdapterProtocol) {
        self.displayDelegate.flatMap { $0.didDismissScreen(self) }
    }
    
    func didTrackImpression(_ adapter: MediationAdapterProtocol) {
        self.displayDelegate.flatMap { $0.didTrackImpression(self) }
    }
    
    func didTrackInteraction(_ adapter: MediationAdapterProtocol) {
        self.displayDelegate.flatMap { $0.didTrackInteraction(self) }
    }
    
    func didTrackReward(_ adapter: MediationAdapterProtocol) {
        self.displayDelegate.flatMap { $0.didTrackReward(self) }
    }
    
    func didTrackExpired(_ adapter: MediationAdapterProtocol) {
        self.displayDelegate.flatMap { $0.didTrackExpired(self) }
    }
}

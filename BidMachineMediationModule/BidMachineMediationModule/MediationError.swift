//
//  MediationError.swift
//  BidMachineMediationModule
//
//  Created by Ilia Lozhkin on 09.05.2022.
//

import Foundation

public enum MediationError: LocalizedError  {
    
    case noContent(String)
    case presentError(String)
    case loadingError(String)
    
    public var errorDescription: String? {
        switch self {
        case .noContent(let message): return "No content was received with description: \(message)"
        case .presentError(let message): return "Fail to present content: \(message)"
        case .loadingError(let message): return "Fail to load: \(message)"
        }
    }
}

extension MediationError: CustomNSError {
    
    public static var errorDomain: String {
        return "com.mediation.module.error"
    }
    
    public var errorCode: Int {
        switch self {
        case .noContent: return 1
        case .presentError: return 2
        case .loadingError: return 3
        }
    }
}

//
//  NSError+BarCodeReaderView.swift
//  BarCodeReader
//
//  Created by Omar Alshammari on 2/18/16.
//  Copyright © 2016 ___OALSHAMMARI___. All rights reserved.
//

private let errorDomain = "com.ommaarr90.BarCodeReaderView.ErrorDomain"

private enum ErrorCode: Int {
    case AccessRestriction = 7000
    case DeviceNotSupported
    case OutputNotSuppoted
}

internal extension NSError {
    internal static func accessRestrictionError() -> NSError {
        return NSError(domain: errorDomain, code: ErrorCode.AccessRestriction.rawValue, userInfo: NSError.accessRestrictionUserInfo())
    }
    
    internal static func deviceNotSupportedError() -> NSError {
        return NSError(domain: errorDomain, code: ErrorCode.DeviceNotSupported.rawValue, userInfo: NSError.deviceNotSupportedUserInfo())
    }

    internal static func outputNotSupportedError() -> NSError {
        return NSError(domain: errorDomain, code: ErrorCode.OutputNotSuppoted.rawValue, userInfo: NSError.outputNotSupportedUserInfo())
    }

    private static func accessRestrictionUserInfo() -> [String: AnyObject] {
        let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString("User disabled access to his camera for this app", comment: ""),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString("Could not access the camera", comment: ""),
            NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString("Have you asked the user to allow access?", comment: "")
        ]
        
        return userInfo
    }
    
    private static func deviceNotSupportedUserInfo() -> [String: AnyObject] {
        let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString("Cannot Read Barcode.", comment: ""),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString("The device is not supported.", comment: ""),
            NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString("Try using an other device that has camera", comment: "")
        ]
        
        return userInfo
    }

    private static func outputNotSupportedUserInfo() -> [String: AnyObject] {
        let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString("Cannot Read Barcode", comment: ""),
            NSLocalizedFailureReasonErrorKey: NSLocalizedString("Unable to add output", comment: ""),
            NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString("I'm afraid I cannot help you :(", comment: "")
        ]
        
        return userInfo
    }

}
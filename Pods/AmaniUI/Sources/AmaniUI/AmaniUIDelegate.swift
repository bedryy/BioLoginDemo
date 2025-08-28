//
//  AmaniUIDelegate.swift
//  AmaniUIv1
//
//  Created by Münir Ketizmen on 26.12.2022.
//

import Foundation
import AmaniSDK
public protocol AmaniUIDelegate: AnyObject {
    func onKYCSuccess(CustomerId:String)
    func onKYCFailed(CustomerId:String,Rules:[[String:String]]?)
    func onError(type:String,Error:[AmaniError])
}

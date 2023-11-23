//
//  JKObserver.swift
//  JKPacket
//
//  Created by JackLee on 2022/3/23.
//

import Foundation
public protocol JKObserver:Hashable{
    associatedtype T
    
    var uniqueId:UUID { get }
    
    /// called when the data changed
    func onChanged(t:T?, extra:Any?)
    
    func markHasPendingData(_ t:T?, extra:Any?)
    
    func markHasNoPendingData()
    
    func isHavePendingData() -> Bool
}

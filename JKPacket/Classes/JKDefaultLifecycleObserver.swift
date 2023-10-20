//
//  JKDefaultLifecycleEventObserver.swift
//  JKPacket
//
//  Created by JackLee on 2022/3/30.
//

import Foundation
//生命周期事件监听类
public class JKDefaultLifecycleObserver:JKLifecycleObserver
{
    public var uniqueId: UUID = UUID()
    
    typealias StateChangedBlock = (_ source: JKLifecycleOwner, _ event: JKLifecycle.Event) -> Void
    var stateChangedBlock:StateChangedBlock?
    
    public func onStateChanged(source: JKLifecycleOwner, event: JKLifecycle.Event) {
        guard event != .ON_ANY else {
            return
        }
        stateChangedBlock?(source,event)
    }
    
    public static func == (lhs: JKDefaultLifecycleObserver, rhs: JKDefaultLifecycleObserver) -> Bool {
         lhs.hashValue == rhs.hashValue
     }
     
    public var hashValue: Int  {
         return uniqueId.hashValue
    }

    public func hash(into hasher: inout Hasher) {
         uniqueId.hash(into: &hasher)
     }
}

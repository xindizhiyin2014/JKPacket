//
//  JKLifecycleObserver.swift
//  JKPacket
//
//  Created by JackLee on 2022/3/23.
//

import Foundation
public protocol JKLifecycleObserver:Hashable {
    var uniqueId:UUID { get }
    var stateChangedBlock:((_ source: JKLifecycleOwner, _ event: JKLifecycle.Event) -> Void)? {set get}
    func onStateChanged(source:JKLifecycleOwner, event:JKLifecycle.Event)
}



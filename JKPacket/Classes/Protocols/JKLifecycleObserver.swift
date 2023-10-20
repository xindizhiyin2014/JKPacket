//
//  JKLifecycleObserver.swift
//  JKPacket
//
//  Created by JackLee on 2022/3/23.
//

import Foundation
public protocol JKLifecycleObserver:Hashable {
    var uniqueId:UUID { get }
    func onStateChanged(source:JKLifecycleOwner, event:JKLifecycle.Event)
}



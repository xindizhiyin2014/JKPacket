//
//  JKLifecycleOwner.swift
//  JKPacket
//
//  Created by JackLee on 2022/3/22.
//

import Foundation
public protocol JKLifecycleOwner:NSObjectProtocol {
    func getLifecycle() -> JKLifecycle
}

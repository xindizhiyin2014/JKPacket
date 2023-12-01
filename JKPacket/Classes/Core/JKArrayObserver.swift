//
//  JKArrayObserver.swift
//  JKPacket
//
//  Created by jack on 2023/11/10.
//

import Foundation
import RxSwift

public class JKArrayObserver<T>: JKObserver {
    public var uniqueId: UUID = UUID()
    
    let disposeBag = DisposeBag()
    
    let publishSubject = PublishSubject<(list: T?, change: JKArrayPartialChange?)>()
    
    private var hasPendingData = false
    public func onChanged(t: T?, extra:Any? = JKArrayPartialChange(type: .assign, indexs: nil)) {
        publishSubject.onNext((t, extra as? JKArrayPartialChange))
    }
    
    
    func observe(onSubject:((_ subject:Observable<(list: T?, change: JKArrayPartialChange?)>)->Observable<(list: T?, change: JKArrayPartialChange?)>)? = nil, block: @escaping ((_ value:(list: T?, change: JKArrayPartialChange?))->Void)) {
        publishSubject.handleOnSubject(subject: publishSubject, onSubject: onSubject).subscribe { e in
            if let element = e.element {
                block(element)
            }
        }.disposed(by: disposeBag)
    }
    public func markHasPendingData(_ t: T?, extra:Any? = nil) {
        hasPendingData = true
    }
    
    public func markHasNoPendingData() {
        hasPendingData = false
    }
    
    public func isHavePendingData() -> Bool {
        return hasPendingData
    }
}

extension JKArrayObserver:Hashable {
    
    public static func == (lhs: JKArrayObserver<T>, rhs: JKArrayObserver<T>) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public var hashValue: Int  {
         return uniqueId.hashValue
    }

    public func hash(into hasher: inout Hasher) {
         uniqueId.hash(into: &hasher)
     }
}

private extension PublishSubject {
    func handleOnSubject<T>(subject:Observable<(list: T?, change: JKArrayPartialChange?)>,
                            onSubject:((_ subject:Observable<(list: T?, change: JKArrayPartialChange?)>)->Observable<(list: T?, change: JKArrayPartialChange?)>)?) -> Observable<(list: T?, change: JKArrayPartialChange?)> {
        if onSubject != nil {
            return onSubject!(subject)
        }
        return subject
    }
}



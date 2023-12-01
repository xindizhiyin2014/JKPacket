//
//  JKDictionaryObserver.swift
//  JKPacket
//
//  Created by jack on 2023/11/10.
//

import Foundation
import RxSwift

public class JKDictionaryObserver<T,Key> : JKObserver where Key : Hashable{
    
    public var uniqueId: UUID = UUID()
    
    let disposeBag = DisposeBag()
    let publishSubject = PublishSubject<(dic: T?, change: JKDictionaryPartialChange<Key>? )>()
    
    private var hasPendingData = false
    
    public func onChanged(t: T?, extra: Any? = JKDictionaryPartialChange<Key>(type: .assign, keys: nil)) {
        publishSubject.onNext((t, extra as? JKDictionaryPartialChange))
    }
    
    func observe(onSubject:((_ subject:Observable<(dic: T?, change: JKDictionaryPartialChange<Key>?)>)->Observable<(dic: T?, change: JKDictionaryPartialChange<Key>?)>)? = nil, block: @escaping ((_ value:(dic: T?, change: JKDictionaryPartialChange<Key>?))->Void)) {
        publishSubject.handleOnSubject(subject: publishSubject, onSubject: onSubject).subscribe { e in
            if let element = e.element {
                block(element)
            }
        }.disposed(by: disposeBag)
    }
    
    
    public func markHasNoPendingData() {
        hasPendingData = false
    }
    
    public func isHavePendingData() -> Bool {
        return hasPendingData
    }
    
    
    public func markHasPendingData(_ t: T?, extra: Any?) {
        hasPendingData = true
    }
    
}


extension JKDictionaryObserver:Hashable {
    
    public static func == (lhs: JKDictionaryObserver<T, Key>, rhs: JKDictionaryObserver<T, Key>) -> Bool {
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
    func handleOnSubject<T, Key>(subject:Observable<(dic: T?, change: JKDictionaryPartialChange<Key>?)>,
                                 onSubject:((_ subject:Observable<(dic: T?, change: JKDictionaryPartialChange<Key>?)>)->Observable<(dic: T?, change: JKDictionaryPartialChange<Key>?)>)?) -> Observable<(dic: T?, change: JKDictionaryPartialChange<Key>?)> where Key : Hashable {
        if onSubject != nil {
            return onSubject!(subject)
        }
        return subject
    }
}


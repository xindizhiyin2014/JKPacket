//
//  JKDefaultObserver.swift
//  JKPacket
//
//  Created by jack on 2023/10/10.
//

import Foundation
import RxSwift

public class JKDefaultObserver<V>:JKObserver {
   
    
    
    
    public typealias T = V
    
    public var uniqueId: UUID = UUID()
    
    let disposeBag = DisposeBag()
    
    let publishSubject = PublishSubject<V?>()
    
    private var hasPendingData = false
   
    public func onChanged(t: V?) {
        publishSubject.onNext(t)
    }
    
    
    func observe(onSubject:((_ subject:Observable<V?>)->Observable<V?>)? = nil, block: @escaping ((_ value:V?)->Void)) {
        publishSubject.handleOnSubject(subject: publishSubject, onSubject: onSubject).subscribe { e in
            if let element = e.element {
                block(element)
            } else {
               block(nil)
            }
        }.disposed(by: disposeBag)
    }
    public func markHasPendingData(_ t: V?) {
        hasPendingData = true
    }
    
    public func markHasNoPendingData() {
        hasPendingData = false
    }
    
    public func isHavePendingData() -> Bool {
        return hasPendingData
    }
    
}


extension JKDefaultObserver:Hashable {
    
    public static func == (lhs: JKDefaultObserver<T>, rhs: JKDefaultObserver<T>) -> Bool {
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
    func handleOnSubject<V>(subject:Observable<V>,
                         onSubject:((_ subject:Observable<V>)->Observable<V>)?) -> Observable<V> {
        if onSubject != nil {
            return onSubject!(subject)
        }
        return subject
    }
}


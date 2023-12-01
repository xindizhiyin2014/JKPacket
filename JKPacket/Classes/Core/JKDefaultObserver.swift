//
//  JKDefaultObserver.swift
//  JKPacket
//
//  Created by jack on 2023/10/10.
//

import Foundation
import RxSwift

public class JKDefaultObserver<T>:JKObserver {
   
    public var uniqueId: UUID = UUID()
    
    let disposeBag = DisposeBag()
    
    let publishSubject = PublishSubject<T?>()
    
    private var hasPendingData = false
   
    public func onChanged(t: T?, extra:Any?) {
        publishSubject.onNext(t)
    }
    
    
    func observe(onSubject:((_ subject:Observable<T?>)->Observable<T?>)? = nil, block: @escaping ((_ value:T?)->Void)) {
        publishSubject.handleOnSubject(subject: publishSubject, onSubject: onSubject).subscribe { e in
            if let element = e.element {
                block(element)
            } else {
               block(nil)
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
    func handleOnSubject<T>(subject:Observable<T>,
                         onSubject:((_ subject:Observable<T>)->Observable<T>)?) -> Observable<T> {
        if onSubject != nil {
            return onSubject!(subject)
        }
        return subject
    }
}


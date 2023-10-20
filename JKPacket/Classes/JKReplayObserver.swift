//
//  JKReplayObserver.swift
//  JKPacket
//
//  Created by jack on 2023/10/19.
//

import Foundation
import RxSwift

public class JKReplayObserver<V>:JKObserver {
    
    public typealias T = V
    public var uniqueId: UUID = UUID()
    let disposeBag = DisposeBag()
    let publishSubject = PublishSubject<V?>()
    private var mPendingDatas = [V?]()
    internal var bufferSize:UInt
    private var isHandingPendingData = false
    
    init(bufferSize: UInt = 1) {
        self.bufferSize = bufferSize
    }
    public func onChanged(t: V?) {
        defer {
            liveDataLock.unlock()
        }
        liveDataLock.lock()
        guard isHandingPendingData == false else {
            mPendingDatas.append(t)
            return
        }
        if mPendingDatas.count > 0 {
            while mPendingDatas.count > 0 {
                isHandingPendingData = true
                let tmpData = mPendingDatas.first as? V
                mPendingDatas.remove(at: 0)
                publishSubject.onNext(tmpData)
            }
            isHandingPendingData = false
        } else {
            publishSubject.onNext(t)
        }
        
        

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
    
    public func markHasPendingData(_ t:T?) {
        guard bufferSize  > 0 else {
            mPendingDatas.append(t)
            return
        }
        while mPendingDatas.count >= bufferSize {
            mPendingDatas.remove(at: 0)
        }
        mPendingDatas.append(t)
    }
    
    public func markHasNoPendingData() {
        mPendingDatas.removeAll()
    }
    
    public func isHavePendingData() -> Bool {
        return mPendingDatas.count > 0
    }
    
}


extension JKReplayObserver:Hashable {
    public static func == (lhs: JKReplayObserver<V>, rhs: JKReplayObserver<V>) -> Bool {
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

//
//  Radioactive.swift
//  Radioactive
//
//  Created by thomsmed on 13/06/2020.
//  Copyright © 2020 Thomas A. Smedmann. All rights reserved.
//

public struct Handle<T> {
    public private(set) var stop: () -> Void
    fileprivate init(_ stopper: @escaping () -> Void) {
        self.stop = stopper
    }
}

public protocol Emitting {
    associatedtype T
    mutating func listen(_  listener: @escaping (_ value: T?) -> Void) -> Handle<T>
}

public class Emitter<T>: Emitting {
    public typealias T = T
    
    fileprivate init() { }
    public func listen(_ listener: @escaping (_ value: T?) -> Void) -> Handle<T> {
        fatalError()
    }
}

public class MutableEmitter<T>: Emitter<T> {
    
    private var listeners: [Int: (_ value: T?) -> Void] = [:]
    private var previousKey: Int = 0
    
    public var value: T? {
        didSet {
            listeners.forEach({ $1(value) })
        }
    }
    
    public init(_ value: T?) {
        self.value = value
    }
    
    public override func listen(_  listener: @escaping (_ value: T?) -> Void) -> Handle<T> {
        let key = previousKey + 1
        listeners[key] = listener
        previousKey = key
        
        let handle = Handle<T>({ [weak self] in
            guard let ref = self else {
                return
            }
            
            ref.listeners.removeValue(forKey: key)
        })
        listener(value)
        
        return handle
    }
}

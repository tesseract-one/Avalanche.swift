//
//  File.swift
//  
//
//  Created by Daniel Leping on 14/12/2020.
//


public typealias Callback<Success, Failure: Error> = (Result<Success, Failure>)->Void

struct WeakRef<T: AnyObject> {
    weak var ref: T?
}

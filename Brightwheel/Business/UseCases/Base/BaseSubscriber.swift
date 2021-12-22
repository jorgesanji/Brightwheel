//
//  BaseSubscriber.swift
//  Brightwheel
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import RxSwift

extension ObservableType{
	func bindNext(_ onNext:@escaping (Element)-> Void, onError:((Swift.Error) -> Void)? = nil)-> Disposable{
		return subscribe(onNext: onNext, onError: { (error) in
			onError!(error)
		}, onCompleted: {
		}, onDisposed: {
		})
	}
}

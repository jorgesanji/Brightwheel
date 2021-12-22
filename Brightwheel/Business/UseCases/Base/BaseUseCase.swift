//
//  BaseUseCase.swift
//  netquest
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import RxSwift

class BaseUseCase<K>{

	private var subscriberScheduler:SchedulerType!
	private var observableScheduler:SerialDispatchQueueScheduler!
	private var disposable:Disposable!
	var proxyService: ProxyService?
	
	init(proxyService:ProxyService) {
		self.proxyService = proxyService
		initRx()
	}
	
	init() {
		initRx()
	}
	
	private func initRx(){
		self.subscriberScheduler = ConcurrentDispatchQueueScheduler(qos: .default)
		self.observableScheduler = MainScheduler.instance
	}
	
	func subscribe(_ onNext:@escaping (K)-> Void, onError:((Swift.Error) -> Void)? = nil){
		self.disposable = buildUseCaseObservable()?.subscribe(on: subscriberScheduler)
			.observe(on: observableScheduler).bindNext(onNext, onError: onError)
	}
	
	func buildUseCaseObservable() -> Observable<K>? {
		preconditionFailure("please override this method and build your observable")
	}
	
	func unsubscribe(){
		if disposable != nil{
			disposable.dispose()
		}
		disposable = nil
	}
	
	func isUnsubscribe()->Bool{
		return disposable != nil
	}
	
	func build() -> BaseUseCase<K> {
		return self
	}
}

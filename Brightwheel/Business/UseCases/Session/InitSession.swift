//
//  InitSession.swift
//  Brightwheel
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import RxSwift

protocol InitSessionUseCase: AnyObject{
	func build()->BaseUseCase<Void>
}

final class InitSession: BaseUseCase<Void>, InitSessionUseCase{
	
	override func buildUseCaseObservable() -> Observable<Void>? {
		return proxyService!.repository(.LOCAL).initSession()
	}
}


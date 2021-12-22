//
//  LocalRepository.swift
//  Brightwheel
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import RxSwift
import CoreData

final class LocalRepository : LocalRepositoryService{

	private final let localDataPrivate : LocalDataPrivate
	
	init(localDataPrivate : LocalDataPrivate){
		self.localDataPrivate = localDataPrivate
	}
	
	func initSession() -> Observable<Void>?{
		return Observable.just(localDataPrivate.sanitizingSession())
	}
}


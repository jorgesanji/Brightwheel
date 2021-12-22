//
//  Proxy.swift
//  netquest
//
//  Created by Jorge Sanmartin on 20/12/21.
//

final class Proxy: ProxyService{
	
	private final let restRepository:RestRepositoryService
	private final let locRepository:LocalRepositoryService
	private final let mockRepository:MockRepositoryService
	private let reachability = try! Reachability()
	private var isReachable:Bool = true

	init(restRepository:RestRepositoryService, localRepository:LocalRepositoryService, mockRespository:MockRepositoryService) {
		self.restRepository = restRepository
		self.locRepository = localRepository
		self.mockRepository = mockRespository
		initReachability()
	}
	deinit {
		reachability.stopNotifier()
	}
	
	func initReachability(){
		reachability.whenReachable = {[weak self] reachability in
			self?.isReachable = true
		}
		reachability.whenUnreachable = {[weak self]  _ in
			self?.isReachable = false
		}
		do {
			try reachability.startNotifier()
		} catch {
			print("Unable to start notifier")
		}
	}
	
	func localRepository() -> Repository {
		return locRepository
	}
	
	func repository() -> Repository {
		return isReachable ? restRepository : locRepository
	}
	
	func repository(_ type:RepositoryType = .REST) -> Repository{
		switch type {
		case .REST:
			return restRepository
		case .LOCAL:
			return locRepository
		default:
			return mockRepository
		}
	}
}

enum RepositoryType: Int {
	case REST
	case LOCAL
	case MOCK
}

//
//  CommonAssemblyContainer.swift
//  Brightwheel
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import Swinject
import SwinjectStoryboard

final class CommonAssemblyContainer: Assembly {
	
	func assemble(container: Container) {
		
		container.register(LocalDataPrivate.self) { r in
			return LocalDataPrivateImpl()
		}.inObjectScope(.container)
		
		container.register(RestRepositoryService.self) { r in
			return RestRepository(localPrivateStore: r.resolve(LocalDataPrivate.self)!)
		}.inObjectScope(.container)
		
		container.register(LocalRepositoryService.self) { r in
			let localDataPrivate = r.resolve(LocalDataPrivate.self)!
			return LocalRepository(localDataPrivate: localDataPrivate)
		}.inObjectScope(.container)
		
		container.register(MockRepositoryService.self) { r in
			return MockRepository()
		}.inObjectScope(.container)
		
		container.register(ProxyService.self) { r in
			let restRepository = r.resolve(RestRepositoryService.self)!
			let localRepository = r.resolve(LocalRepositoryService.self)!
			let mockRespository = r.resolve(MockRepositoryService.self)!
			return Proxy(restRepository: restRepository, localRepository: localRepository, mockRespository: mockRespository)
		}.inObjectScope(.container)
	}
}

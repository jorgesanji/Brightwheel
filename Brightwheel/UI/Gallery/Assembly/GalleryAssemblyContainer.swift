//
//  GalleryAssemblyContainer.swift
//  Brightwheel
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import Swinject
import SwinjectStoryboard

final class GalleryAssemblyContainer: Assembly {
	
	func assemble(container: Container) {
		
		container.register(InitSessionUseCase.self) { r in
			let initSessionUseCase = InitSession(proxyService: r.resolve(ProxyService.self)!)
			
			return initSessionUseCase
		}
		
		container.register(GetRepositoriesUseCase.self) { r in
			let getImagesUseCase = GetRepositories(proxyService: r.resolve(ProxyService.self)!)
			
			return getImagesUseCase
		}
		container.register(GalleryInteractorInput.self) { (r, presenter: GalleryPresenter) in
			let initSession = r.resolve(InitSessionUseCase.self)!
			let getRepositoriesUseCase = r.resolve(GetRepositoriesUseCase.self)!
			let interactor = GalleryInteractor(initSessionUC: initSession, getRepositoriesUC: getRepositoriesUseCase)
			interactor.output = presenter
			
			return interactor
		}
		
		container.register(GalleryRouterInput.self) { (r, viewController: GalleryViewController) in
			let router = GalleryRouter(transitionHandler: viewController)
			
			return router
		}
		
		container.register(GalleryViewOutput.self) { (r, view: GalleryViewController) in
			let router = r.resolve(GalleryRouterInput.self, argument: view)!
			let presenter = GalleryPresenter(view:view, router: router)
			presenter.interactor = r.resolve(GalleryInteractorInput.self, argument: presenter)
			
			return presenter
		}
		
		container.storyboardInitCompleted(GalleryViewController.self) {r, viewController in
			viewController.output = r.resolve(GalleryViewOutput.self, argument: viewController)
		}
	}
}

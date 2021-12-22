//
//  GalleryInteractor.swift
//  netquest
//
//  Created by Jorge Sanmartin on 20/12/21.
//

final class GalleryInteractor{
	
	weak var output : GalleryInteractorOutput!
	
	fileprivate final let getRepositoriesUC : GetRepositoriesUseCase
	fileprivate final let initSessionUC : InitSessionUseCase
	
	init(initSessionUC : InitSessionUseCase, getRepositoriesUC : GetRepositoriesUseCase){
		self.initSessionUC = initSessionUC
		self.getRepositoriesUC = getRepositoriesUC
	}
}

extension GalleryInteractor : GalleryInteractorInput{
	
	func initSession(){
		initSessionUC.build().subscribe {[weak self] _ in
			self?.output.initSessionSuccess()
		} onError: {[weak self]  error in
			self?.output.initSessionError(error)
		}
	}
	
	func getRepositories(page : Int){
		getRepositoriesUC.setParams(page: page).build().subscribe {[weak self]  dataResponse in
			self?.output.getRepositoriesSuccess(response: dataResponse)
		} onError: {[weak self]  error in
			self?.output.getRepositoriesError(error)
		}
	}
}

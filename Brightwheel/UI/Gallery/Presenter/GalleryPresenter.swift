//
//  GalleryPresenter.swift
//  Brightwheel
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import Foundation

final class GalleryPresenter{
	
	fileprivate let maxCountRepositories = 100
	
	fileprivate weak final var view: GalleryViewInput!
	fileprivate final let router: GalleryRouterInput!
	
	var interactor: GalleryInteractorInput!
	
	fileprivate var repositories : [RepositoryItem] = []
	fileprivate var page : Int = 0
	fileprivate var loading : Bool = false
	
	init(view: GalleryViewInput, router: GalleryRouterInput) {
		self.view = view
		self.router = router
	}
	
	fileprivate	func retrieveMoreItemsIfNeeded(at:Int) {
		if at > abs(repositories.count)/2 && !loading && repositories.count < maxCountRepositories{
			getRepositories()
		}
	}
	
	fileprivate func getRepositories(){
		self.loading = true
		interactor.getRepositories(page: self.page)
	}
}

extension GalleryPresenter : GalleryViewOutput{
	
	func initData(){
		interactor.initSession()
	}
	
	func clearAndReload(){
		self.page = 0
		repositories.removeAll()
		view.reloadData()
		getRepositories()
	}
}

extension GalleryPresenter : DataSource{
	
	func getItemCount() -> Int {
		return repositories.count
	}
	
	func getItem(at: Int) -> (title : String, views : String, image : String){
		
		retrieveMoreItemsIfNeeded(at: at)
		
		let item = repositories[at]
		
		let title = item.name
		let views = item.contributors.count > 0 ? item.contributors[0].login : "empty_contributors".localized
		let link =  item.contributors.count > 0 ? item.contributors[0].avatar_url : item.owner.avatar_url
		
		return (title, views, link)
	}
}

extension GalleryPresenter : GalleryInteractorOutput{
	
	func initSessionSuccess() {
		getRepositories()
	}
	
	func initSessionError(_ error: Error){
		view.showError(message: "error_loading".localized)
	}
	
	func getRepositoriesSuccess(response: GitHubResponse) {
		if !response.items!.isEmpty{
			self.page += 1
			self.loading = false
			if repositories.isEmpty{
				repositories.append(contentsOf: response.items!)
				view.reloadData()
				view.endRefreshing()
			}else{
				let from = repositories.count
				repositories.append(contentsOf:response.items!)
				let to = repositories.count - 1
				if to > from{
					view.insertItems(from: from, to: to)
				}
			}
		}
	}
	
	func getRepositoriesError(_ error: Error) {
		self.loading = false
		view.endRefreshing()
		view.showError(message: "error_loading".localized)
	}
}

//
//  GetRepositories.swift
//  Brightwheel
//
//  Created by Jorge Sanmartin on 21/12/21.
//

import RxSwift

protocol GetRepositoriesUseCase: AnyObject{
	func build()->BaseUseCase<GitHubResponse>
	func setParams(page : Int) -> GetRepositoriesUseCase
}

final class GetRepositories : BaseUseCase<GitHubResponse>, GetRepositoriesUseCase{
	
	private var page : Int!
	
	override func buildUseCaseObservable() -> Observable<GitHubResponse>? {
		return proxyService!.repository().getRepositories(page: page)?.flatMap({ dataResponse -> Observable<GitHubResponse> in
			
			// TODO: Get contributors for each repository
			let item = dataResponse.items?.map({ repo -> Observable<RepositoryItem>  in
				var newRepo = repo
				return self.proxyService!.repository().getContributors(owner: repo.owner.login, repo: repo.name)!.map({ contributors -> RepositoryItem in
					newRepo.contributors = contributors
					return newRepo
				}).catchAndReturn(
					// TODO: The history or contributor list is too large to list contributors for this repository via the API.
					repo
				)
			})
			
			// TODO: Return GitHubResponse with contributors
			return Observable.zip(item!).flatMap { repos -> Observable<GitHubResponse> in
				var newResponse = dataResponse
				newResponse.items = repos
				return Observable.just(newResponse)
			}
		})
	}
	
	func setParams(page: Int) -> GetRepositoriesUseCase {
		self.page = page
		return self
	}
}

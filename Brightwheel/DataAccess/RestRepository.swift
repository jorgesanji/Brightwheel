//
//  RestRepository.swift
//  Brightwheel
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import RxSwift
import Moya
import Alamofire

final class RestRepository{
	
	fileprivate var provider:MoyaProvider<BrightwheelServices>!
	fileprivate final let localPrivateStore: LocalDataPrivate
	fileprivate var authPlugin: AccessTokenPlugin!
	
	init(localPrivateStore: LocalDataPrivate) {
		self.localPrivateStore = localPrivateStore
		self.addoAuth(false)
	}
	
	private func addoAuth(_ oAuth : Bool){
		var plugins : [PluginType] = []
		plugins.append(NetworkLoggerPlugin())
		if oAuth{
			// TODO: Add oauth to alamofire manager
			self.authPlugin = AccessTokenPlugin(tokenClosure: {[weak self] TargetType in
				return self?.localPrivateStore.getAccessToken() ?? ""
			})
			plugins.append(authPlugin)
		}
		self.provider = MoyaProvider<BrightwheelServices>(
			session: Alamofire.Session.manager(interceptor: nil),
			plugins: plugins)
	}
}

extension RestRepository : RestRepositoryService{
	
	func getRepositories(page: Int) -> Observable<GitHubResponse>? {
		return provider.rx
			.request(.getRepositories(page: page))
			.filterSuccessfulStatusAndRedirectCodes()
			.map(GitHubResponse.self)
			.asObservable()
	}
	
	func getContributors(owner : String, repo : String) -> Observable<[Contributor]>?{
		return provider.rx
			.request(.getContributors(owner: owner, repo: repo))
			.filterSuccessfulStatusAndRedirectCodes()
			.map([Contributor].self)
			.asObservable()
	}
}

extension Alamofire.Session{
	
	private static let REQUEST_TIME_OUT:TimeInterval = 150.0
	private static let RESOURCE_TIME_OUT:TimeInterval = 150.0
	
	static func manager(interceptor: RequestInterceptor?) -> Alamofire.Session{
		let configuration = URLSessionConfiguration.af.default
		configuration.timeoutIntervalForRequest = REQUEST_TIME_OUT
		configuration.timeoutIntervalForResource = RESOURCE_TIME_OUT
		let sessionManager = Alamofire.Session(configuration: configuration, interceptor: interceptor)
		return sessionManager
	}
}

enum HttpCodes: Int {
	case HTTP_UNAUTHORIZED = 401
	case HTTP_INTERNAL_SERVER = 500
	case HTTP_INTERNET_ERROR = 1009
}

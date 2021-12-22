//
//  RestRepository.swift
//  netquest
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import RxSwift
import Moya
import Alamofire

final class RestRepository{
	
	fileprivate final let provider:MoyaProvider<BrightwheelServices>
	fileprivate final let localPrivateStore: LocalDataPrivate
	fileprivate var retryPolicyHandler: RetryPolicyHandler!
	fileprivate var authPlugin: AccessTokenPlugin!
	
	// "Authorization: token ghp_16C7e42F292c6912E7710c838347Ae178B4a"

	init(localPrivateStore: LocalDataPrivate) {
		self.localPrivateStore = localPrivateStore
		self.retryPolicyHandler = RetryPolicyHandler()
		
		self.authPlugin = AccessTokenPlugin(tokenClosure: { TargetType in
			return localPrivateStore.getAccessToken() ?? ""
		})
		
		self.provider = MoyaProvider<BrightwheelServices>(
			session: Alamofire.Session.manager(interceptor: retryPolicyHandler),
			plugins: [authPlugin, NetworkLoggerPlugin()])
		
		initPolicyHandler()
	}
	
	fileprivate func initPolicyHandler(){
		retryPolicyHandler.oAuthHandler = self
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

extension RestRepository: OAuthHandler{
	
	func renewTokenCredentials() {
		
	}
}

final class RetryPolicyHandler : Alamofire.RequestInterceptor{

	private let DELAY_TIME_TO_RETRY:TimeInterval = 5.0
	
	weak var oAuthHandler: OAuthHandler?
	private var status:Status = .WORKING

	func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
		if  let error = error as? AFError{
			if error.responseCode == HttpCodes.HTTP_UNAUTHORIZED.rawValue{
				if status != .UPDATING {
					self.status = .UPDATING
					oAuthHandler?.renewTokenCredentials()
				}
				completion(.retryWithDelay(DELAY_TIME_TO_RETRY))
			}else{
				completion(.doNotRetry)
			}
		}else{
			completion(.doNotRetry)
		}
	}
	
	func tokenUpdatingDone(){
		self.status = .WORKING
	}
}

extension Alamofire.Session{
	
	private static let REQUEST_TIME_OUT:TimeInterval = 150.0
	private static let RESOURCE_TIME_OUT:TimeInterval = 150.0
	
	static func manager(interceptor: RetryPolicyHandler) -> Alamofire.Session{
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

enum Status : Int{
	case UPDATING = 1
	case WORKING = 2
}

protocol OAuthHandler: AnyObject {
	func renewTokenCredentials()
}

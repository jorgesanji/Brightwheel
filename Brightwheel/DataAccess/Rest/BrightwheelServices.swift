//
//  BrightwheelServices.swift
//  netquest
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import Foundation
import Moya

enum BrightwheelServices {
	case getContributors(owner : String, repo : String)
	case getRepositories(page : Int)
}

extension BrightwheelServices: TargetType{
		
	var baseURL: URL {
		let path = "https://api.github.com"

		guard let url = URL(string: path) else { fatalError("baseURL could not be configured") }
		return url
	}
	
	var path: String {
		switch self {
		case .getRepositories:
			return "/search/repositories"
		case .getContributors(let owner, let repo):
			return "/repos/\(owner)/\(repo)/contributors"
		}
	}
	
	var method: Moya.Method {
		switch self {
		case .getRepositories, .getContributors:
			return .get
		}
	}
	
	var sampleData: Data {
		switch self {
		case .getRepositories, .getContributors:
			return Data()
		}
	}
	
	var task: Task {
		switch self {
		case .getRepositories(let page):
			return .requestParameters(parameters: ["q": "stars:>0", "sort": "stars", "order": "desc", "page": page, "per_page": "20"], encoding: URLEncoding.queryString)
		case .getContributors:
			return .requestParameters(parameters: ["per_page": "1"], encoding: URLEncoding.queryString)
		}
	}
	
	var headers: [String : String]? {
		let headers:[String:String] = [:]
		return headers
	}
	
	var validationType: ValidationType {
		return .successCodes
	}
	
	var parameterEncoding: ParameterEncoding {
		switch self {
		case .getRepositories, .getContributors:
			return JSONEncoding()
		}
	}
}

extension BrightwheelServices : AccessTokenAuthorizable{
	
	var authorizationType: AuthorizationType?{
		switch self {
		case .getRepositories, .getContributors:
			return .custom("token")
		}
	}
}

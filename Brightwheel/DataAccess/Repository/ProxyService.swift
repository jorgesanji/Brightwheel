//
//  ProxyService.swift
//  Brightwheel
//
//  Created by Jorge Sanmartin on 20/12/21.
//

protocol ProxyService: AnyObject {
	func localRepository() -> Repository
	func repository() -> Repository
	func repository(_ type : RepositoryType) -> Repository
}

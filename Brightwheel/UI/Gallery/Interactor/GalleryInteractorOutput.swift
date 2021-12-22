//
//  GalleryInteractorOutput.swift
//  netquest
//
//  Created by Jorge Sanmartin on 20/12/21.
//

protocol GalleryInteractorOutput : AnyObject {
	func initSessionSuccess()
	func initSessionError(_ error: Error)
	func getRepositoriesSuccess(response:GitHubResponse)
	func getRepositoriesError(_ error: Error)
}

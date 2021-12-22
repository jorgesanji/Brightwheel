//
//  GalleryInteractorInput.swift
//  Brightwheel
//
//  Created by Jorge Sanmartin on 20/12/21.
//

protocol GalleryInteractorInput : AnyObject {
	func initSession()
	func getRepositories(page : Int)
}

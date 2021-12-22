//
//  GalleryViewInput.swift
//  Brightwheel
//
//  Created by Jorge Sanmartin on 20/12/21.
//

protocol GalleryViewInput : AnyObject {
	func reloadData()
	func endRefreshing()
	func insertItems(from : Int, to : Int)
	func showError(message: String)
}

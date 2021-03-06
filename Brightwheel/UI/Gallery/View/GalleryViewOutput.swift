//
//  GalleryViewOutput.swift
//  Brightwheel
//
//  Created by Jorge Sanmartin on 20/12/21.
//

protocol DataSource : AnyObject{
	func getItemCount() -> Int
	func getItem(at: Int) -> (title : String, contributorName : String, image : String)
}

protocol GalleryViewOutput : DataSource {
	func initData()
	func clearAndReload()
}

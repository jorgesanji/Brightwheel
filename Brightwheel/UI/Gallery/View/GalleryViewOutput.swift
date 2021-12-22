//
//  GalleryViewOutput.swift
//  netquest
//
//  Created by Jorge Sanmartin on 20/12/21.
//

protocol DataSource : AnyObject{
	func getItemCount() -> Int
	func getItem(at: Int) -> (title : String, views : String, image : String)
}

protocol GalleryViewOutput : DataSource {
	func initData()
	func clearAndReload()
}

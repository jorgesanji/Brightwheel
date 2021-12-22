//
//  GalleryViewController.swift
//  netquest
//
//  Created by Jorge Sanmartin on 19/12/21.
//

import UIKit
import SwiftMessages

final class GalleryViewController: UIViewController {
	
	var output : GalleryViewOutput!
	
	private let SPACE_BETWEEN_ITEMS : CGFloat = 20.0
	
	fileprivate var config:SwiftMessages.Config{
		var config = SwiftMessages.Config()
		config.presentationStyle = .top
		config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
		config.dimMode = .color(color: .clear , interactive: true)
		config.interactiveHide = true
		config.preferredStatusBarStyle = .lightContent
		return config
	}
	
	@IBOutlet fileprivate weak var collectionView : UICollectionView!
	private let refreshControl = UIRefreshControl()
	
	private func initUI(){
		self.navigationItem.title = "title_controller".localized
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.contentInset = UIEdgeInsets(top: SPACE_BETWEEN_ITEMS, left: SPACE_BETWEEN_ITEMS, bottom: SPACE_BETWEEN_ITEMS, right: SPACE_BETWEEN_ITEMS)
		
		refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
		collectionView.addSubview(refreshControl)
		
		collectionView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
		
		let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshButton(_:)))
		self.navigationItem.rightBarButtonItem = refreshButton
	}
	
	@objc private func refresh(_ sender: AnyObject) {
		output.clearAndReload()
	}
	
	@objc private func refreshButton(_ sender: AnyObject) {
		refreshControl.beginRefreshing()
		output.clearAndReload()
	}
	
	private func loadData(){
		refreshControl.beginRefreshing()
		output.initData()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		initUI()
		loadData()
	}
	
	private func showMessage(title:String, message:String, theme:Theme){
		let view = MessageView.viewFromNib(layout: .cardView)
		view.button?.isHidden = true
		view.configureDropShadow()
		view.configureTheme(theme)
		view.configureContent(title: title, body: message)
		SwiftMessages.show(config: config, view: view)
	}
}

extension GalleryViewController : UICollectionViewDataSource{
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return output.getItemCount()
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryItemCell.reuseIdentifier, for: indexPath as IndexPath) as! GalleryItemCell
		
		let item = output.getItem(at: indexPath.row)
		cell.title = item.title
		cell.views = item.views
		cell.image = item.image
		return cell
	}
}

extension GalleryViewController : UICollectionViewDelegateFlowLayout{
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		var collectionViewSize = collectionView.bounds.size
		let width = collectionView.frame.width - (SPACE_BETWEEN_ITEMS * 2)
		collectionViewSize.width = width
		collectionViewSize.height = 120
		return collectionViewSize
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return SPACE_BETWEEN_ITEMS
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return SPACE_BETWEEN_ITEMS
	}
}

extension GalleryViewController : GalleryViewInput{
	
	func endRefreshing() {
		refreshControl.endRefreshing()
	}
	
	func reloadData() {
		collectionView.reloadData()
	}
	
	func insertItems(from : Int, to : Int){
		var indexArray = [IndexPath]()
		for index in from...to {
			indexArray.append(IndexPath(row: index, section: 0))
		}
		collectionView.insertItems(at: indexArray)
	}
	
	func showError(message: String) {
		showMessage(title:"app_name".localized, message:message, theme:.error)
	}
}

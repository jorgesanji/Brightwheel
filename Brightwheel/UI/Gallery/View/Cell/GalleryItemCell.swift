//
//  GalleryItemCell.swift
//  Brightwheel
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import UIKit

class GalleryItemCell : UICollectionViewCell{
	
	private let cornerRadius: CGFloat = 5.0

	static let reuseIdentifier = "GalleryItemCell"
	
	var title : String?{
		didSet{
			titleLabel.text = title
		}
	}
	
	var views : String?{
		didSet{
			viewsLabel.text = views
		}
	}
	
	var image : String?{
		didSet{
			imageView.loadFromUrl(image)
		}
	}
	
	@IBOutlet private weak var titleLabel : UILabel!
	@IBOutlet private weak var imageView : UIImageView!
	@IBOutlet private weak var viewsLabel : UILabel!
	
	private var gradientLayer : CAGradientLayer!

	override func layoutSubviews() {
		// Improve scrolling performance with an explicit shadowPath
		layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
	}
		
	override func awakeFromNib() {
		// Apply rounded corners to contentView
		contentView.layer.cornerRadius = cornerRadius
		contentView.layer.masksToBounds = true
				
		// Set masks to bounds to false to avoid the shadow
		// from being clipped to the corner radius
		layer.cornerRadius = cornerRadius
		layer.masksToBounds = false
				
		// Apply a shadow
		layer.shadowRadius = 8.0
		layer.shadowOpacity = 0.10
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = CGSize(width: 0, height: 5)
	}
}

//
//  GalleryRouter.swift
//  Brightwheel
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import UIKit

final class GalleryRouter{
	weak var transitionHandler: UIViewController!
	
	init(transitionHandler: UIViewController) {
		self.transitionHandler = transitionHandler
	}
}

extension GalleryRouter: GalleryRouterInput{
	
}

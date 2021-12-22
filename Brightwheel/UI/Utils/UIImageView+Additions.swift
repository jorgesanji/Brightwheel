//
//  UIImageView+Additions.swift
//  netquest
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import UIKit
import Kingfisher

extension UIImageView {
	
	public func loadFromUrl(_ url:String?){
		guard url != nil else{ return }
				
		let url = URL(string: url!)
		let processor = DownsamplingImageProcessor(size: self.bounds.size)
		//let processor = DownsamplingImageProcessor(size: self.bounds.size)
			//		 |> RoundCornerImageProcessor(cornerRadius: 20)
		self.kf.indicatorType = .activity
		self.kf.setImage(
			with: url,
			placeholder: UIImage(named: "placeholderImage"),
			options: [
				.processor(processor),
				.loadDiskFileSynchronously,
				.scaleFactor(UIScreen.main.scale),
				.transition(.fade(0.25)),
				.cacheOriginalImage
			])
		{
			result in
			switch result {
			case .success(let value):
				print("Task done for: \(value.source.url?.absoluteString ?? "")")
			case .failure(let error):
				print("Job failed: \(error.localizedDescription)")
			}
		}
	}
}

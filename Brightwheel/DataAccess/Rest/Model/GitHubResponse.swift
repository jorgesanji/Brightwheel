//
//  GitHubResponse.swift
//  Brightwheel
//
//  Created by Jorge Sanmartin on 21/12/21.
//

import Foundation

struct GitHubResponse : Hashable, Codable{
	
	var total_count : Int?
	var incomplete_results : Bool =  false
	var items : [RepositoryItem]?
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.total_count = try container.decodeIfPresent(Int.self, forKey: .total_count)
		self.incomplete_results = try container.decodeIfPresent(Bool.self, forKey: .incomplete_results) ?? false
		self.items = try container.decodeIfPresent([RepositoryItem].self, forKey: .items)
	}
}


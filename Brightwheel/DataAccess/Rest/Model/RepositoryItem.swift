//
//  RepositoryItem.swift
//  Brightwheel
//
//  Created by Jorge Sanmartin on 21/12/21.
//

import Foundation

struct RepositoryItem : Hashable, Codable{
	
	var id : Int64
	var name : String
	var full_name : String
	var description : String
	var owner : Owner
	var html_url : String
	var contributors : [Contributor] = []
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(Int64.self, forKey: .id)
		self.name = try container.decode(String.self, forKey: .name)
		self.full_name = try container.decode(String.self, forKey: .full_name)
		self.description = try container.decode(String.self, forKey: .description)
		self.owner = try container.decode(Owner.self, forKey: .owner)
		self.html_url = try container.decode(String.self, forKey: .html_url)
	}
}


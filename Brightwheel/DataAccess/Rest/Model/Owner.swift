//
//  Owner.swift
//  Brightwheel
//
//  Created by Jorge Sanmartin on 21/12/21.
//

import Foundation

struct Owner : Hashable, Codable{
	
	var id : Int64
	var login : String
	var avatar_url : String
	var html_url : String
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.id = try container.decode(Int64.self, forKey: .id)
		self.login = try container.decode(String.self, forKey: .login)
		self.avatar_url = try container.decode(String.self, forKey: .avatar_url)
		self.html_url = try container.decode(String.self, forKey: .html_url)
	}
}

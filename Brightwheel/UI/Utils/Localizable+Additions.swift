//
//  Localizable+Additions.swift
//  netquest
//
//  Created by Jorge Sanmartin on 21/12/21.
//

import Foundation

extension String {
	
	var localized: String {
		return NSLocalizedString(self, comment:"")
	}
	
	public func localized(with arguments: [CVarArg]) -> String {
		   return String(format: self.localized, locale: nil, arguments: arguments)
	}
}

extension Double {
	
	var kmFormatted: String {

		if self >= 10000, self <= 999999 {
			return String(format: "%.1fK", locale: Locale.current,self/1000).replacingOccurrences(of: ".0", with: "")
		}

		if self > 999999 {
			return String(format: "%.1fM", locale: Locale.current,self/1000000).replacingOccurrences(of: ".0", with: "")
		}

		return String(format: "%.0f", locale: Locale.current,self)
	}
}

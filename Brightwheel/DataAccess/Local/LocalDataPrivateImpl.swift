//
//  LocalDataPrivateImpl.swift
//  netquest
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import KeychainSwift

protocol LocalDataPrivate: AnyObject{
	func getAccessToken() -> String?
	func clearData()
	func sanitizingSession()
}

final class LocalDataPrivateImpl{
	
	enum LocalDataPrivateKey: String {
		case access_token
	}
	
	let keychain = KeychainSwift()
	
	private func get(key:LocalDataPrivateKey) ->Data?{
		if let value = keychain.getData(key.rawValue) {
			return value
		}
		return nil
	}
	
	private func get(key:LocalDataPrivateKey) ->String?{
		if let value = keychain.get(key.rawValue) {
			return value
		}
		return nil
	}
	
	private func set(_ value:String, key:LocalDataPrivateKey)-> Bool{
		return keychain.set(value, forKey: key.rawValue, withAccess:.accessibleAfterFirstUnlock)
	}
	
	private func set(_ value:Data, key:LocalDataPrivateKey)-> Bool{
		return keychain.set(value, forKey: key.rawValue, withAccess:.accessibleAfterFirstUnlock)
	}
}

extension LocalDataPrivateImpl: LocalDataPrivate{
	
	func getAccessToken() -> String? {
		get(key: .access_token)
	}
	
	func clearData() {
		keychain.clear()
	}
	
	func sanitizingSession() {
		if !UserDefaults.standard.appFirstTimeLaunch{
			
			clearData()
			UserDefaults.standard.appFirstTimeLaunch = true
			
			let credentials = PlistHelper.readPlist()
			_ = set(credentials, key: .access_token)
		}
	}
}

extension UserDefaults {
	
	enum UserDefaultsKey: String {
		case appFirstTimeLaunch
	}
	
	// MARK: - Utility
	
	func setValue(_ value: Any?, forKey key: UserDefaultsKey) {
		setValue(value, forKey: key.rawValue)
	}
	
	func value(forKey key: UserDefaultsKey) -> Any? {
		return value(forKey: key.rawValue)
	}
	
	var appFirstTimeLaunch : Bool {
		get {
			return (value(forKey: .appFirstTimeLaunch) as? Bool) ?? false
		}
		set(newVal) {
			setValue(newVal, forKey: .appFirstTimeLaunch)
		}
	}
}

//
//  ApplicationAssembly.swift
//  netquest
//
//  Created by Jorge Sanmartin on 20/12/21.
//

import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
	
	final class ApplicationAssembly {
		
		class var assembler: Assembler {
			
			let assemblies:[Assembly] = [
				CommonAssemblyContainer(),
				GalleryAssemblyContainer()
			]
					
			return Assembler(assemblies)
		}
	}
	
	@objc class func setup() {
		defaultContainer = ApplicationAssembly.assembler.resolver as! Container
	}
	
	class func controllerFromStoryBoard<C:UIViewController>(name:String, _ controllerClass:C.Type) -> C{
		let slotMachineStoryboard = SwinjectStoryboard.create(name: name, bundle: nil, container: defaultContainer)
		return slotMachineStoryboard.instantiateViewController(withIdentifier:String(describing: controllerClass.self)) as! C
	}
}

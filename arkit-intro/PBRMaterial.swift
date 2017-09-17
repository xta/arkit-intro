//
//  PBRMaterial.swift
//  arkit-intro
//
//  Created by Rex on 9/16/17.
//  Copyright © 2017 Edu. All rights reserved.
//

import UIKit
import SceneKit

// based on https://github.com/markdaws/arkit-by-example

var materials: [String:SCNMaterial] = [:]

class PBRMaterial: NSObject {
    class func materialNamed(name: String) -> SCNMaterial {
        var mat = materials[name]
        if let mat = mat {
            return mat
        }
        
        mat = SCNMaterial()
        mat!.lightingModel = SCNMaterial.LightingModel.physicallyBased
        
        let imageName = "\(name)-albedo"
        let image = UIImage(named: imageName)
        mat!.diffuse.contents = image
        mat!.diffuse.wrapS = SCNWrapMode.repeat
        mat!.diffuse.wrapT = SCNWrapMode.repeat
        
        materials[name] = mat
        return mat!
    }
}

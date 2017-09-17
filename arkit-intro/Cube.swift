//
//  Cube.swift
//  arkit-intro
//
//  Created by Rex on 9/17/17.
//  Copyright © 2017 Edu. All rights reserved.
//

import UIKit
import ARKit

// based on https://github.com/markdaws/arkit-by-example

class Cube: SCNNode {
    init(_ position: SCNVector3, with material: SCNMaterial) {
        super.init()
        
        let dimension: Float = 0.2
        let cube = SCNBox(width: CGFloat(dimension), height: CGFloat(dimension), length: CGFloat(dimension), chamferRadius: 0)
        cube.materials = [material]
        let node = SCNNode(geometry: cube)
        
        // The physicsBody tells SceneKit this geometry should be manipulated by the physics engine
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        node.physicsBody?.mass = 2.0
        node.position = position
        
        self.addChildNode(node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func currentMaterial() -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(white: 1.0, alpha: 1.0)
        material.lightingModel = .physicallyBased
        return material
    }
    
}

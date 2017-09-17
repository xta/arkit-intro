//
//  Bullet.swift
//  arkit-intro
//
//  Created by Rex on 9/17/17.
//  Copyright © 2017 Edu. All rights reserved.
//

import UIKit
import SceneKit

// based on https://github.com/farice/ARShooter

class Bullet: SCNNode {
    override init () {
        super.init()
        let sphere = SCNSphere(radius: 0.025)
        self.geometry = sphere
        let shape = SCNPhysicsShape(geometry: sphere, options: nil)
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        self.physicsBody?.isAffectedByGravity = false
        
        // add texture
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.yellow
        self.geometry?.materials  = [material]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

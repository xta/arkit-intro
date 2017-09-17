//
//  ViewController+ARSCNViewDelegate.swift
//  arkit-intro
//
//  Created by Rex on 9/16/17.
//  Copyright © 2017 Edu. All rights reserved.
//

import ARKit

extension ViewController: ARSCNViewDelegate {
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let anchor = anchor as? ARPlaneAnchor else { return }

        // When a new plane is detected we create a new SceneKit plane to visualize it in 3D
        let plane = Plane(anchor: anchor, isHidden: false, withMaterial: Plane.currentMaterial()!)
        self.planes[anchor] = plane
        node.addChildNode(plane)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let anchor = anchor as? ARPlaneAnchor else { return }
        
        if let plane = self.planes[anchor] {
            plane.update(anchor: anchor)
        }
    }

    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let anchor = anchor as? ARPlaneAnchor else { return }
        self.planes.removeValue(forKey: anchor)
    }

}


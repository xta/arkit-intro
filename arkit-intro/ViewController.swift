//
//  ViewController.swift
//  arkit-intro
//
//  Created by Rex on 9/16/17.
//  Copyright © 2017 Edu. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    var planes: [ARPlaneAnchor:Plane] = [:]
    var cubes: [Cube] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Stop the screen from dimming while we are using the app
        UIApplication.shared.isIdleTimerDisabled = true
        
        setupRecognizers()
    }
    
    let standardConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        return configuration
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Run the view's session
        sceneView.session.run(standardConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - Gesture(s)
    
    func setupRecognizers() {
        // Single tap will insert a new piece of geometry into the scene
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(insertCubeFrom))
        tapGestureRecognizer.numberOfTapsRequired = 1
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func insertCubeFrom(recognizer: UITapGestureRecognizer) {
        // Take the screen space tap coordinates and pass them to the hitTest method on the ARSCNView instance
        let tapPoint = recognizer.location(in: self.sceneView)
        let result = self.sceneView.hitTest(tapPoint, types: ARHitTestResult.ResultType.existingPlaneUsingExtent)
        
        // If the intersection ray passes through any plane geometry they will be returned, with the planes
        // ordered by distance from the camera
        if result.count == 0 {
            return
        }
        
        // If there are multiple hits, just pick the closest plane
        let hitResult = result.first
        self.insertCube(hitResult: hitResult!)
    }
    
    
    func insertCube(hitResult: ARHitTestResult) {
        // We insert the geometry slightly above the point the user tapped, so that it drops onto the plane
        // using the physics engine
        let insertionYOffset: Float = 0.5
        let position = SCNVector3Make(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y.advanced(by: insertionYOffset), hitResult.worldTransform.columns.3.z)
        
        let cube = Cube.init(position, with: Cube.currentMaterial())
        self.cubes.append(cube)
        self.sceneView.scene.rootNode.addChildNode(cube)
    }

}

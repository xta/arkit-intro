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
        setupUI()
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
    
    // MARK: - UI
    
    let regularFont = "Helvetica-Light"
    let buttonTextColor = UIColor.white
    let buttonBGColor = UIColor(red:0.00, green:0.45, blue:0.85, alpha:1.0) // blue #0074D9
    let buttonBGHighlightColor = UIColor.blue
    
    func setupUI() {
        // shoot button
        let button = UIButton()
        let height = view.bounds.height
        
        let text = "Shoot"
        button.setTitle(text, for: [])
        button.titleLabel?.font = UIFont(name: regularFont, size: height/24)
        button.setTitleColor(buttonTextColor, for: [])
        
        button.backgroundColor = buttonBGColor
        button.setBackgroundColor(color: buttonBGColor, forState: .normal)
        button.setBackgroundColor(color: buttonBGHighlightColor, forState: .highlighted)
        
        button.titleLabel?.textAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        
        self.view.addSubview(button)
        
        let guide = view.safeAreaLayoutGuide
        button.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -34).isActive = true
        button.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/10).isActive = true
        button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        button.addTarget(self, action: #selector(self.shootPressed(_:)), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
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
    
    // fire bullet in direction camera is facing
    @objc func shootPressed(_ sender: UIButton) {
        let bulletsNode = Bullet()
        
        let (direction, position) = self.getUserVector()
        bulletsNode.position = position
        
        let bulletDirection = direction
        bulletsNode.physicsBody?.applyForce(bulletDirection, asImpulse: true)
        sceneView.scene.rootNode.addChildNode(bulletsNode)
    }
    
    // MARK: - Helpers
    
    func getUserVector() -> (SCNVector3, SCNVector3) { // (direction, position)
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform) // 4x4 transform matrix describing camera in world space
            let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33) // orientation of camera in world space
            let pos = SCNVector3(mat.m41, mat.m42, mat.m43) // location of camera in world space
            
            return (dir, pos)
        }
        return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
    }
    
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
}

//
//  MixedRealityView.swift
//  MRKit
//
//  Created by Scott Finkelstein on 9/1/17.
//  Copyright © 2017 Scott Finkelstein. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MixedRealityKit: ARSCNView, ARSessionDelegate, ARSCNViewDelegate {
    
    private var cameraTransform:matrix_float4x4?
    private var cameraNode:SCNNode?
    
    public var disableSleepMode:Bool = true {
        willSet(newValue) {
            print("value will change to \(newValue)")
            
        }
        
        didSet {
            if disableSleepMode == true {
                UIApplication.shared.isIdleTimerDisabled = true
            }else {
                UIApplication.shared.isIdleTimerDisabled = false
            }
        }
    }
    
    override var scene: SCNScene {
        didSet {
            setupMainCamera()
            stereoSplit()
        }
    }
    
    public override init(frame: CGRect, options: [String: Any]? = nil) {
        super.init(frame: frame, options: options)
        
        delegate = self
        session.delegate = self
        
        showsStatistics = true
    }
    
    public func runSession() {
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        session.run(configuration)
    }
    
    public func pauseSession() {
        session.pause()
    }
    
    public func addNode(node:SCNNode) {
        scene.rootNode.addChildNode(node)
    }
    
    private func setupMainCamera() {
        
        cameraNode=SCNNode()
        cameraNode?.camera=SCNCamera()
        cameraNode?.position=SCNVector3(0, 0, 0)
        scene.rootNode.addChildNode(cameraNode!)
    }
    
    private func stereoSplit() {
        
        // Set up left & Right SCNCameraNodes & SCNSceneView's which mirror the main (single-view) instances.
        
        let cameraNodeLeft=SCNNode()
        cameraNodeLeft.camera=SCNCamera()
        cameraNodeLeft.camera?.zNear = 0.001
        cameraNodeLeft.position=SCNVector3(-0.05, 0, 0)
        cameraNode?.addChildNode(cameraNodeLeft)
        
        let cameraNodeRight=SCNNode()
        cameraNodeRight.camera=SCNCamera()
        cameraNodeRight.camera?.zNear = 0.001
        cameraNodeRight.position=SCNVector3(0.05, 0, 0)
        cameraNode?.addChildNode(cameraNodeRight)
        
        let sceneViewLeft=SCNView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width * 0.5, height: self.frame.size.height))
        sceneViewLeft.pointOfView=cameraNodeLeft
        sceneViewLeft.scene=scene
        
        self.addSubview(sceneViewLeft)
        
        let sceneViewRight=SCNView(frame: CGRect(x: self.frame.size.width * 0.5, y: 0, width: self.frame.size.width * 0.5, height: self.frame.size.height))
        sceneViewRight.pointOfView=cameraNodeRight
        sceneViewRight.scene=scene
        
        self.addSubview(sceneViewRight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Session Delegate
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        cameraTransform=frame.camera.transform
        cameraNode?.transform=SCNMatrix4(cameraTransform!)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }

}

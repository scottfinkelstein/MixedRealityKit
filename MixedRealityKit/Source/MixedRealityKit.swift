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

public protocol MixedRealityDelegate: class {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval)
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor)
    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor)
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor)
    
    func session(_ session: ARSession, didUpdate frame: ARFrame)
    func session(_ session: ARSession, didFailWithError error: Error)
    func sessionWasInterrupted(_ session: ARSession)
    func sessionInterruptionEnded(_ session: ARSession)
    
}

extension MixedRealityDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) { }
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) { }
    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) { }
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) { }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) { }
    func session(_ session: ARSession, didFailWithError error: Error) { }
    func sessionWasInterrupted(_ session: ARSession) { }
    func sessionInterruptionEnded(_ session: ARSession) { }
}

public class MixedRealityKit: ARSCNView, ARSessionDelegate, ARSCNViewDelegate {
    
    private var cameraTransform:matrix_float4x4?
    private var cameraNode:SCNNode?
    
    public weak var mixedRealityDelegate:MixedRealityDelegate?
    
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
    
    override public var scene: SCNScene {
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
    
    public func runSession(detectPlanes: Bool) {
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        if detectPlanes == true {
            configuration.planeDetection = .horizontal
        }
        
        // Run the view's session
        session.run(configuration)
    }
    
    public func runSession() {
        runSession(detectPlanes: false)
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
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Session Delegate
    
    public func session(_ session: ARSession, didUpdate frame: ARFrame) {
        cameraTransform=frame.camera.transform
        cameraNode?.transform=SCNMatrix4(cameraTransform!)
        
        guard let mixedRealityDelegate = mixedRealityDelegate else { return }
        mixedRealityDelegate.session(session, didUpdate: frame)
    }
    
    public func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
        guard let mixedRealityDelegate = mixedRealityDelegate else { return }
        mixedRealityDelegate.session(session, didFailWithError: error)
        
    }
    
    public func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
        guard let mixedRealityDelegate = mixedRealityDelegate else { return }
        mixedRealityDelegate.sessionWasInterrupted(session)
    }
    
    public func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
        guard let mixedRealityDelegate = mixedRealityDelegate else { return }
        mixedRealityDelegate.sessionInterruptionEnded(session)
    }
    

    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let mixedRealityDelegate = mixedRealityDelegate else { return }
        mixedRealityDelegate.renderer(renderer, updateAtTime: time)
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let mixedRealityDelegate = mixedRealityDelegate else { return }
        mixedRealityDelegate.renderer(renderer, didAdd: node, for: anchor)
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let mixedRealityDelegate = mixedRealityDelegate else { return }
        mixedRealityDelegate.renderer(renderer, willUpdate: node, for: anchor)
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let mixedRealityDelegate = mixedRealityDelegate else { return }
        mixedRealityDelegate.renderer(renderer, didRemove: node, for: anchor)
    }
    
}

//
//  ViewController.swift
//  MixedRealityKit
//
//  Created by Scott Finkelstein on 9/2/17.
//  Copyright © 2017 Scott Finkelstein. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, MixedRealityDelegate {

    var sceneView:MixedRealityKit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        sceneView=MixedRealityKit(frame: view.frame)
        sceneView?.mixedRealityDelegate = self
        
        let scene=SCNScene(named: "art.scnassets/Room.scn")!
        sceneView?.scene=scene
        
        view.addSubview(sceneView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView?.runSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView?.pauseSession()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MixedReality Delegates
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
       
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        
    }

}


//
//  ViewController.swift
//  MixedRealityKit
//
//  Created by Scott Finkelstein on 9/2/17.
//  Copyright © 2017 Scott Finkelstein. All rights reserved.
//

import UIKit
import SceneKit

class ViewController: UIViewController {

    var sceneView:MixedRealityKit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        sceneView=MixedRealityKit(frame: view.frame)
        
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


}


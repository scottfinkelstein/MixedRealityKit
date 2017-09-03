#  MixedRealityKit

An easy way to add a stereoscopic ARKit SceneView to your project.

The MixedRealityView class extends ARSCNView and splits camera in two stereoscopic SceneViews. Works with Google Cardboard or any VR Viewer that supports non-barrel distorted VR.

**Virtual Reality Demo (enclosed room scene)**
![Virtual Reality Example](demo1.gif)

**Mixed Reality Demo (viewing virtual objects in the real world)**
![Virtual Reality Example](demo2.gif)



## Setting up a new Project to use MixedRealityKit

1. Add to your podfile:

`pod 'MixedRealityKit'`

2. In Terminal, navigate to your project folder, then:

`pod update`

`pod install`


3. Make sure the **Camera Usage Description** key is set in your info.plist.
4. For best results, uncheck **Portrait** under Device Orientation. Due to some weirdness with the scene flipping upside down, you need both **Landscape Left** and **Landscape Right** checked.

Change your ViewController class to look like the following

```swift
import UIKit
import SceneKit
import MixedRealityKit

class ViewController: UIViewController {

    var sceneView:MixedRealityKit?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        sceneView=MixedRealityKit(frame: view.frame)
        let scene=SCNScene()
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


```

You can use the Room.scn file provided in this repo, or create an empty SCNScene(), adding your own nodes to it. If you are adding a floor to your scene, you will need to play with the y-axis positioning so it matches the relative eye level. I found that -1.7 worked well.

## Options

**disableSleepMode** - (default: _true_): When set to _true_ your device will not go turn off when idle. This can be overridden, but since your device will likely be in a Google Cardboard, you will not want it to go to sleep.

## Author
Scott Finkelstein [Twitter](https://twitter.com/sbf02)

Available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

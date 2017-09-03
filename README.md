#  MixedRealityKit

An easy way to add a stereoscopic ARKit SceneView to your project.

The MixedRealityView class extends ARSCNView and splits camera in two stereoscopic SceneViews. Works with Google Cardboard or any VR Viewer that supports non-barrel distorted VR.

You can easily add MixedRealityKit to your project by adding the following to your Podfile:

'''
pod 'MixedRealityKit'
'''

And running  **pod install**

## Setting up a new Project to use MixedRealityKit

1. Start a new Single View Project (no need to start with an ARKit Template)
2. Make sure the **Camera Usage Description** key is set in your info.plist.
3. For best results, uncheck **Portrait** under Device Orientation. Due to some weirdness with the scene flipping upside down, you need both **Landscape Left** and **Landscape Right** checked.

Change your ViewController class to look like the following

```swift
import UIKit
import SceneKit

class ViewController: UIViewController {

    var mixedRealityView:MixedRealityKit?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        mixedRealityView = MixedRealityKit(frame: view.frame)

        let scene = SCNScene(named: "art.scnassets/Room.scn")!

        mixedRealityView?.scene = scene

        view.addSubview(mixedRealityView!)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        mixedRealityView?.runSession()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        mixedRealityView?.pauseSession()
    }
}

```

You can modify the provided Room.scn file or create an empty SCNScene(), adding your own nodes to it. If you are adding a floor to your scene, you will need to play with the y-axis positioning so it matches the relative eye level. I found that -1.7 worked well.

## Options

**disableSleepMode** - (default: _true_): When set to _true_ your device will not go turn off when idle. This can be overridden, but since your device will likely be in a Google Cardboard, you will not want it to go to sleep.

## Author
Scott Finkelstein [@sbf02](https://twitter.com/sbf02)

Available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

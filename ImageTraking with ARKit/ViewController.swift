//
//  ViewController.swift
//  ImageTraking with ARKit
//
//  Created by user on 01.05.2022.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var pokeScene = SCNScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pocemon and Poltava", bundle: Bundle.main) {
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 1
            print("Images Saccesfuly added")
            
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

  
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor {
            let imagePlane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                                      height: imageAnchor.referenceImage.physicalSize.height)
            imagePlane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            let planeNode = SCNNode(geometry: imagePlane)
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)
            
            guard let imageName = imageAnchor.referenceImage.name else {fatalError()}
            if imageName == "Poltava" {
                pokeScene = SCNScene(named: "art.scnassets/eevee.scn")!
            }
            if imageName == "Cherkasy" {
                pokeScene = SCNScene(named: "art.scnassets/oddish.scn")!
            }
            if let pokeNode = pokeScene.rootNode.childNodes.first {
                pokeNode.eulerAngles.x = .pi / 2
                planeNode.addChildNode(pokeNode)
            }
        }
        
        return node
    }
    
}

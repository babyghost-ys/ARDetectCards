//
//  ViewController.swift
//  ARDetectCards
//
//  Created by Peter Leung on 9/9/2018.
//  Copyright © 2018 Peter Leung. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Update lightning for better detection
        sceneView.automaticallyUpdatesLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startToTrackImages()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //MARK: Function to start to track images
    func startToTrackImages() {
        let configuration = ARImageTrackingConfiguration()
        
        if let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "Cards", bundle: Bundle.main) {
            configuration.trackingImages = trackingImages
            configuration.maximumNumberOfTrackedImages = 2
        }
        
        sceneView.session.run(configuration)
    }
    
    //MARK: AR detection delegate
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let size = imageAnchor.referenceImage.physicalSize
            
            let plane = SCNPlane(width: size.width, height: size.height)
            
            //Detect which card it is
            switch imageAnchor.referenceImage.name {
            case "card1":
                print("card1 detected")
                plane.firstMaterial?.diffuse.contents = UIColor.green.withAlphaComponent(0.8)
                break
            case "card2":
                print("card2 detected")
                plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.8)
                break
            default:
                break
            }
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)
        }
        
        
        return node
    }
}

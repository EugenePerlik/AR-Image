//
//  ViewController.swift
//  AR Image
//
//  Created by  Apple24 on 21/12/2018.
//  Copyright © 2018  Apple24. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.scene = SCNScene()
        sceneView.autoenablesDefaultLighting = true
     // sceneView.debugOptions = [.showWorldOrigin,    // 0 координатa
     //                           .showFeaturePoints]  // точки привязки
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // образец картинки в ресурсах папки
         configuration.detectionImages = ARReferenceImage.referenceImages(
            inGroupNamed: "AR Resources",
            bundle: nil)
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        sceneView.session.pause()
    }

}

// MARK: - ARSCNViewDelegate
extension ViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let anchor = anchor as? ARImageAnchor else { return }
        nodeAdded(node, anchor)
    }
    

    func nodeAdded(_ node: SCNNode,_ imageAncor: ARImageAnchor) {
        let referenceImage = imageAncor.referenceImage
        
        let plane = SCNPlane(
            width: referenceImage.physicalSize.width,
            height: referenceImage.physicalSize.height
        )
        plane.firstMaterial?.diffuse.contents = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        
        let planeNode = SCNNode(geometry: plane)
        // прозрачность
        planeNode.opacity = 0.05
        // поворот на 90'
        planeNode.eulerAngles.x = -.pi / 2
        
        
        let virtualObject = VirtualObject.availableObjects[1]
        virtualObject.load()
        virtualObject.scale = SCNVector3(0.05, 0.05, 0.05)
       // virtualObject.position = SCNVector3()
        node.addChildNode(virtualObject)
        node.addChildNode(planeNode)
    }

}

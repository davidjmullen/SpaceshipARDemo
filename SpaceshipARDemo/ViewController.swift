//
//  ViewController.swift
//  SpaceshipARDemo
//
//  Created by David Mullen on 9/13/18.
//  Copyright © 2018 David Mullen. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var shipNode: SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
//        sceneView.debugOptions = ARSCNDebugOptions.showWorldOrigin
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        shipNode = scene.rootNode.childNode(withName: "shipMesh", recursively: true)
        
//        let rotateAction = SCNAction.rotateBy(x: 0, y: CGFloat.pi, z: 0, duration: 2.0)
//        let infiniteLoop = SCNAction.repeatForever(rotateAction)
//        shipNode.runAction(infiniteLoop)
        
        // Set the scene to the view
        sceneView.scene = scene

        let directions: [UISwipeGestureRecognizerDirection] = [.up, .down, .left, .right]
        for direction in directions {
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeGesture(_:)))
            swipeGesture.direction = direction
            self.view.addGestureRecognizer(swipeGesture)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapGesture(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }

    @objc func didTapGesture(_ gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .ended:
            SCNTransaction.animationDuration = 2.0
            shipNode.localTranslate(by: SCNVector3(0, 0, 2.0))
        default:
            break
        }
    }

    @objc func didSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .up:
            let pitchDown = SCNAction.rotateBy(x: CGFloat.pi / 2, y: 0, z: 0, duration: 1.0)
            shipNode.runAction(pitchDown)
        case .down:
            let pitchUp = SCNAction.rotateBy(x: -CGFloat.pi / 2, y: 0, z: 0, duration: 1.0)
            shipNode.runAction(pitchUp)
        case .left:
            let yawLeft = SCNAction.rotateBy(x: 0, y: CGFloat.pi / 2, z: 0, duration: 1.0)
            shipNode.runAction(yawLeft)
        case .right:
            let yawRight = SCNAction.rotateBy(x: 0, y: -CGFloat.pi / 2, z: 0, duration: 1.0)
            shipNode.runAction(yawRight)
        default:
            break
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
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

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
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

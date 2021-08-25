//
//  ViewController.swift
//  AR-3D-Dicee-Example-Swift-IOS
//
//  Created by apple on 20/08/21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var diceArray  = [SCNNode]()
    
    @IBAction func rollButtonPressed(_ sender: Any) {
        rollAllDice()
    }
    @IBAction func removeAllButtonPressed(_ sender: Any) {
        if !diceArray.isEmpty {
            for dice in diceArray {
                dice.removeFromParentNode()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Will show detected points on the scene for deubgging purpose enable it to view points
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // for cube
       // let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        
        //let sphere = SCNSphere(radius: 0.2)
        
        //let material = SCNMaterial()
        // UIColor.red to make red cube
        //material.diffuse.contents = UIColor.red
        
       // material.diffuse.contents = UIImage(named: "art.scnassets/mercury.jpg")
       // sphere.materials = [material]
        
        //let node = SCNNode()
        //node.position = SCNVector3(0, 0.1, -0.5)
        //node.geometry = cube
        //node.geometry = sphere
        
        //sceneView.scene.rootNode.addChildNode(node)
        //sceneView.autoenablesDefaultLighting = true
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        
       
        
        
        
        // Set the scene to the view
        //sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal // this will help to detect horizontal plane

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //MARK:- This will get called when ARKit detects horizontal plane
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            print("Detected")
            let planeAnchor = anchor as! ARPlaneAnchor
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            //rotating 90 degree clockwise
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi
                                                         / 2, 1, 0, 0)
            let scMaterial = SCNMaterial()
            scMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            planeNode.geometry = plane
            sceneView.scene.rootNode.addChildNode(planeNode)
            
        }
        else{
            print("Not detected")
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            //hittest fetches the actual 3d location of plane which is location on scene when we touch the screen
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let firstResult = results.first {
                //To add a dice use these below code
             addDice(locationToBeUsed: firstResult)
            }
            
//            if results.isEmpty {
//                print("Touched outside the plane")
//            }
//            else {
//                print("Touched the plane")
//
//            }
        }
    }
    func addDice(locationToBeUsed firstResult: ARHitTestResult) {
        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        if  let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true){
         diceNode.position = SCNVector3(firstResult.worldTransform.columns.3.x, firstResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius, firstResult.worldTransform.columns.3.z)
         diceArray.append(diceNode)
        sceneView.scene.rootNode.addChildNode(diceNode)
         roll(diceNode)
        }
    }
    func rollAllDice(){
        if !diceArray.isEmpty {
            for dice in diceArray {
                roll(dice)
            }
        }
    }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAllDice()
    }
    func roll (_ dice:SCNNode) {
        let randomX = Float(arc4random_uniform(4)+1) * (Float.pi/2)
        let randomz = Float(arc4random_uniform(4) + 1) * (Float.pi/2)
        dice.runAction(SCNAction.rotateBy(x: CGFloat(randomX * 5), y: 0, z: CGFloat(randomz * 5), duration: 0.5))
    }
    
}

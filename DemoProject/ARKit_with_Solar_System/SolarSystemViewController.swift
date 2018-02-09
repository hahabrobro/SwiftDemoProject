//
//  SolarSystemViewController.swift
//  DemoProject
//
//  Created by 張立 on 2018/1/29.
//  Copyright © 2018年 張立. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class SolarSystemViewController: UIViewController,ARSCNViewDelegate {
    
    
    @IBOutlet var sceneView: ARSCNView!
    let scene = SCNScene()
    let baseNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title="太陽系與九大行星"
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        
        var arr: Array<setting>=Array()
        
        let p_sun=setting(name: "sun", radius: 0.25, size: 0, position: 0, rotation: -0.3,duration:1,ringrotation:0.6)
        
        let p_mercury=setting(name: "mercury", radius: 0.03, size: 0.3, position: 0.3, rotation: 0.4,duration:0.4,ringrotation:0.4)
        
        let p_venus=setting(name: "venus", radius: 0.04, size: 0.5, position: 0.5, rotation: 0.4,duration:0.4,ringrotation:0.25)
        
        let p_earth=setting(name: "earth", radius: 0.05, size: 0.7, position: 0.7, rotation: 0.25, duration: 0.4,ringrotation:0.2)
        
        let p_mars=setting(name: "mars", radius: 0.03, size: 0.8, position: 0.8, rotation: 0.2, duration: 0.4,ringrotation:0.2)
        
        let p_jupiter=setting(name: "jupiter", radius: 0.12, size: 1, position: 1, rotation: 0.45, duration: 0.4,ringrotation:0.45)
        
        let p_saturn = setting(name: "saturn", radius: 0.09, size: 1.25, position: 1.25, rotation: 0.34, duration: 0.4,ringrotation:0.34)
        
        let p_uranus = setting(name: "uranus", radius: 0.07, size: 1.5, position: 1.5, rotation: 0.25, duration: 0.4,ringrotation:0.25)
        
        let p_neptune = setting(name: "neptune", radius: 0.08, size: 1.7, position: 1.7, rotation: 0.2, duration: 0.4,ringrotation:0.2)
        
        
        arr.append(p_sun)
        arr.append(p_mercury)
        arr.append(p_venus)
        arr.append(p_earth)
        arr.append(p_mars)
        arr.append(p_jupiter)
        arr.append(p_saturn)
        arr.append(p_uranus)
        arr.append(p_neptune)
        
        let moon = CreatePlanet(radius: 0.01, image: "moon")
        let moonRing = SCNTorus(ringRadius: 0.08, pipeRadius: 0.000001)
        let moonRingNode = SCNNode(geometry: moonRing)
        
        moon.position = SCNVector3(x:0.08 ,y: 0,z: 0)
        moonRingNode.position = SCNVector3(x:0 ,y: 0.02,z: 0)
        
        moonRingNode.addChildNode(moon)
        
        let sttuenLoop = SCNBox(width: 0.4, height: 0, length: 0.5, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named:"saturn_loop.jpg")
        sttuenLoop.materials = [material]
        
        let loopNode = SCNNode(geometry: sttuenLoop)
        loopNode.rotation = SCNVector4(-0.5,-0.5,0,5)
        loopNode.position = SCNVector3(x:0 ,y: 0,z: 0)
        
        for Info in arr {
            
            let planet=CreatePlanet(radius:Info.planetRadius, image: Info.planetName)
            
            let ring=createRins(ringSize: Info.ringSize)
            
            planet.position = SCNVector3(Info.planetPosition,0,0)
            
            if(Info.planetName=="earth")
            {
                planet.addChildNode(moonRingNode)
            }
            else if(Info.planetName=="saturn")
            {
                planet.addChildNode(loopNode)
            }
            
            ring.addChildNode(planet)
            
            baseNode.addChildNode(ring)
            
            
            rotateObject(rotation: Info.planetRotation, planet: planet, duration: Info.planetDuration)
            
            rotateObject(rotation: Info.ringRotation, planet: ring, duration: 1)
        }
        
        //todo:環
        
        
        baseNode.position = SCNVector3(0,-0.5,-3)
        // Set the scene to the view
        sceneView.scene = scene
        scene.rootNode.addChildNode(baseNode)
    }
    
    func CreatePlanet(radius:Float,image:String) -> SCNNode {
        let planet = SCNSphere(radius: CGFloat(radius))
        let material=SCNMaterial()
        material.diffuse.contents=UIImage(named: "\(image).jpg")
        planet.materials=[material]
        
        let planetNode=SCNNode(geometry: planet)
        return planetNode
        
    }
    
    func rotateObject(rotation:Float,planet:SCNNode,duration:Float) {
        
        let rotation=SCNAction.rotateBy(
            x: 0, y: CGFloat(rotation),
            z: 0, duration: TimeInterval(duration)
        )
        planet.runAction(SCNAction.repeatForever(rotation))
    }
    
    func createRins(ringSize:Float) ->SCNNode {
        
        let ring = SCNTorus(ringRadius: CGFloat(ringSize), pipeRadius: 0.002)
        let material=SCNMaterial()
        material.diffuse.contents=UIColor.darkGray
        ring.materials=[material]
        
        let ringNode=SCNNode(geometry: ring)
        
        return ringNode
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
class setting {
    var planetName:String = ""
    var planetRadius:Float=0.0
    var ringSize:Float=0.0
    var planetPosition:Float=0.0
    var planetRotation:Float=0.0
    var planetDuration:Float=0.0
    var ringRotation:Float=0.0
    init(name:String,radius:Float,size:Float,position:Float,rotation:Float,duration:Float,ringrotation:Float) {
        self.planetName = name
        self.planetRadius = radius
        self.ringSize = size
        self.planetPosition = position
        self.planetRotation = rotation
        self.planetDuration = duration
        self.ringRotation = ringrotation
        
    }
}

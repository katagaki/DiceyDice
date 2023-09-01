//
//  ContentView.swift
//  DiceyDice
//
//  Created by シン・ジャスティン on 1/9/23.
//

import SwiftUI
import SceneKit
import CoreMotion

struct ContentView: View {

    let scene = SCNScene()

    @State var centerOfMassX: String = "1.68"
    @State var centerOfMassY: String = "1.80"
    @State var centerOfMassZ: String = "-0.78"

    var body: some View {
        VStack(alignment: .center, spacing: 8.0) {
            SceneView(scene: {
                                 scene.background.contents = UIColor.systemGroupedBackground
                                 return scene
                             }(),
                      pointOfView: camera(),
                      options: [.allowsCameraControl],
                      preferredFramesPerSecond: 60)
            HStack {
                TextField(text: $centerOfMassX) {
                    Text("X")
                }
                TextField(text: $centerOfMassY) {
                    Text("Y")
                }
                TextField(text: $centerOfMassZ) {
                    Text("Z")
                }
            }
            .textFieldStyle(.roundedBorder)
            .padding()
            Text("Default: 1.68, 1.80, -0.78")
            HStack(alignment: .center, spacing: 8.0) {
                Button {
                    resetScene()
                } label: {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Reset Scene")
                    }
                    .padding()
                }
                .clipShape(RoundedRectangle(cornerRadius: 99))
                .buttonStyle(.bordered)
                Button {
                    addDice()
                } label: {
                    HStack {
                        Image(systemName: "dice.fill")
                        Text("Add Dice")
                            .bold()
                    }
                    .padding()
                }
                .clipShape(RoundedRectangle(cornerRadius: 99))
                .buttonStyle(.borderedProminent)
            }
        }
        .onAppear {
            resetScene()
            addDice()
        }
    }

    func addDice() {
        scene.rootNode.addChildNode(dice(position: SCNVector3(-8, 4, 0),
                                         rotation: SCNVector3(0, 0, 0)))
        
        scene.rootNode.addChildNode(dice(position: SCNVector3(-4, 4, 0),
                                         rotation: SCNVector3(3.14 / 2, 0, 0)))
        
        scene.rootNode.addChildNode(dice(position: SCNVector3(0, 4, 0),
                                         rotation: SCNVector3(3.14, 0, 0)))
        
        scene.rootNode.addChildNode(dice(position: SCNVector3(4, 4, 0),
                                         rotation: SCNVector3(0, 0, 3.14 / 2)))
        
        scene.rootNode.addChildNode(dice(position: SCNVector3(8, 4, 0),
                                         rotation: SCNVector3(0, 0, 3.14)))
        
        scene.rootNode.addChildNode(dice(position: SCNVector3(-8, 4, 5),
                                         rotation: SCNVector3(3.14 / 2, 3.14 / 2, 3.14)))
        
        scene.rootNode.addChildNode(dice(position: SCNVector3(-4, 4, 5),
                                         rotation: SCNVector3(0, 3.14, 3.14 / 2)))
    }

    func resetScene() {
        scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        scene.rootNode.addChildNode(floor())
        scene.rootNode.addChildNode(light())
    }

    func dice(position: SCNVector3, rotation: SCNVector3) -> SCNNode {
        let diceScene = SCNScene(named: "Scene Assets.scnassets/Dice.dae")
        let diceNode = diceScene!.rootNode.childNodes[0]
        let physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        physicsBody.mass = 0.045
        physicsBody.centerOfMassOffset = SCNVector3(Float(centerOfMassX)!,
                                                    Float(centerOfMassY)!,
                                                    Float(centerOfMassZ)!)
        diceNode.physicsBody = physicsBody
        diceNode.eulerAngles = rotation
        diceNode.position = position
        return diceNode
    }

    func floor() -> SCNNode {
        let floor = SCNFloor()
        let floorNode = SCNNode(geometry: floor)
        floor.reflectivity = 0.5
        floor.width = 10
        floor.length = 10
        floorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.label
        floorNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        return floorNode
    }

    func light() -> SCNNode {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .ambient
        lightNode.position = SCNVector3(x: 0, y: 10, z: 0)
        return lightNode
    }

    func camera() -> SCNNode {
        let cameraNode = SCNNode()
        cameraNode.position = SCNVector3(x: 0, y: 40, z: 0)
        cameraNode.eulerAngles = SCNVector3(-3.14 / 2, 0, 0)
        cameraNode.camera = SCNCamera()
        return cameraNode
    }
}

#Preview {
    ContentView()
}

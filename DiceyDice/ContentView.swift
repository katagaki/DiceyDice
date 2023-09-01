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

    var body: some View {
        VStack(alignment: .center, spacing: 8.0) {
            SceneView(scene: {
                                 scene.background.contents = UIColor.systemBackground
                                 return scene
                             }(),
                      pointOfView: camera(),
                      options: [.allowsCameraControl],
                      preferredFramesPerSecond: 60)
            Divider()
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
            .padding()
        }
        .onAppear {
            resetScene()
            addDice()
        }
    }

    func addDice() {
        // 1 facing up
        scene.rootNode.addChildNode(dice(position: SCNVector3(-13, 2, 0),
                                         rotation: SCNVector3(0, 0, 0)))
        // 2 facing up
        scene.rootNode.addChildNode(dice(position: SCNVector3(-6, 4.26, 0),
                                         rotation: SCNVector3(3.14 / 2, 3.14 / 2, 3.14)))
        // 3 facing up
        scene.rootNode.addChildNode(dice(position: SCNVector3(-1, 2, 0),
                                         rotation: SCNVector3(0, 0, 3.14 / 2)))
        // 4 facing up
        scene.rootNode.addChildNode(dice(position: SCNVector3(4, 4.26, -2.5),
                                         rotation: SCNVector3(0, 3.14, 3.14 / 2)))
        // 5 facing up
        scene.rootNode.addChildNode(dice(position: SCNVector3(6, 2, -2.5),
                                         rotation: SCNVector3(3.14 / 2, 0, 0)))
        // 6 facing up
        scene.rootNode.addChildNode(dice(position: SCNVector3(11, 4.26, -2.5),
                                         rotation: SCNVector3(3.14, 0, 0)))
    }

    func resetScene() {
        scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        scene.rootNode.addChildNode(floor())
        for wall in walls() {
            scene.rootNode.addChildNode(wall)
        }
        scene.rootNode.addChildNode(light())
    }

    func dice(position: SCNVector3, rotation: SCNVector3) -> SCNNode {
        let diceScene = SCNScene(named: "Scene Assets.scnassets/Dice.dae")
        let diceNode = diceScene!.rootNode.childNodes[0]
        let physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        physicsBody.mass = 0.045
        physicsBody.centerOfMassOffset = SCNVector3(1.70, 1.80, -0.96)
        diceNode.physicsBody = physicsBody
        diceNode.eulerAngles = rotation
        diceNode.position = position
        return diceNode
    }
    
    func walls() -> [SCNNode] {
        let leftWall = SCNBox(width: 1.0, height: 10.0, length: 40.0, chamferRadius: 0.0)
        let leftWallNode = SCNNode(geometry: leftWall)
        let rightWall = SCNBox(width: 1.0, height: 10.0, length: 40.0, chamferRadius: 0.0)
        let rightWallNode = SCNNode(geometry: rightWall)
        let topWall = SCNBox(width: 42.0, height: 10.0, length: 1.0, chamferRadius: 0.0)
        let topWallNode = SCNNode(geometry: topWall)
        let bottomWall = SCNBox(width: 42.0, height: 10.0, length: 1.0, chamferRadius: 0.0)
        let bottomWallNode = SCNNode(geometry: bottomWall)
        leftWallNode.position = SCNVector3(x: -20.5, y: 5, z: 0)
        leftWallNode.geometry?.firstMaterial?.diffuse.contents = UIColor.lightGray
        leftWallNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        rightWallNode.position = SCNVector3(x: 20.5, y: 5, z: 0)
        rightWallNode.geometry?.firstMaterial?.diffuse.contents = UIColor.lightGray
        rightWallNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        topWallNode.position = SCNVector3(x: 0, y: 5, z: 20.5)
        topWallNode.geometry?.firstMaterial?.diffuse.contents = UIColor.lightGray
        topWallNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        bottomWallNode.position = SCNVector3(x: 0, y: 5, z: -20.5)
        bottomWallNode.geometry?.firstMaterial?.diffuse.contents = UIColor.lightGray
        bottomWallNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        return [leftWallNode, rightWallNode, topWallNode, bottomWallNode]
    }

    func floor() -> SCNNode {
        let floor = SCNFloor()
        let floorNode = SCNNode(geometry: floor)
        floor.reflectivity = 0.5
        floor.width = 20.0
        floor.length = 20.0
        floor.reflectionFalloffEnd = 1.0
        floorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
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

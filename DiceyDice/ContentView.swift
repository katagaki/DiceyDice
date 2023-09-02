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

    let scene = SCNScene(named: "Scene Assets.scnassets/DiceWorld.scn")!

    var body: some View {
        SceneView(scene: scene,
                  pointOfView: scene.rootNode.childNode(withName: "camera", recursively: false)!,
                  options: [.allowsCameraControl],
                  preferredFramesPerSecond: 60)
        .ignoresSafeArea()
        .overlay {
            ZStack(alignment: .bottom) {
                Color.clear
                HStack(alignment: .center, spacing: 8.0) {
                    Button {
                        resetScene()
                    } label: {
                        HStack {
                            Image(systemName: "xmark.bin.fill")
                            Text("Remove All")
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
        }
        .onAppear {
            resetScene()
        }
    }

    func addDice() {
        scene.rootNode.childNode(withName: "dice", 
                                 recursively: false)!.addChildNode(
                                    dice(position: SCNVector3(0, 5, 0),
                                         rotation: SCNVector3(randRadians(),
                                                              randRadians(),
                                                              randRadians())))
    }

    func resetScene() {
        scene.background.contents = UIColor.systemBackground
        scene.rootNode.childNode(withName: "dice", recursively: false)!.enumerateChildNodes { node, _ in
            node.removeFromParentNode()
        }
    }

    func dice(position: SCNVector3, rotation: SCNVector3) -> SCNNode {
        let diceScene = SCNScene(named: "Scene Assets.scnassets/Dice.scn")
        let diceNode = diceScene!.rootNode.childNodes[0]
        diceNode.eulerAngles = rotation
        diceNode.position = position
        return diceNode
    }

    func randRadians() -> Float {
        return Float.random(in: -3.14...3.14)
    }

}

#Preview {
    ContentView()
}

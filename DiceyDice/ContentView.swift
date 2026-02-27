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

    let scene = SCNScene(named: "Scene Assets.scnassets/Sandbox.scn")!
    @State var diceCount = 0
    @State var isMoreViewPresenting = false

    var body: some View {
        SceneView(scene: scene,
                  pointOfView: scene.rootNode.childNode(withName: "camera", recursively: false)!,
                  preferredFramesPerSecond: 60,
                  antialiasingMode: .multisampling4X)
        .ignoresSafeArea()
        .overlay {
            ZStack(alignment: .topLeading) {
                Text("DiceyDice")
                    .font(.system(size: 36.0, weight: .bold, design: .rounded))
                    .bold()
                    .shadow(color: .secondary.opacity(0.5), radius: 6.0, x: 0.0, y: 3.0)
                    .padding()
                Color.clear
            }
        }
        .overlay {
            ZStack(alignment: .bottomLeading) {
                Color.clear
                ScrollView(.horizontal) {
                    HStack(alignment: .center, spacing: 4.0) {
                        Button {
                            resetScene()
                        } label: {
                            Image(systemName: "xmark.bin.fill")
                                .font(.system(size: 18.0, weight: .bold))
                                .frame(width: 48.0, height: 48.0)
                        }
                        .conditionalGlassButtonStyle()
                        .buttonBorderShape(.circle)
                        ForEach(1...5, id: \.self) { int in
                            Button {
                                addDice(number: int)
                            } label: {
                                Text("\(int)")
                                    .font(.system(size: 20.0, weight: .bold, design: .rounded))
                                    .frame(width: 48.0, height: 48.0)
                            }
                            .disabled(diceCount + int > 100)
                        }
                        .conditionalGlassButtonStyle(prominent: true)
                        .buttonBorderShape(.circle)
                        Button {
                            isMoreViewPresenting = true
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 18.0, weight: .bold))
                                .frame(width: 48.0, height: 48.0)
                        }
                        .conditionalGlassButtonStyle()
                        .buttonBorderShape(.circle)
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)
            }
        }
        .onAppear {
            resetScene()
        }
        .sheet(isPresented: $isMoreViewPresenting) {
            MoreView()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }

    func addDice(number: Int) {
        for index in 0..<number {
            scene.rootNode.childNode(withName: "objects",
                                     recursively: false)!.addChildNode(
                                        dice(position: SCNVector3(0, 8 + (Double(index) * 1.5), 10),
                                             rotation: SCNVector3(randRadians(),
                                                                  randRadians(),
                                                                  randRadians())))
        }
        diceCount += number
    }

    func resetScene() {
        scene.background.contents = UIColor.systemBackground
        scene.rootNode.childNode(withName: "worldFloor", recursively: true)!.geometry?.firstMaterial?.diffuse.contents = UIColor.systemBackground
        scene.rootNode.childNode(withName: "objects", recursively: false)!.enumerateChildNodes { node, _ in
            node.removeFromParentNode()
        }
        diceCount = 0
    }

    func dice(position: SCNVector3, rotation: SCNVector3) -> SCNNode {
        let diceScene = SCNScene(named: "Scene Assets.scnassets/Dice.scn")
        let diceNode = diceScene!.rootNode.childNodes[0]
        diceNode.physicsBody!.applyForce(SCNVector3(0, 0, -1.5),
                                         asImpulse: true)
        diceNode.physicsBody!.applyTorque(SCNVector4(0.05, 0.05, 0.05, randRadians()),
                                          asImpulse: false)
        diceNode.eulerAngles = rotation
        diceNode.position = position
        return diceNode
    }

    func randRadians() -> Float {
        return Float.random(in: -3.14...3.14)
    }

}

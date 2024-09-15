//
//  MoreView.swift
//  DiceyDice
//
//  Created by シン・ジャスティン on 4/9/23.
//

import Komponents
import SwiftUI

struct MoreView: View {

    var body: some View {
        NavigationStack {
            MoreList(repoName: "katagaki/DiceyDice") { }
            .navigationTitle("View.More")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

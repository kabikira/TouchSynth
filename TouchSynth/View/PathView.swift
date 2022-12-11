//
//  PathView.swift
//  TouchSynth
//
//  Created by koala panda on 2022/12/11.
//

import SwiftUI

struct PathView: View {
    var body: some View {
        Path { path in
            path.addRect(CGRect(x: 50, y: 50, width: 50, height: 50))
        }.stroke(.cyan, lineWidth: 5)
    }
}

struct PathView_Previews: PreviewProvider {
    static var previews: some View {
        PathView()
    }
}

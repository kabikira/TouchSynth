//
//  GridView.swift
//  TouchSynth
//
//  Created by koala panda on 2022/12/12.
//

import SwiftUI

struct GridView: View {
    var body: some View {
        GeometryReader{geometry in
            VStack(spacing: 0){
                ForEach(0..<8){_ in
                    HStack(spacing: 0){
                        ForEach(0..<8){_ in
                            Rectangle()
                                .stroke(lineWidth: 1)
                                .fill(Color.blue)
                                .frame(width: geometry.size.width/8, height: geometry.size.width/8)
                        }
                    }
                }
            }
        }
    }
    
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView()
    }
}

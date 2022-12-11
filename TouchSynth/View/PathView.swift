//
//  PathView.swift
//  TouchSynth
//
//  Created by koala panda on 2022/12/11.
//

import SwiftUI

struct PathView: View {
    var body: some View {
        ZStack {
            Path { path in
                path.addLines([              // 格子状にしたい
                    CGPoint(x: 0, y: 0),
                    CGPoint(x: 0, y: UIScreen.main.bounds.width),
                    CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.width),
                    CGPoint(x: UIScreen.main.bounds.width, y: 0),
                    CGPoint(x: 0, y: 0),
                    
                    
                              ])
            }.stroke(.cyan, lineWidth: 5)
            // 横の線　13本
            HStack {
                Path { path2 in
                    path2.addLines([
                        // ここから格子状にうねうね描く
                        CGPoint(x: UIScreen.main.bounds.width/12, y: 0),
                        CGPoint(x: UIScreen.main.bounds.width/12, y: UIScreen.main.bounds.width),
                        CGPoint(x: UIScreen.main.bounds.width/6, y: UIScreen.main.bounds.width),
                        CGPoint(x: UIScreen.main.bounds.width/6, y: 0),
                        CGPoint(x: UIScreen.main.bounds.width/4, y: 0),
                        CGPoint(x: UIScreen.main.bounds.width/4, y: UIScreen.main.bounds.width)
                        
                    ])
                }.stroke(.red, lineWidth: 1)
                Path { path2 in
                    path2.addLines([
                        // ここから格子状にうねうね描く
                        CGPoint(x: UIScreen.main.bounds.width/12, y: 0),
                        CGPoint(x: UIScreen.main.bounds.width/12, y: UIScreen.main.bounds.width),
                        CGPoint(x: UIScreen.main.bounds.width/6, y: UIScreen.main.bounds.width),
                        CGPoint(x: UIScreen.main.bounds.width/6, y: 0),
                        CGPoint(x: UIScreen.main.bounds.width/4, y: 0),
                        CGPoint(x: UIScreen.main.bounds.width/4, y: UIScreen.main.bounds.width)
                        
                    ])
                }.stroke(.red, lineWidth: 1)
                Path { path2 in
                    path2.addLines([
                        // ここから格子状にうねうね描く
                        CGPoint(x: UIScreen.main.bounds.width/12, y: 0),
                        CGPoint(x: UIScreen.main.bounds.width/12, y: UIScreen.main.bounds.width),
                        CGPoint(x: UIScreen.main.bounds.width/6, y: UIScreen.main.bounds.width),
                        CGPoint(x: UIScreen.main.bounds.width/6, y: 0),
                        CGPoint(x: UIScreen.main.bounds.width/4, y: 0),
                        CGPoint(x: UIScreen.main.bounds.width/4, y: UIScreen.main.bounds.width)
                        
                    ])
                }.stroke(.red, lineWidth: 1)
                Path { path2 in
                    path2.addLines([
                        // ここから格子状にうねうね描く
                        CGPoint(x: UIScreen.main.bounds.width/12, y: 0),
                        CGPoint(x: UIScreen.main.bounds.width/12, y: UIScreen.main.bounds.width),
                        CGPoint(x: UIScreen.main.bounds.width/6, y: UIScreen.main.bounds.width),
                        CGPoint(x: UIScreen.main.bounds.width/6, y: 0),
                        CGPoint(x: UIScreen.main.bounds.width/4, y: 0),
                        CGPoint(x: UIScreen.main.bounds.width/4, y: UIScreen.main.bounds.width)
                        
                    ])
                }.stroke(.red, lineWidth: 1)
                

            }
            // 縦の線　6本
                        
        }
        //        HStack {
        //            Path { path in
        //                path.addRect(CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/12, height: UIScreen.main.bounds.width/12))
        //            }.stroke(.cyan, lineWidth: 2)
        //            Path { path in
        //                path.addRect(CGRect(x: UIScreen.main.bounds.width/7, y: 0, width: UIScreen.main.bounds.width/12, height: UIScreen.main.bounds.width/12))
        //            }.stroke(.cyan, lineWidth: 2)
        //
        //        }
        
    }
}

struct PathView_Previews: PreviewProvider {
    static var previews: some View {
        PathView()
    }
}

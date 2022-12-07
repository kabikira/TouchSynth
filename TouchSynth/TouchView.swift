//
//  TouchView.swift
//  TouchSynth
//
//  Created by koala panda on 2022/12/08.
//

import SwiftUI

struct TouchView: View {
    var gestureTouch = GestureTouch()
    var body: some View {
        VStack {
            Spacer()
            Rectangle()
                .fill(Color.white)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                .border(Color.blue, width: 4)
                .gesture(gestureTouch.drag)
                .disabled(true)
            
        }
    }
}
class GestureTouch {
    var signalGenerator = SignalGenerator()
    var drag: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged {
                dragGesture in
                print("タッチした座標(x\(dragGesture.location.x),y\(dragGesture.location.y))")
                self.signalGenerator.signalPlay()
            }
            .onEnded { _ in
                print("離した")
                //                signalGenerator.signalStop()
            }
    }
}


struct TouchView_Previews: PreviewProvider {
    static var previews: some View {
        TouchView()
    }
}

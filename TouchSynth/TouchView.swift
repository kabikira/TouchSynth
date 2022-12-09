//
//  TouchView.swift
//  TouchSynth
//
//  Created by koala panda on 2022/12/08.
//

import SwiftUI

class TouchSensitvity: ObservableObject {
    @Published var isAdjust = false
    @Published var timer: Timer?
}

struct TouchView: View {
    var signalGenerator = SignalGenerator()
    @ObservedObject var touchSensitvity = TouchSensitvity()
    @State var previousLocationX = 0
    @State var previousLocationY = 0
    @State var count = 0
    
    var screenSize = UIScreen.main.bounds.width
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 0.5, coordinateSpace: .local)
            .onChanged {
                dragGesture in
                
                
                if self.count < 13 {
                    self.signalGenerator.signalPlay()
                    self.count += 1
                    print(self.count)
                    previousLocationX = Int(dragGesture.location.x)
                    previousLocationY = Int(dragGesture.location.y)
                    print("タッチした座標(x\(dragGesture.location.x),y\(dragGesture.location.y))")
                    
                } else if self.count == 13 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            touchSensitvity.timer?.invalidate()
                                            touchSensitvity.timer = nil
                                            touchSensitvity.isAdjust = false
                                        }
                }else {
                    touchSensitvity.isAdjust = true
                }
                
            }
            .onEnded { _ in
                print("離した")
                self.count = 0
                touchSensitvity.isAdjust = false
                print(previousLocationX,previousLocationY)
                print(screenSize)
                
            }
    }
    
    var body: some View {
        VStack {
            Spacer()
            Rectangle()
                .fill(Color.white)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                .border(Color.blue, width: 4)
                .gesture(drag)
                .disabled(touchSensitvity.isAdjust)
            
        }
    }
}
//class GestureTouch {
//
//}


//struct TouchView_Previews: PreviewProvider {
//    static var previews: some View {
//        TouchView()
//    }
//}

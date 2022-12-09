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
class Location: ObservableObject {
    @Published var xLocation = 0
    @Published var yLocation = 0
}

struct TouchView: View {
    @ObservedObject var signalGenerator = SignalGenerator()
    
    @ObservedObject var touchSensitvity = TouchSensitvity()
    @ObservedObject var pastlocation = Location()
    
    @State var previousLocationX = 0
    @State var previousLocationY = 0
    @State var count = 0
//    @State var point = CGPoint()
    @State var location = CGPoint()
    
    var screenSize = UIScreen.main.bounds.width
    
//    var tap: some Gesture {　b
//        TapGesture()
//            .onEnded {
//                self.signalGenerator.signalPlay()
//                print("タップしたよ")
//            }
//    }
    var tap: some Gesture {
        DragGesture(minimumDistance: 0)
            .onEnded{ event in
                self.location = event.location
                print("Tap",location)
                signalGenerator.signalPlay()
                }
                
            }
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 1, coordinateSpace: .local)
            .onChanged {
                dragGesture in
                
                if self.count < 13 {
                    self.signalGenerator.signalPlay()
                    self.count += 1
                    print(self.count)
                    previousLocationX = Int(dragGesture.location.x)
                    previousLocationY = Int(dragGesture.location.y)
                    
                    signalGenerator.xLocation = Int(dragGesture.location.x)
                    signalGenerator.yLocation = Int(dragGesture.location.y)
                    
                    print("ドラッグした座標(x\(dragGesture.location.x)y\(dragGesture.location.y))")
                    
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
                print("ドラッグ離した")
                self.count = 0
                touchSensitvity.isAdjust = false
                print(previousLocationX,previousLocationY)
                print(screenSize)
                print(Int(screenSize/13))
                
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
                .gesture(tap)
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

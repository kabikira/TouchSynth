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
    //    @State var location = CGPoint()
    
    //    var screenSize = UIScreen.main.bounds.width
    
//    var tap: some Gesture {
//            TapGesture()
//                .onEnded {
//                    signalGenerator.xLocation = Int(event.location.x)
//                    signalGenerator.yLocation = Int(event.location.y)
//                    self.signalGenerator.signalPlay()
//                    print("タップしたよ")
//                }
//        }
    var gesture:some Gesture {
        SpatialTapGesture().onEnded { event in
            signalGenerator.xLocation = Int(event.location.x)
            signalGenerator.yLocation = Int(event.location.y)
            self.signalGenerator.signalPlay()
            print("タップしたよ")
        }
    }
    var tap: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { event in
                //                self.location = event.location
                signalGenerator.xLocation = Int(event.location.x)
                signalGenerator.yLocation = Int(event.location.y)
                print("Tap",event.location.x, event.location.y)
                signalGenerator.signalPlay()

            }
//            .onEnded{ event in
//                //                self.location = event.location
//                signalGenerator.xLocation = Int(event.location.x)
//                signalGenerator.yLocation = Int(event.location.y)
//                print("Tap",event.location.x, event.location.y)
//                signalGenerator.signalPlay()
//            }

    }
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged {
                dragGesture in
                
                if self.count < 13 {
                    
                    self.count += 1
                    print(self.count)
                    previousLocationX = Int(dragGesture.location.x)
                    previousLocationY = Int(dragGesture.location.y)
                    
                    signalGenerator.xLocation = Int(dragGesture.location.x)
                    signalGenerator.yLocation = Int(dragGesture.location.y)
                    self.signalGenerator.signalPlay()
                    
                    print("ドラッグした座標(x\(dragGesture.location.x)y\(dragGesture.location.y))")
                    
                } else if self.count == 12 {
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
                //                print(screenSize)
                //                print(Int(screenSize/13))
                
            }
    }
    
    var body: some View {
        
        Spacer()
//        GridView()
        Rectangle()
//        GeometryReader{geometry in
//            let row = Array(repeating: GridItem(.adaptive(minimum: UIScreen.main.bounds.width/8),spacing: 0.0), count: 8)
//
//                    LazyVGrid(columns: row, spacing: 0){
//                        ForEach(0..<64){_ in
//                            Rectangle()
//                                .stroke(lineWidth: 1)
//                                .frame(height: UIScreen.main.bounds.width/8)
//                        }
//                    }
//                }
        //                .fill(Color.white)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
//            .gesture(drag)
//            .gesture(tap)
            .gesture(gesture)
            .disabled(touchSensitvity.isAdjust)
        //                .overlay {
        //                    GridView()
        //                            }
        
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

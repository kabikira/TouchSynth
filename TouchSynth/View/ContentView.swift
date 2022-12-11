//
//  ContentView.swift
//  TouchSynth
//
//  Created by koala panda on 2022/12/05.
//

import SwiftUI

struct ContentView: View {
//    var signalGenerator = SignalGenerator()
//    var gestureTouch = GestureTouch()
    var body: some View {
        VStack {
            Text("\(UIScreen.main.bounds.width)")
            Text("\(UIScreen.main.bounds.height)")
//            Button("start") {
//                signalGenerator.signalPlay()
//            }
//            Button("stop") {
//                signalGenerator.signalStop()
//            }
            TouchView()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

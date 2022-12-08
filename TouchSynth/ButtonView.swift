//
//  ButtonView.swift
//  TouchSynth
//
//  Created by koala panda on 2022/12/09.
//

import SwiftUI

struct ButtonView: View {
    var signalGenerator = SignalGenerator()
    var body: some View {
        VStack {
            Button("start") {
                signalGenerator.signalPlay()
            }
            Button("start") {
                signalGenerator.signalPlay()
            }
            Button("start") {
                signalGenerator.signalPlay()
            }
            Button("start") {
                signalGenerator.signalPlay()
            }
            Button("start") {
                signalGenerator.signalPlay()
            }
            Button("start") {
                signalGenerator.signalPlay()
            }
            Button("start") {
                signalGenerator.signalPlay()
            }
            Button("start") {
                signalGenerator.signalPlay()
            }
            
        }
        
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView()
    }
}

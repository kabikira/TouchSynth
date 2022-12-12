//
//  SignalGenerator.swift
//  TouchSynth
//
//  Created by koala panda on 2022/12/07.
//

import Foundation
import AVFoundation
import UIKit

class SignalGenerator: ObservableObject {
    @Published var xLocation = 0
    @Published var yLocation = 0
    var screenSize = Int(UIScreen.main.bounds.width)/8
    // タッチしたx座標によってして周波数が変わる
    var freq: Float = 0
    // サンプルレートマイナス数値
//    var mod: Double = 12000
//
//    func chageMod() -> Double {
//        switch yLocation {
//        case ..<screenSize:
//            mod *= 1.125
//        case ..<(screenSize * 2):
//            mod *= 1.250
//        case ..<(screenSize * 3):
//            mod *= 1.375
//        case ..<(screenSize * 4):
//            mod *= 1.500
//        case ..<(screenSize * 5):
//            mod *= 1.625
//        case ..<(screenSize * 6):
//            mod *= 1.750
//        case ..<(screenSize * 7):
//            mod *= 1.875
//        default:
//            mod *= 2
//        }
//        return mod
//    }
    
    func changeFreq() -> Float {
        // タッチしたx座標によって周波数が変わる
        switch xLocation {
        case ..<screenSize:
            freq = 1046
        case ..<(screenSize * 2):
            freq = 1174
        case ..<(screenSize * 3):
            freq = 1318
        case ..<(screenSize * 4):
            freq = 1396
        case ..<(screenSize * 5):
            freq = 1567
        case ..<(screenSize * 6):
            freq = 1760
        case ..<(screenSize * 7):
            freq = 1975
//        case ..<(screenSize * 8):
//            freq = 1567
//        case ..<(screenSize * 9):
//            freq = 1661
//        case ..<(screenSize * 10):
//            freq = 1760
//        case ..<(screenSize * 11):
//            freq = 1864
//        case ..<(screenSize * 12):
//            freq = 1975
        default:
            freq = 2093
        }
        return freq

    }
    
// func外で宣言すると落ちる
//    let engine = AVAudioEngine()
    func signalPlay() {
        print("!!!!!!!!!!!!!\(screenSize + screenSize)")
        print("signalGenerator",xLocation, yLocation)
        let userDefaults = UserDefaults.standard

        struct OptionNames {
            static let signal = "signal"
            static let frequency = "freq"
            static let duration = "duration"
            static let output = "output"
            static let amplitude = "amplitude"
        }

        let getFloatForKeyOrDefault = { (key: String, defaultValue: Float) -> Float in
            let value = userDefaults.float(forKey: key)
            return value > 0.0 ? value : defaultValue
        }

        // 音の高さ
        let frequency = getFloatForKeyOrDefault(OptionNames.frequency, changeFreq())
        // 振り幅
        let amplitude = min(max(getFloatForKeyOrDefault(OptionNames.amplitude, 0.5), 0.0), 1.0)
        // 音の長さ
        let duration = getFloatForKeyOrDefault(OptionNames.duration, 0.5)
        let outputPath = userDefaults.string(forKey: OptionNames.output)

        let twoPi = 2 * Float.pi

        let sine = { (phase: Float) -> Float in
            return sin(phase)
        }

        let whiteNoise = { (phase: Float) -> Float in
            // amplotude をかけた
            return (amplitude * (Float(arc4random_uniform(UINT32_MAX)) / Float(UINT32_MAX)) * 2 - 1)
        }

        let sawtoothUp = { (phase: Float) -> Float in
            return 1.0 - 2.0 * (phase * (1.0 / twoPi))
        }

        let sawtoothDown = { (phase: Float) -> Float in
            return (2.0 * (phase * (1.0 / twoPi))) - 1.0
        }

        let square = { (phase: Float) -> Float in
            if phase <= Float.pi {
                return 1.0
            } else {
                return -1.0
            }
        }

        let triangle = { (phase: Float) -> Float in
            var value = (2.0 * (phase * (1.0 / twoPi))) - 1.0
            if value < 0.0 {
                value = -value
            }
            return 2.0 * (value - 0.5)
        }

        var signal: (Float) -> Float

        if let signalName = userDefaults.string(forKey: OptionNames.signal) {
            let signalFunctions = ["sine": sine,
                                   "noise": whiteNoise,
                                   "square": square,
                                   "sawtoothUp": sawtoothUp,
                                   "sawtoothDown": sawtoothDown,
                                   "triangle": triangle]

            if let signalFunction = signalFunctions[signalName] {
                signal = signalFunction
            } else {
                print("Please specify a valid signal type: \(signalFunctions.keys.sorted().joined(separator: ", "))")
                exit(1)
            }
        } else {
            signal = sine
        }

        let engine = AVAudioEngine()
        let mainMixer = engine.mainMixerNode
        let output = engine.outputNode
        let outputFormat = output.inputFormat(forBus: 0)
//        let sampleRate = Float(outputFormat.sampleRate)
        let sampleRate = Float(44100)
        
        let modRate = Double(sampleRate)
        // 入力に対して出力フォーマットを使用するが、チャンネル数を1に減らす。
        let inputFormat = AVAudioFormat(commonFormat: outputFormat.commonFormat,
                                        sampleRate: modRate,
                                        channels: 1,
                                        interleaved: outputFormat.isInterleaved)

        var currentPhase: Float = 0
        // フレームごとに位相を進める間隔を指定します。
        // ここだここだここだ
        let phaseIncrement = (twoPi / sampleRate) * frequency

        let srcNode = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            for frame in 0..<Int(frameCount) {
                // このフレームの時刻のシグナル値を取得する。
                let value = signal(currentPhase) * amplitude
                // 次のフレームのために位相を進める。
                currentPhase += phaseIncrement
                if currentPhase >= twoPi {
                    currentPhase -= twoPi
                }
                if currentPhase < 0.0 {
                    currentPhase += twoPi
                }
                // 全てのチャンネルに同じ値を設定する（inputFormatのため、1チャンネルしかないが）。
                for buffer in ablPointer {
                    let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                    buf[frame] = value
                }
            }
            return noErr
        }

        engine.attach(srcNode)

        engine.connect(srcNode, to: mainMixer, format: inputFormat)
        engine.connect(mainMixer, to: output, format: outputFormat)
        mainMixer.outputVolume = 0.5

        var outFile: AVAudioFile?
        if let path = outputPath {
            var samplesWritten: AVAudioFrameCount = 0
            let outUrl = URL(fileURLWithPath: path).standardizedFileURL
            let outDirExists = try? outUrl.deletingLastPathComponent().checkResourceIsReachable()
            if outDirExists != nil {
                var outputFormatSettings = srcNode.outputFormat(forBus: 0).settings
                // オーディオファイルをインターリーブする。
                outputFormatSettings[AVLinearPCMIsNonInterleaved] = false
                outFile = try? AVAudioFile(forWriting: outUrl, settings: outputFormatSettings)
                // 期間内に書き込むサンプル数の合計を計算する。
                let samplesToWrite = AVAudioFrameCount(duration * sampleRate)
                srcNode.installTap(onBus: 0, bufferSize: 1024, format: inputFormat) { buffer, _ in
                    // 要求されたサンプル数に合わせてバッファのフレーム長を調整するかどうかをチェックする。
                    // 要求されたサンプル数に合わせてバッファのフレーム長を調整するかどうかをチェックします。
                    if samplesWritten + buffer.frameLength > samplesToWrite {
                        buffer.frameLength = samplesToWrite - samplesWritten
                    }
                    do {
                        try outFile?.write(from: buffer)
                    } catch {
                        print("Error writing file \(error)")
                    }
                    samplesWritten += buffer.frameLength

                    // 要求されたサンプル数を書き込んだ後、アプリを終了する。
                    if samplesWritten >= samplesToWrite {
                        CFRunLoopStop(CFRunLoopGetMain())
                    }
                }
            }
        }

        do {
            try engine.start()

            // 出力ファイルを書き込む場合、タップブロックから停止する。要求された時間分のサンプル数を書き込んだ後、
            // タップブロックから停止する。
            // それ以外の場合は、アプリが起動時にランループの実行時間を指定する。
            if outFile != nil {
                CFRunLoopRun()
            } else {
                CFRunLoopRunInMode(.defaultMode, CFTimeInterval(duration), false)
            }
            engine.stop()
        } catch {
            print("Could not start engine: \(error)")
        }
        
    }
        
}

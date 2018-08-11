//
//  ProtocolSlinger.swift
//  Cirslinger
//
//  Created by James Pamplona on 6/11/18.
//
import Foundation
//import IRSlinger
import Basic

protocol SlingerProtocol {
    var outPin: UInt32 { get }            // The Broadcom pin number the signal will be sent on
    var frequency: Int32 { get }           // The frequency of the IR signal in Hz
    var dutyCycle: Double { get }          // The duty cycle of the IR signal. 0.5 means for every cycle,
    // the LED will turn on for half the cycle time, and off the other half
    var leadingPulseDuration: Int32 { get } // The duration of the beginning pulse in microseconds
    var leadingGapDuration: Int32 { get }   // The duration of the gap in microseconds after the leading pulse
    var onePulse:Int32 { get }              // The duration of a pulse in microseconds when sending a logical 1
    var zeroPulse:Int32 { get }             // The duration of a pulse in microseconds when sending a logical 0
    var oneGap: Int32 { get }           // The duration of the gap in microseconds when sending a logical 1
    var zeroGap: Int32 { get }          // The duration of the gap in microseconds when sending a logical 0
    var sendTrailingPulse: Int32 { get }       // 1 = Send a trailing pulse with duration equal to "onePulse"
    // 0 = Don't send a trailing pulse
    
    func sling(_ value: Int)
    func sling(_ value: String)
}

struct Slinger: SlingerProtocol {
    var outPin: UInt32
    
    var frequency: Int32
    
    var dutyCycle: Double
    
    var leadingPulseDuration: Int32
    
    var leadingGapDuration: Int32
    
    var onePulse: Int32
    
    var zeroPulse: Int32
    
    var oneGap: Int32
    
    var zeroGap: Int32
    
    var sendTrailingPulse: Int32
    
    func sling(_ value: Int) {
        
    }
    
    func sling(_ value: String) {
        
    }
    
    init(outPin: UInt32,
         frequency: Int32,
         dutyCycle: Double,
         leadingPulseDuration: Int32,
         leadingGapDuration: Int32,
         onePulse: Int32,
         zeroPulse: Int32,
         oneGap: Int32,
         zeroGap: Int32,
         sendTrailingPulse: Int32) {
        
        self.outPin = outPin
        self.frequency = frequency
        self.dutyCycle = dutyCycle
        self.leadingPulseDuration = leadingPulseDuration
        self.leadingGapDuration = leadingGapDuration
        self.onePulse = onePulse
        self.zeroPulse = zeroPulse
        self.oneGap = oneGap
        self.zeroGap = zeroGap
        self.sendTrailingPulse = sendTrailingPulse
    }
}

enum IRC24SCommand: String {
    case off        = "KEY_POWER2"
    case ten        = "KEY_NUMERIC_1"
    case twenty     = "KEY_NUMERIC_2"
    case thirty     = "KEY_NUMERIC_3"
    case fourty     = "KEY_NUMERIC_4"
    case fifty      = "KEY_NUMERIC_5"
    case sixty      = "KEY_NUMERIC_6"
    case seventy    = "KEY_NUMERIC_7"
    case eighty     = "KEY_NUMERIC_8"
    case ninety     = "KEY_NUMERIC_9"
    case onehundred = "KEY_NUMERIC_0"
    case on         = "KEY_POWER"
}

struct NECSlinger: SlingerProtocol {
    let outPin: UInt32 = 13            // The Broadcom pin number the signal will be sent on
//    let outPin: UInt32 = 5
    let frequency: Int32 = 38000           // The frequency of the IR signal in Hz
    let dutyCycle = 0.5          // The duty cycle of the IR signal. 0.5 means for every cycle,
    // the LED will turn on for half the cycle time, and off the other half
    let leadingPulseDuration: Int32 = 9492 // The duration of the beginning pulse in microseconds
    let leadingGapDuration: Int32 = 4448   // The duration of the gap in microseconds after the leading pulse
    let onePulse:Int32 = 623              // The duration of a pulse in microseconds when sending a logical 1
    let zeroPulse:Int32 = 623             // The duration of a pulse in microseconds when sending a logical 0
    let oneGap: Int32 = 1641               // The duration of the gap in microseconds when sending a logical 1
    let zeroGap: Int32 = 533               // The duration of the gap in microseconds when sending a logical 0
    let sendTrailingPulse: Int32 = 1       // 1 = Send a trailing pulse with duration equal to "onePulse"
    // 0 = Don't send a trailing pulse
    
    func sling(_ value: String) {
        
        do {
            let irsend = Process(arguments: ["irsend", "SEND_ONCE", "IRC240-S", value])
            try irsend.launch()
            print("arguments: \(irsend.arguments)")
            let result = try irsend.waitUntilExit()
            let output = try result.utf8Output()
            print("irsend: \(output)")
        } catch {
            print("Couldn't send IR code")
        }
        
        /*
        irSling(outPin: outPin,
                frequency: frequency,
                dutyCycle: dutyCycle,
                leadingPulseDuration: leadingPulseDuration,
                leadingGapDuration: leadingGapDuration,
                onePulse: onePulse,
                zeroPulse: zeroPulse,
                oneGap: oneGap,
                zeroGap: zeroGap,
                sendTrailingPulse: sendTrailingPulse,
                message: value)
        */
    }
    
    func sling(_ value: String, repeated: Int) {
        (0..<repeated).forEach { _ in
            sling(value)
        }
    }
    
    func sling(_ value: Int) {
        
    }
    
    func send(command: IRC24SCommand) {
        switch command {
        case .off:
            sling(command.rawValue, repeated: 2)
        case .ten:
            send(command: .on)
            sling(command.rawValue, repeated: 2)
        case .twenty:
            send(command: .on)
            sling(command.rawValue, repeated: 2)
        case .thirty:
            send(command: .on)
            sling(command.rawValue, repeated: 2)
        case .fourty:
            send(command: .on)
            sling(command.rawValue, repeated: 2)
        case .fifty:
            send(command: .on)
            sling(command.rawValue, repeated: 2)
        case .sixty:
            send(command: .on)
            sling(command.rawValue, repeated: 2)
        case .seventy:
            send(command: .on)
            sling(command.rawValue, repeated: 2)
        case .eighty:
            send(command: .on)
            sling(command.rawValue, repeated: 2)
        case .ninety:
            send(command: .on)
            sling(command.rawValue, repeated: 2)
        case .onehundred:
            send(command: .on)
            sling(command.rawValue, repeated: 2)
        case .on:
            sling(command.rawValue, repeated: 2)
        }
    }
}

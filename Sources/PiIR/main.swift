//import SwiftyGPIO
import Foundation
import Dispatch
//import IRSlinger
import Basic
import Utility

/*
let outPin: UInt32 = 13            // The Broadcom pin number the signal will be sent on
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
func send(message: String) {
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
            message: message)
}
*/
print("Hello, world!")

/*
guard var led = gpios[.P13] else { fatalError("Couldn't get led pin") }
led.direction = .OUT
*/
//fileprivate var _readHandler: ((FileHandle) -> Void)?

let slinger = NECSlinger()

fileprivate func processCommand(_ command: String?) {
    print("Received command: \(command ?? "nil")")
    switch command {
    case "q"?, "Q"?:
//        led.value = 0
        exit(withExitCode: 0)
    case "tc"?:
        print("take me out")
    //        print(testCFunc())
    case "ts"?:
        print("take me out")
//        print(testSwiftFunc())
    case "on"?:
        slinger.send(command: .on)
    case "off"?:
        slinger.send(command: .off)
    case "10"?:
        slinger.send(command: .ten)
    case "20"?:
        slinger.send(command: .twenty)
    case "30"?:
        slinger.send(command: .thirty)
    case "40"?:
        slinger.send(command: .fourty)
    case "50"?:
        slinger.send(command: .fifty)
    case "60"?:
        slinger.send(command: .sixty)
    case "70"?:
        slinger.send(command: .seventy)
    case "80"?:
        slinger.send(command: .eighty)
    case "90"?:
        slinger.send(command: .ninety)
    case "100"?:
        slinger.send(command: .onehundred)
    case nil:
        fallthrough
    // do nothing
    default:
        print("input not recognized")
        // do nothing
    }
}

fileprivate func onPipe(filePath: String, callback: @escaping ((Data) -> Void)) {
    
    let fileManager = FileManager.default
    
    do {
        let pwd = Process(arguments: ["pwd"])
        try pwd.launch()
        let pwdResult = try pwd.waitUntilExit()
        let pwdOutput = try pwdResult.utf8Output()
        print("pwd: \(pwdOutput)")
    } catch {
        print("Couldn't print working directory")
    }
    
    if !fileManager.fileExists(atPath: filePath) {
        do {
            print("Creating \(filePath)....")
            let process = Process(arguments: ["mkfifo", filePath])
            try process.launch()
            let result = try process.waitUntilExit()
            let output = try result.utf8Output()
            print(output)
        } catch {
            print("Pipe missing and could not create")
        }
    } else {
        print("\(filePath) exists.")
    }
    
    var fifo = Fifo(forReadingAtPath: filePath, callback: callback)
    
    /*
    #if os(Linux)
    guard var commandPipe =
    ReadabilityHandlerFileHandle(forReadingAtPath: filePath) else { fatalError("\"\(filePath)\" pipe does not exist") }
    #else
    guard var commandPipe =
    FileHandle(forReadingAtPath: filePath) else { fatalError("\"\(filePath)\" pipe does not exist") }
    #endif
    
    commandPipe.readabilityHandler =
    callback ?? { fileHandle in
    debugPrint("Executing default read handler....")
    let commandData = fileHandle.readDataToEndOfFile()
    guard let command = String(data: commandData, encoding: String.Encoding.utf8) else { print("Could not decode data"); return }
    print(command)
    }
    */
}

fileprivate func debugReceiver() {
    print("Debugging receiver....")
    /*
    let gpios = SwiftyGPIO.GPIOs(for:.RaspberryPi3)
    guard var irReceiver = gpios[.P26] else { fatalError("Cannot get IR Receiver pin ") }
    irReceiver.direction = .IN
    let lowBit = 1
    let highBit = abs(lowBit - 1)
    
    DispatchQueue(label: "receiver").async {
        while true {
            var value = lowBit
            // Loop until we get a signal (high bit)
            while value == lowBit {
                value = irReceiver.value
            }
            
            // Start time of the command
            var startTime = Date()
            // Holds command pulses
            var command: [(value: Int, pulseLength: TimeInterval)] = []
            // The end of the command happens when wed read more than a certain number of low bits
            var numberOfLowBits = 0
            // Keep track of transitions from low to high
            var previousValue = highBit
            
            while true {
                if value != previousValue {
                    // The value changed so calculate the length of this run
                    let now = Date()
                    let pulseLength = now.timeIntervalSince(startTime)
                    startTime = now
                    
                    command.append((previousValue, pulseLength))
                }
                if value == lowBit {
                    numberOfLowBits += 1
                } else {
                    numberOfLowBits = 0
                }
                // 1000 is arbitrary, adjust as necessary
                if numberOfLowBits > 10_000 {
                    break
                }
                previousValue = value
                value = irReceiver.value
            }
            print("---------Start----------")
            for (value, pulseLength) in command {
                print(value, pulseLength * 1_000_000)
            }
            print("----------End-----------")
            print("Size of array is \(command.count)")
            let binaryString = command
                .filter { (value, _) in
                    value == lowBit
                }.map { (_, duration) in
                    return (duration * 1_000_000) > 1000 ? 1 : 0
            }
            
            print("Binary String: \(binaryString.map(String.init).joined())")
            print("Bytes: \(binaryString.count / 8)")
            print("Binary      Decimal     Hex")
            var bytes = binaryString
            while bytes.count >= 8 {
                let byte = bytes[..<8]
                let binary = byte.map(String.init).joined()
                let decimal = Int(binary, radix: 2)!
                let hex = String(decimal, radix: 16)
                print("\(byte.map(String.init).joined())    \(decimal)\(String(repeating: " ", count: 12 - String(decimal).count))\(hex)")
                bytes.removeFirst(8)
            }
        }
    }
    */

}

func processArguments(_ args: [String]) {
    do {
        
        let argParser = ArgumentParser(commandName: "Pipes", usage: "Pipes [--poop poopString]", overview: "A utility for playing around with pipes.", seeAlso: "My butt.")
        
        let commandOption: OptionArgument<String> = argParser.add(option: "--command", shortName: "-c", kind: String.self, usage: "Pipes --command on|off|10|20|30|40|50|60|70|80|90|100")
        
        let positionalCommand = argParser.add(positional: "command", kind: String.self, optional: true)
        let pipeOption: OptionArgument<String> = argParser.add(option: "--pipe", shortName: "-p", kind: String.self, usage: "Pipes -p <path_of_pipe>", completion: ShellCompletion.filename)
        let debugReceiverOption = argParser.add(option: "--debug", shortName: "-d", kind: Bool.self, usage: "PiIR -d")
        
        print("Commandline args: \(args)")
        let parsedArguments = try argParser.parse(args)
        
        if parsedArguments.get(debugReceiverOption) == true {
            debugReceiver()
        }
        
        if let command = parsedArguments.get(commandOption) ?? parsedArguments.get(positionalCommand) {
            print("Command option present: \(command)")
            processCommand(command)
            exit(withExitCode: 0)
        }
        
        if let pipeFile = parsedArguments.get(pipeOption) {
            print("Pipe command present: \(pipeFile)")
            onPipe(filePath: pipeFile) { commandData in
                print("Received data")
                guard let command = String(data: commandData, encoding: String.Encoding.utf8) else { print("Could not decode data"); return }
                processCommand(command)
            }
            while true {}
        }
        
    } catch ArgumentParserError.expectedValue(let value) {
        print("Missing value for argument \(value).")
    } catch ArgumentParserError.expectedArguments(_, let stringArray) {
        print("Missing arguments: \(stringArray.joined()).")
    } catch {
        print(error.localizedDescription)
    }

}

func exit(withExitCode exitCode: Int32) {
    print("Exiting with exit code \(exitCode)...")
    exit(exitCode)
}

processArguments(Array(CommandLine.arguments.dropFirst()))

// If no options present
//import Darwin
while true {
    processCommand(readLine())
}

print("Oops too far")


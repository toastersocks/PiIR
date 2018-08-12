//
//  Fifo.swift
//  PiIR
//
//  Created by James Pamplona on 8/11/18.
//

import Foundation
import Dispatch

struct Fifo {
    let path: String
    private let callback: (Data) -> Void
    private let dispatchQueue = DispatchQueue(label: "readFifo")
    init(forReadingAtPath path: String, callback: @escaping ((Data) -> Void)) {
        self.path = path
        self.callback = callback
        
        dispatchQueue.async {
            while true {
//                print("About to open FIFO")
                guard let pipe = FileHandle(forReadingAtPath: path) else { print("Couldn't open FIFO"); exit(-1) }
//                print("FIFO opened.")
            
//                print("About to read data")
                let data = pipe.availableData
//                print("Data read")
                print(String(data: data, encoding: .utf8)!)
                callback(data)
            }
        }
    }
}

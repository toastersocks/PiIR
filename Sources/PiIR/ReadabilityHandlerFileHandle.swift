//
//  File.swift
//  PiIR
//
//  Created by James Pamplona on 8/2/18.
//

import Foundation
import Dispatch
import Basic

class ReadabilityHandlerFileHandle {
    private var _readHandler: ((FileHandle) -> Void)?
    let fileHandle: FileHandle
    let dispatchQueue = DispatchQueue(label: "readHandler")
    var process: Basic.Process = Process()
    var path: String = "./"
    
    init?(_ fileHandle: FileHandle?) {
        guard let fileHandle = fileHandle else { return nil }
        self.fileHandle = fileHandle
    }
    
    init?(forReadingAtPath path: String) {
        guard let fileHandle = FileHandle(forReadingAtPath: path) else { return nil }
        self.fileHandle = fileHandle
        self.path = path
    }
    
    var readabilityHandler: ((FileHandle) -> Void)? {
        set {
            do {
                process = Process(arguments: ["tail", "-f", path])
                try process.launch()
                dispatchQueue.async {
//                    let result = try process.wa
                }
            } catch {
                return
            }
        }
        get {
            return _readHandler
        }
    }
    
    var readabilityHandlerOld: ((FileHandle) -> Void)? {
        set {
            print("Setting new read handler")
            _readHandler = newValue
            dispatchQueue.async {
                while self._readHandler != nil {
                    self._readHandler!(self.fileHandle)
                    
                    /*
                     let data = self.fileHandle.readDataToEndOfFile()
                     
                     let afterData = self.fileHandle.readDataToEndOfFile()
                     print("Read data: \(String(data: data, encoding: .utf8))")
                     print("After data: \(String(data: afterData, encoding: .utf8))")
                     if !data.isEmpty {
                     print("Data is empty: \(data.isEmpty)")
                     print("After data is empty: \(afterData.isEmpty)")
                     }
                     sleep(1)
                     */
                    /*
                     if !data.isEmpty {
                     DispatchQueue.main.async {
                     print("Received new value...")
                     self._readHandler?(self.fileHandle)
                     }
                     }
                     */
                }
            }
        }
        get {
            return _readHandler
        }
    }
    
    /*
     override var readabilityHandler: ((FileHandle) -> Void)? {
     set {
     _readHandler = newValue
     DispatchQueue(label: "readHandler").async {
     while self._readHandler != nil {
     if !self.availableData.isEmpty {
     DispatchQueue.main.async {
     self._readHandler(self)
     }
     }
     }
     }
     }
     get {
     return _readHandler
     }
     }
     */
}

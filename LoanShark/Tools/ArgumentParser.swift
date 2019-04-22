//
//  ArgumentParser.swift
//  LoanShark
//
//  Created by Tyler Morgan on 4/19/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Foundation

enum ArgumentError: Error {
    case missingValue(String)
    case invalidType(value: String, type: String, argument: String? )
    case unsupportedArgument(String)
}

class ArgumentParser {
    struct Argument {
        let name: String?
        let help: String?
        let apply: (_ value: [String:String]) throws -> ()
        let isBool: Bool
    }
    
    private var validOptions: [String] {
        return arguments.compactMap { $0.name }
    }
    private var arguments: [Argument] = []
    
    private var argumentValues: [String:String] = [:]
    private var argumentCallbacks: [(_ values: [String:String]) throws -> ()] = []
    
    func parse() {
        if CommandLine.arguments.contains("--help") ||
            CommandLine.arguments.contains("-h")    ||
            CommandLine.arguments.contains("help") {
            self.printUsage()
        }
        else {
            for arg in CommandLine.arguments {
                if validOptions.contains(arg) {
                    
                    let index = CommandLine.arguments.firstIndex(of: arg)
                    let elementIndex = self.validOptions.firstIndex(of: arg)
                    let element = self.arguments[elementIndex ?? 0]
                    
                    if (self.arguments[elementIndex ?? 0]).isBool {
                        let value = true
                        self.argumentValues[arg] = String(describing: value)
                    }
                    else {
                        let value = CommandLine.arguments[(index ?? 0) + 1]
                        self.argumentValues[arg] = value
                    }
                    
                    self.argumentCallbacks.append(element.apply)
                }
            }
            
            if self.argumentCallbacks.count > 0 {
                for callback in self.argumentCallbacks {
                    do {
                        try callback(self.argumentValues)
                    } catch ArgumentError.invalidType(let v, let t, let a) {
                        Log.write(.fault, Log.Category.argumentParser, "Error occurred while converting \(v) into \(t) from argument \(String(describing: a)).")
                    } catch ArgumentError.unsupportedArgument(let a) {
                        Log.write(.fault, Log.Category.argumentParser, "Unsupported argument \(a) passed, add \"-h\" to read usage and requirements.")
                    } catch ArgumentError.missingValue(let v) {
                        Log.write(.fault, Log.Category.argumentParser, "Missing value for \(v)")
                    } catch {
                        Log.write(.fault, Log.Category.argumentParser, "Unknown error was thrown while parsing.")
                    }
                }
            }
        }
    }
    
    func addArgument(name: String, description help: String, isBool: Bool = false, callback: @escaping (_ value: [String:String]) throws -> ()) {
        let arg = Argument(name: name, help: help, apply: callback, isBool: isBool)
        self.arguments.append(arg)
    }
    
    private func printUsage() {
        for arg in self.arguments {
            print("\(arg.name ?? "") - \(arg.help ?? "")")
        }
        exit(0)
    }
}

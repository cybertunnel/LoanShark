//
//  ArgumentParser.swift
//  LoanShark
//
//  Created by Tyler Morgan on 4/19/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Cocoa

/**
 Errors thrown associated with the ArgumentParser class.
 */
enum ArgumentError: Error {
    case missingValue(String)
    case invalidType(value: String, type: String, argument: String? )
    case unsupportedArgument(String)
}

struct Argument {
    let name: String
    let description: String
    let isBool: Bool
    let callback: ([String:String]) throws -> Void
}
/**
 Parses the arguments passed to the application and stores those values and settings.
 */
class ArgumentParser {
    
    
    //  MARK: Structs
    
    /**
     Elements an argument must have.
     - Note: Apply is a function which gets called on when the argument is discovered.
    */
    struct Argument {
        let name: String?
        let help: String?
        let apply: (_ value: [String:String]) throws -> ()
        let isBool: Bool
    }
    
    
    //  MARK: Variables
    
    //  Arguments which are valid
    private var validOptions: [String] {
        return arguments.compactMap { $0.name }
    }
    
    private var arguments: [Argument] = []
    
    private var argumentValues: [String:String] = [:]
    private var argumentCallbacks: [(_ values: [String:String]) throws -> ()] = []
    
    
    //  MARK: Functions
    
    /**
     Parses the commndline arguments for the arguments requested.
    */
    func parse() {
        
        //  Does CommandLine contain help command?
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
    
    /**
     Adds argument to a list to parse later.
     
     - Parameters:
        - name: The parameter as String to monitor. Ex: `--title`
        - description: A description or usage information of the argument
        - isBool: Just monitor for the argument and set a true to false. *Default is false*
        - callback: Function which you want to run when the argument is discovered. Function is provided a [String:String] element for parsing
    */
    func addArgument(name: String, description help: String, isBool: Bool = false, callback: @escaping (_ value: [String:String]) throws -> ()) {
        let arg = Argument(name: name, help: help, apply: callback, isBool: isBool)
        self.arguments.append(arg)
    }
    
    /**
     Prints the usage of the provided arguments.
     */
    private func printUsage() {
        for arg in self.arguments {
            print("\(arg.name ?? "") - \(arg.help ?? "")")
        }
        NSApp.terminate(self)
        exit(0)
    }
}

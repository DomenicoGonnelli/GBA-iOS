//
//  Input+Display.swift
//  Delta
//
//  Created by Darlion on 8/15/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

import GameCore

extension Input
{
    // With the default GameControllerInputMapping files, multiple controller inputs may map to the same game input.
    // This is because each controller input maps to a unique standard input, but then multiple standard inputs may map to same game input.
    // To ensure we only show the most "important" controller input for a game input, we define general "display priorities" for each input.
    //
    // For example, MFiGameController.down and MFiGameController.leftThumbstickDown both map to a "down" game input.
    // However, .down has a higher priority than .leftThumbstickDown, so we show .down instead of .leftThumbstickDown.
    var displayPriority: Int {
        switch self.type
        {
        case .game: break
        case .controller(.standard): break
        case .controller(.mfi):
            let input = MFiGameController.Input(input: self)!
            switch input
            {
            case .leftThumbstickUp: return 750
            case .leftThumbstickDown: return 750
            case .leftThumbstickLeft: return 750
            case .leftThumbstickRight: return 750
            case .leftShoulder: return 750
            case .leftTrigger: return 500
            case .rightShoulder: return 750
            case .rightTrigger: return 500
            default: break
            }
        
        case .controller(.keyboard):
            let input = KeyboardGameController.Input(input: self)!
            
            if input == .escape
            {
                // The iPad Smart Keyboard doesn't have an escape key, so return lower priority
                // to ensure it only appears if there is no other key mapped to the same input.
                return 100
            }
            
            // We prefer to display keys with special characters (e.g. arrow keys, shift) over regular keys.
            // If the input's localizedName == it's string value, we can assume it's a normal key, and return a lower priority.
            // Otherwise, it has a special display character, and so we return a higher priority.
            if input.localizedName == input.stringValue.uppercased()
            {
                return 500
            }
            else
            {
                return 1000
            }
            
        default: break
        }
        
        return 1000
    }
    
    var localizedName: String {
        switch self.type
        {
        case .game: break
        case .controller(.standard):
            let input = StandardGameControllerInput(input: self)!
            switch input
            {
            case .menu: return "Menu".localizable
            case .up: return "Up".localizable
            case .down: return "Down".localizable
            case .left: return "Left".localizable
            case .right: return "Right".localizable
            case .leftThumbstickUp: return "L🕹↑".localizable
            case .leftThumbstickDown: return "L🕹↓".localizable
            case .leftThumbstickLeft: return "L🕹←".localizable
            case .leftThumbstickRight: return "L🕹→".localizable
            case .rightThumbstickUp: return "R🕹↑".localizable
            case .rightThumbstickDown: return "R🕹↓".localizable
            case .rightThumbstickLeft: return "R🕹←".localizable
            case .rightThumbstickRight: return "R🕹→".localizable
            case .a: return "A".localizable
            case .b: return "B".localizable
            case .x: return "X".localizable
            case .y: return "Y".localizable
            case .start: return "Start".localizable
            case .select: return "Select".localizable
            case .l1: return "L1".localizable
            case .l2: return "L2".localizable
            case .l3: return "L3".localizable
            case .r1: return "R1".localizable
            case .r2: return "R2".localizable
            case .r3: return "R3".localizable
            }
            
        case .controller(.mfi):
            let input = MFiGameController.Input(input: self)!
            switch input
            {
            case .menu: return "Menu".localizable
            case .up: return "Up".localizable
            case .down: return "Down".localizable
            case .left: return "Left".localizable
            case .right: return "Right".localizable
            case .leftThumbstickUp: return "L🕹↑".localizable
            case .leftThumbstickDown: return "L🕹↓".localizable
            case .leftThumbstickLeft: return "L🕹←".localizable
            case .leftThumbstickRight: return "L🕹→".localizable
            case .rightThumbstickUp: return "R🕹↑".localizable
            case .rightThumbstickDown: return "R🕹↓".localizable
            case .rightThumbstickLeft: return "R🕹←".localizable
            case .rightThumbstickRight: return "R🕹→".localizable
            case .a: return "A".localizable
            case .b: return "B".localizable
            case .x: return "X".localizable
            case .y: return "Y".localizable
            case .leftShoulder: return "L1".localizable
            case .leftTrigger: return "L2".localizable
            case .rightShoulder: return "R1".localizable
            case .rightTrigger: return "R2".localizable
            case .start: return "Start".localizable
            case .select: return "Select".localizable
            }
            
        case .controller(.keyboard):
            let input = KeyboardGameController.Input(input: self)!
            switch input
            {
            case .up: return "↑".localizable
            case .down: return "↓".localizable
            case .left: return "←".localizable
            case .right: return "→".localizable
            case .escape: return "⎋".localizable
            case .shift: return "⇧".localizable
            case .command: return "⌘".localizable
            case .option: return "⌥".localizable
            case .control: return "Ctrl".localizable
            case .capsLock: return "⇪".localizable
            case .space: return "Space".localizable
            case .return: return "↩\u{FE0E}".localizable
            case .tab: return "⇥".localizable
            default: return input.stringValue.uppercased()
            }
            
        default: break
        }
        
        return ""
    }
}

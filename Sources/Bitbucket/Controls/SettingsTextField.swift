//
//  SettingsTextField.swift
//  Bitbucket
//
//  Created by Igor Redchuk on 03/09/16.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import Cocoa

class SettingsTextField: NSTextField {

    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        if event.type == NSEventType.keyDown {
            let keyModifier = event.modifierFlags.rawValue & NSEventModifierFlags.deviceIndependentFlagsMask.rawValue
            if keyModifier == NSEventModifierFlags.command.rawValue {
                switch event.charactersIgnoringModifiers! {
                    case "x":
                        return NSApp.sendAction(#selector(NSText.cut(_:)), to:nil, from:self)
                    case "c":
                        return NSApp.sendAction(#selector(NSText.copy(_:)), to:nil, from:self)
                    case "v":
                        return NSApp.sendAction(#selector(NSText.paste(_:)), to:nil, from:self)
                    default:
                        break
                }
            }
        }
        return super.performKeyEquivalent(with: event)
    }
}

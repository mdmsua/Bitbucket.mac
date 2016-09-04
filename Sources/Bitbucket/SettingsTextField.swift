//
//  SettingsTextField.swift
//  Bitbucket
//
//  Created by Igor Redchuk on 03/09/16.
//  Copyright © 2016 Dmytro Morozov. All rights reserved.
//

import Cocoa

class SettingsTextField: NSTextField {

    override func performKeyEquivalent(event: NSEvent) -> Bool {
        if event.type == NSEventType.KeyDown {
            let keyModifier = event.modifierFlags.rawValue & NSEventModifierFlags.DeviceIndependentModifierFlagsMask.rawValue
            if keyModifier == NSEventModifierFlags.CommandKeyMask.rawValue {
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
        return super.performKeyEquivalent(event)
    }
}
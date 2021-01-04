//
//  Formatting.swift
//  GiftClub
//
//  Created by Stanislav Kaluzhnyi on 28/02/17.
//  Copyright © 2017 simbirsoft. All rights reserved.
//

import Foundation

extension CharacterSet {
    func contains(_ character: Character) -> Bool {
        let scalar = String(character).unicodeScalars.first!
        return contains(scalar)
    }
}
/*
 Приводит string в соответствие с mask, где места для подстановки помечены символом wildcard.
 Если string длиннее mask, то лишние символы справа обрезаются.
 Символы в маске, которые заданы жестко не должны пересекаться с символами, допустимыми для подстановки.
 */
func format(string: String, mask: String, changedAt: String.Index, wildcard: Character = "#") -> String {
    var index = changedAt
    var formatted = string
    let hardcodedCharacters = String(mask.filter({$0 != wildcard}))
    let possibleInput = CharacterSet(charactersIn: hardcodedCharacters).inverted
    
    while (index < min(formatted.endIndex, mask.endIndex)) {
        let curChar = formatted[index]
        let maskChar = mask[index]
        
        switch (possibleInput.contains(curChar), maskChar == wildcard) {
        case (true, true), (false, false):
            index = formatted.index(after: index)
        case (false, true):
            formatted.remove(at: index)
        case (true, false):
            formatted.insert(mask[index], at: index)
            index = formatted.index(after: index)
        }
    }
    
    if (formatted.endIndex > mask.endIndex) {
        formatted = String(formatted.prefix(mask.count))
    }
    
    return formatted
}

func formatting_dbg() {
    let mask = "##-###-##"
    var text = "1"
    text = format(string: "1", mask: mask, changedAt: text.startIndex)
    text = format(string: "11", mask: mask, changedAt: text.startIndex)
    text = format(string: "111", mask: mask, changedAt: text.startIndex)
    text = format(string: "1-1", mask: mask, changedAt: text.index(after: text.startIndex))
    text = format(string: "11-1-11", mask: mask, changedAt: text.startIndex)
    text = format(string: "11-1111", mask: mask, changedAt: text.index(before: text.endIndex))
    text = format(string: "11-111-111", mask: mask, changedAt: text.index(before: text.endIndex))
}

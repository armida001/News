    //
    //  TextMaskingAndValidation.swift
    //  Humans
    //
    //  Created by Evgeniy Gubin on 01.02.17.
    //  Copyright © 2017 simbirsoft. All rights reserved.
    //
    
    import Foundation
    
    protocol TextFieldMask {
        
        func format(text: String, from: String.Index?) -> String
        func unformat(text: String) -> String
        func accepts(string: String) -> Bool
        
        func isPatternCharacter(atIndex index: Int, formatted: String) -> Bool
    }
    
    class BasicTextFieldMask: TextFieldMask {
        var pattern: String;
        let placeholder: Character;
        let allowedCharacters: CharacterSet
        
        
        init(pattern: String = "", placeholder: Character = "*", allowedCharacters: CharacterSet) {
            self.pattern = pattern
            self.placeholder = placeholder;
            self.allowedCharacters = allowedCharacters
        }
        
        func format(text: String, from: String.Index? = nil) -> String {
            let from = from ?? text.startIndex
            return format(string: text, mask: pattern, changedAt: from, wildcard: placeholder)
        }
        
        func unformat(text: String) -> String {
            let hardcodedCharacters = String(pattern.filter { $0 != placeholder } )
            let possibleInput = CharacterSet(charactersIn: hardcodedCharacters).inverted
            
            return String(text.filter { possibleInput.contains($0) } )
        }
        
        
        func isPatternCharacter(atIndex index: Int, formatted: String) -> Bool {
            if index < 0 {
                return false
            }
            var character: String = ""
            if formatted.count > index {
                character = String(formatted.dropFirst(index).first ?? Character(""))
            }
            return pattern.contains(character)
        }
        
        func accepts(string: String) -> Bool {
            return !string.contains { !allowedCharacters.contains($0) }
        }
        
        /*
         Приводит string в соответствие с mask, где места для подстановки помечены символом wildcard.
         Если string длиннее mask, то лишние символы справа обрезаются.
         Символы в маске, которые заданы жестко не должны пересекаться с символами, допустимыми для подстановки.
         */
        private func format(string: String, mask: String, changedAt: String.Index, wildcard: Character = "#") -> String {
            var index = changedAt
            var formatted = string
            let hardcodedCharacters = String(mask.filter({$0 != wildcard}))
            let possibleInput = CharacterSet(charactersIn: hardcodedCharacters).inverted
            
            while (index < min(formatted.endIndex, mask.endIndex)) {
                let curChar = formatted[index]
                let maskChar = mask[index]
                
                if !CharacterSet(charactersIn: hardcodedCharacters).union(allowedCharacters).contains(curChar) {
                    formatted.remove(at: index)
                    continue
                }
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
            
            formatted = formatted.trimmingCharacters(in: .whitespaces)
            return formatted
        }
    }
    
    class AnyInputMask: TextFieldMask {
        
        func format(text: String, from: String.Index?) -> String {
            return text
        }
        
        internal func unformat(text: String) -> String {
            return text
        }
        
        func accepts(string: String) -> Bool {
            return true
        }
        
        func isPatternCharacter(atIndex index: Int, formatted: String) -> Bool {
            return false
        }
    }
    
    class PhoneNumberCodeInputMask: BasicTextFieldMask {
        override func format(text: String, from: String.Index?) -> String {
            var text = super.format(text: text, from: from)
            
            let pattern = String(text.dropFirst())
            if let firstCharacter = pattern.first, text.endIndex < self.pattern.endIndex {
                let secondChar = pattern.suffix(pattern.count-1)
                switch (firstCharacter, secondChar) {
                case ("7", ""), ("8", ""), ("9", _): break
                case ("7", "9"), ("8", "9"), (_, ""):
                    text = "(9"
                case ("7", _), ("8", _):
                    text = String(text.dropFirst())
                    fallthrough
                default:
                    text = String(text.dropFirst())
                    text = "(9" + text
                }
            }
            
            return text
        }
    }
    
    class PhonenumberInputMask: BasicTextFieldMask {
        
        override func format(text: String, from: String.Index?) -> String {
            
            var text = formate7(text: text, from: from)
            text = super.format(text: text, from: from)
            
            if !text.isEmpty {
                text = "+" + text
            }
            return text
        }
        
        func formate7(text: String, from: String.Index?) -> String {
            var text = text
            
            if let firstCharacter = text.first, text.endIndex < pattern.endIndex {
                switch firstCharacter {
                case "7":
                    if !String(text.dropFirst()).isEmpty {
                        text = String(text.dropFirst())
                        if let secondCharacter = text.first, text.endIndex < pattern.endIndex {
                            if secondCharacter != "9" {
                                text = String(text.dropFirst())
                                text = "79" + text
                            } else {
                                text = "7" + text
                            }
                        }
                    }
                    
                case "8":
                    text = String(text.dropFirst())
                    text = "7" + text
                case "9":
                    text = "7" + text
                default:
                    text = String(text.dropFirst())
                    text = "79" + text
                }
            }
            return text
        }
        
        override func unformat(text: String) -> String {
            var unformattedText = super.unformat(text: text)
            
            if unformattedText.first == "+" {
                unformattedText.removeFirst()
            }
            
            return unformattedText
        }
    }
    
    class PhonenumberWithoutCodeInputMask: BasicTextFieldMask {
        
        override func format(text: String, from: String.Index?) -> String {
            var text = text
            let firstCharacter = text.first
            if firstCharacter != nil && text.endIndex < pattern.endIndex && text != "9" {
                text = "9"+String(text.dropFirst())
            }
            return super.format(text: text, from: from)
        }
    }
    
    class AsciiLettersInputMask: AnyInputMask {
        override func format(text: String, from: String.Index?) -> String {
            var formatted = ""
            
            text.forEach {
                let char = String($0)
                formatted += char.canBeConverted(to: .ascii) ? char: ""
            }
            return formatted
        }
    }
    
    protocol TextValidator {
        func isValide(text: String) -> Bool
    }
    
    class BasicTextValidator {
        let minLength: Int = 0
        let maxLength: Int = Int.max;
        
        var filtersUserInput: Bool {
            return false;
        }
        
        func isValide(text: String) -> Bool {
            return true;
        }
    }
    
    class RegexTextValidator: TextValidator {
        let regex: String
        let predicate: NSPredicate
        
        init(regex: String) {
            self.regex = regex;
            self.predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        }
        
        func isValide(text: String) -> Bool {
            return predicate.evaluate(with: text)
        }
    }

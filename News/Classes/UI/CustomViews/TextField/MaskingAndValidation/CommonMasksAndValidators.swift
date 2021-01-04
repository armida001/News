//
//  CommonMasksAndValidators.swift
//  Humans
//
//  Created by Evgeniy Gubin on 01.02.17.
//  Copyright © 2017 simbirsoft. All rights reserved.
//

import Foundation


enum TextFieldMasks {
    private static var doubleDigits: CharacterSet {
        var allowedCharacters: CharacterSet = .decimalDigits
        allowedCharacters.insert(charactersIn: ".,")
        return allowedCharacters
    }
    
    static var phoneNumberWithoutCode: TextFieldMask {
        return PhonenumberWithoutCodeInputMask(
            pattern: "(***) ***-**-**",
            placeholder: "*",
            allowedCharacters: .decimalDigits)
    }
    
    static var phoneNumber: TextFieldMask {
        return PhonenumberInputMask(
            pattern: "* (***) ***-**-**",
            placeholder: "*",
            allowedCharacters: .decimalDigits)
    }
    
    static var code: TextFieldMask {
        return BasicTextFieldMask(
            pattern: "****",
            placeholder: "*",
            allowedCharacters: .decimalDigits)
    }
    
    static var period: TextFieldMask {
        return BasicTextFieldMask(
            pattern: "**.**.****",
            placeholder: "*",
            allowedCharacters: .decimalDigits)
    }
    
    static var asciiLettersOnly: TextFieldMask {
        return AsciiLettersInputMask()
    }
    
    static var cardNumber: TextFieldMask {
        return BasicTextFieldMask(
            pattern: "**** **** **** **** ***",
            placeholder: "*",
            allowedCharacters: .decimalDigits)
    }
    
    static var cardDate: TextFieldMask {
        return BasicTextFieldMask(
            pattern: "**",
            placeholder: "*",
            allowedCharacters: .decimalDigits)
    }
    
    static var cvv: TextFieldMask {
        return BasicTextFieldMask(
            pattern: "***",
            placeholder: "*",
            allowedCharacters: .decimalDigits)
    }
    
    static var noMask: TextFieldMask {
        return AnyInputMask()
    }
}

enum TextValidators {
    static var phoneNumber: TextValidator {
        return RegexTextValidator(regex: "^\\+{0,1}\\d{1} \\(\\d{3}\\) \\d{3}-\\d{2}-\\d{2}$")
    }
    
    static var phoneNumberWithoutCode: TextValidator {
        return RegexTextValidator(regex: "^\\(\\d{3}\\) \\d{3}-\\d{2}-\\d{2}$")
    }
    
    static var code: TextValidator {
        return RegexTextValidator(regex: "^\\d{4}$")
    }
    
    static var zipCode: TextValidator {
        return RegexTextValidator(regex: "^\\d{5,9}$")
    }
    
    static var amount: TextValidator {
        return RegexTextValidator(regex: "^\\d+[.,]{0,1}\\d{0,2}$")
    }
    
    static var email: TextValidator {
        return RegexTextValidator(regex:"^[a-zA-Z0-9.+%-_]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9][a-zA-Z0-9-]{0,30}[a-zA-Z0-9])+$")
    }
    
    static var firstName: TextValidator {
        return RegexTextValidator(regex: "[a-zA-zа-яёА-ЯЁ ]+([- \(String.hyphenCharacter)][a-zA-Zа-яёА-ЯЁ]+)*")
    }
    
    static var name: TextValidator {
        return RegexTextValidator(regex: "^[^?]{2,}$")
    }
    
    static var username: TextValidator {
        return RegexTextValidator(regex: "^[A-z0-9_]{3,15}$")
    }
    
    static var password: TextValidator {
        return RegexTextValidator(regex: "^[a-zA-z0-9+\\-/=.,:;<>_!?@#$%^&*~'\\\\\"|\\(\\)\\{\\}\\[\\]]{8,32}$")
    }
    
    static var any: TextValidator {
        return RegexTextValidator(regex: "^.+$")
    }
    
    static var period: TextValidator {
        return RegexTextValidator(regex: "^(?:(?:31(\\.)(?:0?[13578]|1[02]|(?:Jan|Mar|May|Jul|Aug|Oct|Dec)))\\1|(?:(?:29|30)(\\.)(?:0?[1,3-9]|1[0-2]|(?:Jan|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec))\\2))(?:(?:1[9]|[2-9]\\d)?\\d{2})$|^(?:29(\\.)(?:0?2|(?:Feb))\\3(?:(?:(?:1[9]|[2-9]\\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\\d|2[0-8])(\\.)(?:(?:0?[1-9]|(?:Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep))|(?:1[0-2]|(?:Oct|Nov|Dec)))\\4(?:(?:1[9]|[2-9]\\d)?\\d{2})$")
    }
    
    static var integer: TextValidator {
        return RegexTextValidator(regex: "^\\d*$")
    }
    
    static var double: TextValidator {
        return RegexTextValidator(regex: "^-?\\d+(?:.\\d+)?$")
    }
    
    static var nameRussianLettersOnly: TextValidator {
        return RegexTextValidator(regex: "^[а-яА-я\\s-]+$")
    }
    
    static var cardNumber: TextValidator {
        return RegexTextValidator(regex: """
            ^(?:\
            (?<visa>4[0-9 ]{15}((?:[0-9]{3})|(?:[0-9 ]{7}))?)\
            |(?<mastercard>(?:5[1-5][0-9]{2}|222[1-9]|22[3-9][0-9]|2[3-6][0-9]{2}|27[01][0-9]|2720)[0-9 ]{15})\
            |(?<maestro>((:?5[0678])|(:?6[0-9]))[0-9 ]{12,21})\
            |(?<mir>220[0-4][0-9 ]{15})\
            )$
            """)
    }
    
    static var cardDate: TextValidator {
        return RegexTextValidator(regex: "\\d{2}$")
    }
    
    static var cvv: TextValidator {
        return RegexTextValidator(regex: "^\\d{3}$")
    }
    
    static var cardHolder: TextValidator {
        return RegexTextValidator(regex: "^[A-Z\\s\\.]{3,}$")
    }
    
    static var cardHolderAllLetters: TextValidator {
        return RegexTextValidator(regex: "^.{3,}$")//"^[.+[^\\d]]{3,}$") - вариант исключающий цифры
    }
}

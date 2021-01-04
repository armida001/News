//
//  StringExtension.swift
//  iOS-Platform
//
//  Created by Andrey Chernyshev on 01.11.16.
//  Copyright © 2016 simbirsoft. All rights reserved.
//

import UIKit
import Rswift

extension Character {
    static var hyphenCharacter: Character {
        return Character("\u{002D}")
    }
}

extension String {
    
    func boldRangeOf(searchedString: String?, allBold: Bool = false) -> NSRange? {
        var boldRange: NSRange?
        
        if allBold {
            boldRange = NSRange.init(location: 0, length: self.count)
        } else
            if let sStr = searchedString {
                if sStr.count > self.count {
                    boldRange = NSRange.init(location: 0, length: self.count)
                } else {
                    boldRange = self.lowercased().rangeOfString(subString: sStr.lowercased())
                }
        }
        return boldRange
    }
    
    var asBase64: String {
        let data = self.data(using: String.Encoding.utf8)
        return data!.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
    
    subscript (i: Int) -> Character {
        let index = self.index(self.startIndex, offsetBy: i)
        return self[index]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    static var hyphenCharacter: String {
        return String(Character.hyphenCharacter)
    }
    
    func rangeOfString(subString: String) -> NSRange? {
        let range1 = self.range(of: subString)
        if let subStartIndex = range1?.lowerBound {
            let distance = self.distance(from: self.startIndex, to: subStartIndex)
            return NSRange(location: distance, length: subString.count)
        }
        return nil
    }
    
    func attributedString(underlineString: String, attributes: [NSAttributedString.Key : Any]) -> NSAttributedString {
        if let range = self.rangeOfString(subString: underlineString) {
            return self.attributedString(range: range, attributes: attributes)
        }
        return NSMutableAttributedString(string: self, attributes: attributes)
    }
    
    func attributedString(range: NSRange?, attributes: [NSAttributedString.Key : Any], _ underlineAttributes: [NSAttributedString.Key : Any]? = nil) -> NSAttributedString {
        var attributes = attributes
        if let range = range {
            let string = self
            let startString = String(string.prefix(range.location))
            var endString = String(string.dropFirst(range.location))
            let underlineString = String(endString.prefix(range.length))
            endString = String(endString.dropFirst(range.length))
            
            let startAttributedString = NSMutableAttributedString(string: startString, attributes: attributes)
            let endAttributedString = NSMutableAttributedString(string: endString, attributes: attributes)
            attributes[NSAttributedString.Key.underlineStyle] = NSUnderlineStyle.single.rawValue
            var underlineAttributedString = NSMutableAttributedString(string: underlineString, attributes: attributes)
            
            if let underlineAttributes = underlineAttributes {
                underlineAttributedString = NSMutableAttributedString(string: underlineString, attributes: underlineAttributes)
            }
            
            startAttributedString.append(underlineAttributedString)
            startAttributedString.append(endAttributedString)
            return startAttributedString
        }
        return NSMutableAttributedString(string: self, attributes: attributes)
    }
    
    func capitalizingFirstLetter() -> String {
        let first = self.prefix(1).capitalized
        let other = self.dropFirst().lowercased()
        return first + other
    }
    
    static func attributedHTMLString(from text: String?, _ align: NSTextAlignment = .left) -> NSAttributedString? {
        if let htmlData = text?.data(using: String.Encoding.unicode) {
            do {
                let attribStr = try NSMutableAttributedString(data: htmlData, options: convertToNSAttributedStringDocumentReadingOptionKeyDictionary([ convertFromNSAttributedStringDocumentAttributeKey(NSAttributedString.DocumentAttributeKey.documentType): convertFromNSAttributedStringDocumentType(NSAttributedString.DocumentType.html)]), documentAttributes: nil)
                return attribStr
            } catch let e as NSError {
                print("Couldn't translate \(text): \(e.localizedDescription) ")
            }
        }
        return nil
    }
    
    static func htmlHasLastSpaceTag(_ nText: String?) -> Bool {        
        if let text = nText {
            return text.hasSuffix("</p>") || text.hasSuffix("<p>")
        }
        return false
    }
    
    func decodeURLString(with prefix: String) -> String {
        let oldStr = self
        
        if self.contains("?") {
            let substrings = self.split(separator: "?")
            var strUrl = ""
            for (index, substr) in substrings.enumerated() {
                if let str = substr.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), index > 0 {
                    if index < substrings.count - 1 {
                        strUrl += (str + "?")
                    } else {
                        strUrl += str
                    }
                } else {
                    if index < substrings.count - 1 {
                        strUrl += (substr + "?")
                    } else {
                        strUrl += substr
                    }
                }
            }
            return strUrl
        } else {
            return oldStr
        }
    }
    
    func safariURLString() -> String {
        let httpPrefix = "http://"
        let httpsPrefix = "https://"
        if self.lowercased().hasPrefix(httpPrefix) {
            return self.decodeURLString(with: httpPrefix)
        } else if self.lowercased().hasPrefix(httpsPrefix) {
            return self.decodeURLString(with: httpsPrefix)
        } else {
            return httpPrefix + self.decodeURLString(with: "")
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringDocumentReadingOptionKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.DocumentReadingOptionKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.DocumentReadingOptionKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringDocumentAttributeKey(_ input: NSAttributedString.DocumentAttributeKey) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringDocumentType(_ input: NSAttributedString.DocumentType) -> String {
	return input.rawValue
}

extension NSAttributedString {
    func toMutable() -> NSMutableAttributedString {
        if let attr = self as? NSMutableAttributedString {
            return attr
        }
        
        return NSMutableAttributedString(attributedString: self)
    }
    
    static func toMutable(_ attr : NSAttributedString?) -> NSMutableAttributedString {
        // " " space is required!!!
        return (attr == nil) ? NSMutableAttributedString(string:" ") : attr!.toMutable()
    }
    
}

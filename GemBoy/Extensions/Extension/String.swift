//
//  String.swift
//  SanremoFantasy
//
//  Created by EGONNEDGJ on 09/01/23.
//

import Foundation
import UIKit

extension String {
    
    var range: NSRange {
        return NSRange.init(0..<self.utf16.count)
    }

    func remove(_ character: Character) -> String {
        let splitted = self.split(separator: character)
        if splitted.count>0 {
            var textSplitted = "";
            for i in 0..<splitted.count {
                textSplitted.append(contentsOf: splitted[i])
            }
            return textSplitted
        }
        
        return self
    }
    
    func removeSpace() -> String {
        let splitted = self.split(separator: " ")
        if splitted.count>0 {
            var textSplitted = "";
            for i in 0..<splitted.count {
                textSplitted.append(contentsOf: splitted[i])
                if i != splitted.count - 1 {
                    textSplitted.append(" ")
                }
            }
            return textSplitted
        }
        if self.contains(where: {!$0.isWhitespace}){
            return self
        }
        return ""
    }
    func getTextIntoTags(openTag: String, closedTag: String) -> [String]{
        
        var list : [String] = []
        guard self.contains(openTag) && self.contains(closedTag) else {return list}
        let pattern = "\(openTag)(.*?)\(closedTag)";
        do {
            
            let regexMatcher = try NSRegularExpression(pattern: pattern, options: [])
            let matchColl = regexMatcher.matches(in: self, options: [], range: self.range)

            for match in matchColl {
                guard let matchrange = Range(match.range, in: self) else { return list }
                let subString = self[matchrange.lowerBound..<matchrange.upperBound]
                let stringAttributed = NSMutableAttributedString(string: String(subString))
                stringAttributed.replaceCharacters(in: openTag.range, with: "")
                var stringFinal = stringAttributed.string
                stringFinal = stringFinal.replacingOccurrences(of: closedTag, with: "")
                list.append(stringFinal)
            }
            return list
            
        }
        catch {
            return list
        }
    }
    
    var changeTeamToName: String{
        
        var t = self
        t = t.replacingOccurrences(of: "_", with: " ").lowercased()
        var split = t.split(separator: " ")
        var team = ""
        for i in split {
            var item = String(i)
            let first = item.removeFirst()
            team.append(String(first).uppercased())
            team.append(item)
            team.append(" ")
        }
        return team
        
    }
    
}

import Foundation
import UIKit


public enum FontStyle : String {
    case
    bold =          "GothamRounded-Bold",
    boldItal =      "GothamRounded-BoldItal",
    book =          "GothamRounded-Book",
    bookItal =      "GothamRounded-BookItal",
    light =         "GothamRounded-Light",
    lightItal =     "GothamRounded-LightItal",
    mediumItal =    "GothamRounded-MedItal",
    medium =        "GothamRounded-Medium",
    orbitronRegular =   "Orbitron-Regular",
    orbitronBold =      "Orbitron-Bold",
    orbitronExtraBold = "Orbitron-ExtraBold",
    orbitronSemiBold =  "Orbitron-SemiBold",
    orbitronMedium =    "Orbitron-Medium",
    orbitronBlack =     "Orbitron-Black"
}

extension String {

    /**
     Length of the string.
     */
    var length: Int {
        return count
    }
    
    func toJSON() -> Any? {
        var reduced = self.replacingOccurrences(of: "\u{00A0}", with: "").replacingOccurrences(of: "\\", with: "")
        guard let data = reduced.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options : .allowFragments)
    }
    
    
    /**
     Returns the currency.
     */
    var currency: String {
        switch self {
        case "EUR", "E", "€":
            return "€"
        default:
            return self
        }
    }
    
    var withoutWhitespaces: String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    var rightTrim: String {
        return self.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
    }
    
    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func attributedString(fontStyle: FontStyle, size: CGFloat, color: UIColor? = nil, kern: Float? = nil, lineSpacing: CGFloat? = nil, alignment: NSTextAlignment? = nil) -> NSMutableAttributedString {
        
        var attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font : UIFont(name: fontStyle.rawValue, size: size)!]
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        
        if let color = color {
            attributes.updateValue(color, forKey: NSAttributedString.Key.foregroundColor)
        }
        
        if let kern = kern {
            attributes.updateValue(kern, forKey: NSAttributedString.Key.kern)
        }
        
        if let lineSpacing = lineSpacing {
            paragraphStyle.lineSpacing = lineSpacing
        }
        
        
        // If defined, set text alignment
        if let alignment = alignment {
            paragraphStyle.alignment = alignment
        }
        
        
        let attributedString = NSMutableAttributedString(string: self, attributes: attributes)
        
        if lineSpacing != nil || alignment != nil {
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: attributedString.string.range)
        }
        
        return attributedString
    }
    

    func substring(from: Int?, to: Int?) -> String {
        if let start = from {
            guard start < self.count else {
                return ""
            }
        }
        
        if let end = to {
            guard end >= 0 else {
                return ""
            }
        }
        
        if let start = from, let end = to {
            guard end - start >= 0 else {
                return ""
            }
        }
        
        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }
        
        let endIndex: String.Index
        if let end = to, end >= 0, end < self.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }
        
        return String(self[startIndex ..< endIndex])
    }
    
    
    func substring(from: Int) -> String {
        return self.substring(from: from, to: nil)
    }
    
    func substring(to: Int) -> String {
        return self.substring(from: nil, to: to)
    }
    
    /**
     Return substring starting from "from" paramater with length equal to "length" parameter.
     - parameter from: Staring Index.
     - parameter length: Length if interval.
     */
    func substring(from: Int?, length: Int) -> String {
        guard length > 0 else {
            return ""
        }
        
        let end: Int
        if let start = from, start > 0 {
            end = start + length - 1
        } else {
            end = length - 1
        }
        
        return self.substring(from: from, to: end)
    }
    
    /**
     Return substring finishing to "to" index with length "length" parameter.
     - parameter length: Length if interval.
     - parameter to: Ending Index.
     */
    func substring(length: Int, to: Int?) -> String {
        guard let end = to, end > 0, length > 0 else {
            return ""
        }
        
        let start: Int
        if let end = to, end - length > 0 {
            start = end - length + 1
        } else {
            start = 0
        }
        
        return self.substring(from: start, to: to)
    }
    
    /**
     Decode string from base 64
    */
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    /**
     Encode string with base 64
    */
    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
    
    
    public func chunk(n: IndexDistance) -> [SubSequence] {
        var res: [SubSequence] = []
        var i = startIndex
        var j: Index
        while i != endIndex {
            j = index(i, offsetBy: n, limitedBy: endIndex) ?? endIndex
            res.append(self[i..<j])
            i = j
        }
        return res
    }
    
    func chunkFormatted(withChunkSize chunkSize: Int = 4,
        withSeparator separator: Character = "-") -> String {
        return self.filter { $0 != separator }.chunk(n: chunkSize).map{ String($0) }.joined(separator: String(separator))
    }
    
    func isTheSameAppVerion(of comparing: String?) -> Bool{
        guard let comparing = comparing else { return false}
        return self.majorVersionPart == comparing.majorVersionPart
    }
    
    var majorVersionPart : String {
        var selfSplit = self.split(separator: ".")
        selfSplit.removeLast()
        return selfSplit.joined(separator: ".")
    }
    
   
    
    func attributesWithTag(fontSize: CGFloat, color: UIColor?) -> NSMutableAttributedString{
        var attr = NSMutableAttributedString(string: self)
        attr.setFontTagEffects(size: fontSize, color: color)
        attr.addLineSpacing(lineSpacing: 6, alignment: .left)
        return attr
    }

}

extension NSAttributedString{
    func toMutable() -> NSMutableAttributedString{
        return NSMutableAttributedString(attributedString: self)
    }
}


extension NSMutableAttributedString {
    
    func removeUnderline() {
        self.removeAttribute(NSAttributedString.Key.underlineStyle, range: self.string.range)
    }
    
    func addLineSpacing(lineSpacing: CGFloat, alignment: NSTextAlignment?) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        // If defined, set text alignment
        if let alignment = alignment {
            paragraphStyle.alignment = alignment
        }
        
        self.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: self.string.range)
    }
    
    
    public func setAsLink(textToFind: String){
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: foundRange)
        }
    }
    
    public func setFontTagEffects(size: CGFloat, color: UIColor?){
        setBoldText(size: size, color: color)
        setMediumText(size: size, color: color)
        setUnderlinedText(size: size, color: color)
    }
    
    public func setBoldText(size: CGFloat, color: UIColor?){
        setAttributedTextForTag(openTag: "<b>", closedTag: "</b>", size: size, fontFamily: .bold, color: color)
    }
    
    public func setMediumText(size: CGFloat, color: UIColor?){
        setAttributedTextForTag(openTag: "<m>", closedTag: "</m>", size: size, fontFamily: .medium, color: color)
    }
    
    public func setUnderlinedText(size: CGFloat, color: UIColor?){
        setAttributedTextForTag(openTag: "<u>", closedTag: "</u>", size: size, fontFamily: .medium, color: color, underline: true)
    }
    
    public func setAttributedTextForTag(openTag: String, closedTag: String, size: CGFloat, fontFamily: FontStyle, color: UIColor?, underline: Bool = false){
        guard self.mutableString.contains(openTag) && self.mutableString.contains(closedTag) else {return}
        let pattern = "\(openTag)(.*?)\(closedTag)";
        do {
            let regexMatcher = try NSRegularExpression(pattern: pattern, options: [])
            let matchColl = regexMatcher.matches(in: string, options: [], range: string.range)

            for match in matchColl {
                let font = UIFont(name: fontFamily.rawValue, size: size)!
                addAttribute( .font, value: font, range: match.range)
                if let color = color{
                    addAttribute( .foregroundColor, value: color, range: match.range)
                }
                if underline {
                    addAttribute( .underlineStyle, value: NSUnderlineStyle.single.rawValue, range: match.range)
                }
            }
            
            for i in 0 ..< matchColl.count*2 {
                let wordToReplace = i%2 == 0 ? closedTag : openTag
                let range = NSString(string: string).range(of: wordToReplace, options: String.CompareOptions.caseInsensitive)
                self.replaceCharacters(in: range, with: "")
            }
        }
        catch {
            return
        }
        
        
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

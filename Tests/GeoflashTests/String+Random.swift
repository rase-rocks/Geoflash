import Foundation

extension CharacterSet {
    
    /// Documentation at
    /// https://developer.apple.com/documentation/foundation/nscharacterset/1417719-bitmaprepresentation
    var codePoints : [Int] {
        
        var result: [Int] = []
        var plane = 0
        
        for (i, w) in bitmapRepresentation.enumerated() {
            
            let k = i % 8193
            
            if k == 8192 {
                // plane index byte
                plane = Int(w) << 13
                continue
            }
            
            let base = (plane + k) << 3
            
            for j in 0 ..< 8 where w & 1 << j != 0 {
                result.append(base + j)
            }
            
        }
        
        return result
        
    }
    
    var unicodeScalars: [UnicodeScalar] { codePoints
        .compactMap { UnicodeScalar($0) } }
    
}

extension String {
    
    static let allCharacters = [
        CharacterSet.punctuationCharacters,
        CharacterSet.lowercaseLetters,
        CharacterSet.uppercaseLetters,
        CharacterSet.decimalDigits,
        CharacterSet.whitespacesAndNewlines
    ].reduce(CharacterSet()) { $0.union($1) }.unicodeScalars.map { Character($0) }
    
}

extension String {
    
    public static func random(in range: Range<Int>) -> String {
        
        guard 
            let max = range.randomElement()
        else { return "" }
        
        let chars = (0..<max)
            .compactMap { _ in allCharacters.randomElement() }
        
        return String(chars)
        
    }
    
}

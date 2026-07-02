import Foundation

extension Geoflash {
    
    /// The size of "string binary representation" in our 32 character alphabet.
    static let padSize = 5
    
    /// Internal function to values 0-31 to the appropriate length
    ///
    /// Since Geohash uses 5 bits to represent each character in its 32 length alphabet
    /// this function left pads the `String` representation of the argument to 5 characters.
    ///
    /// A description of the base 32 encoding used by Geohash can be found on
    /// [Wikipedia](https://en.wikipedia.org/wiki/Geohash#Textual_representation)
    ///
    /// In the interest of performance, all checks are suspended, as such this method is only
    /// suitable for use here. Hence the `fileprivate` marker
    ///
    /// - Parameter number: The `Int` value to be represeted as a 5 character `String`.
    ///
    /// - Returns: The `number` argument as a 5 character "binary" `String`.
    fileprivate static func pad(_ number: Int) -> String {
        
        let s = String(number, radix: 2)
        let pad = (padSize - s.count % padSize) % padSize
        
        return Array(repeating: "0", count: pad)
            .joined() + s
        
    }
    
    /// The [base 32 alphabet](https://en.wikipedia.org/wiki/Base32) used for Geohash.
    static let alphabet = Array("0123456789bcdefghjkmnpqrstuvwxyz")
        
    /// A `Dictionary` mapping from `Character` to "string binary representation".
    static let alphabetMap = alphabet
        .enumerated()
        .reduce(into: [Character: String]()) { $0[$1.element] = pad($1.offset) }
    
}

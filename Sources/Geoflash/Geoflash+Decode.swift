import Foundation

extension Geoflash {
    
    static func decodeReducer(
        range: Geoflash.Range,
        char: Character
    ) -> Geoflash.Range {
        
        let mean = (range.min + range.max) / 2
        
        return char == "1"
        ? Geoflash.Range(min: mean, max: range.max)!
        : Geoflash.Range(min: range.min, max: mean)!
        
    }
        
    static func validated(hash: String) throws -> String {
        
        let bits = hash
            .compactMap { alphabetMap[$0] }
            .joined()
        
        guard
            !bits.isEmpty,
            bits.count == hash.count * padSize,
            bits.count.isMultiple(of: padSize)
        else { throw CodingError.invalidGeohash }
        
        return bits
        
    }
    
    static func decode(
        rangeOf hash: String
    ) throws -> (latitude: Geoflash.Range, longitude: Geoflash.Range) {
        
        let bits = try validated(hash: hash)
        
        let (latChars, lonChars) = bits
            .enumerated()
            .reduce(into: ([Character](), [Character]())) {
                if $1.0.isMultiple(of: 2) {
                    $0.1.append($1.1)
                } else {
                    $0.0.append($1.1)
                }
            }
        
        let latRange = latChars.reduce(lat, Geoflash.decodeReducer)
        let lonRange = lonChars.reduce(lng, Geoflash.decodeReducer)
        
        return (latitude: latRange, longitude: lonRange)
        
    }
    
    /// Decodes a [Geohash](https://en.wikipedia.org/wiki/Geohash) encoded string
    ///
    /// To be a valid Geohash the `String` passed must contain any digits 0-9 and any lower case
    /// digit in the set `bcdefghjkmnpqrstuvwxyz`. This is the English language alphabet, excluding
    /// the letters `a`, `i`, `l` and `o`
    ///
    /// - Parameter geohash: The `String` value to attempt to decode.
    /// - Parameter maxPointDistance: A `Double` value representing the number of decimal places.
    ///
    /// - Returns: An array of [GeoJSON](https://datatracker.ietf.org/doc/html/rfc7946)
    /// encoded coordinates.
    ///
    /// - Throws: When passed an invalid geohash.
    public static func decode(
        geohash: String,
        maxPointDistance: Double = 0.000001
    ) throws -> [[Double]] {
        
        let range = try decode(rangeOf: geohash)
        
        let pointDistance = max(abs(range.latitude.max - range.latitude.min),
                                abs(range.longitude.max - range.longitude.min))
        
        return pointDistance <= maxPointDistance
        ? [[range.longitude.min, range.latitude.min]]
        : [[range.longitude.min, range.latitude.min],
           [range.longitude.max, range.latitude.min],
           [range.longitude.max, range.latitude.max],
           [range.longitude.min, range.latitude.max]]
        
    }
    
}

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

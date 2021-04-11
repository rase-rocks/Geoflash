import Foundation

extension Geoflash {
    
    static let BASE32BITS = BASE32
        .enumerated()
        .map { ($1, String(integer: $0, radix: 2, padding: 5)) }
        .reduce(into: [Character: String]()) { $0[$1.0] = $1.1 }
    
    static func decodeReducer(range: GeoRange, char: Character) -> GeoRange {
        let mean = (range.min + range.max) / 2
        return char == "1"
            ? GeoRange(min: mean, max: range.max)
            : GeoRange(min: range.min, max: mean)
    }
    
    static func binaryString(from hash: String) -> String {
        return hash
            .map { BASE32BITS[$0] ?? "?" }
            .joined()
    }
    
    static func validated(hash: String) -> String? {
        let bits = binaryString(from: hash)
        guard bits.count.isMultiple(of: 5) else { return nil }
        return bits
    }
    
    static func decode(rangeOf hash: String) -> (latitude: GeoRange, longitude: GeoRange)? {
        
        guard !hash.isEmpty, let bits = validated(hash: hash) else { return nil }
        
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
        
        return (latitude    : latRange,
                longitude   : lonRange)
        
    }
    
    static func decode(geojson hash: String, maxPointDistance: Double = 0.000001) -> [[Double]]? {
        
        guard let range         = decode(rangeOf: hash) else { return nil }
        
        let pointDistance       = max(abs(range.latitude.max - range.latitude.min),
                                      abs(range.longitude.max - range.longitude.min))
        
        return pointDistance <= maxPointDistance
            ? [[range.longitude.min, range.latitude.min]]
            : [[range.longitude.min, range.latitude.min],
                [range.longitude.max, range.latitude.min],
                [range.longitude.max, range.latitude.max],
                [range.longitude.min, range.latitude.max]]
        
    }
    
}

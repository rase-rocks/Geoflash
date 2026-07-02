import Foundation

extension Geoflash {
    
    static let lat = Geoflash.Range(unchecked: -90.0, max: 90.0)
    static let lng = Geoflash.Range(unchecked: -180.0, max: 180.0)
    static let validPrecisions = 1...12
    
    /// Encode latitude/longitude as [Geohash](https://en.wikipedia.org/wiki/Geohash)
    ///
    /// - Parameter latitude: The latitude to be encoded (-90...90 valid values).
    /// - Parameter longitude: The longitude to be encoded (-180...180 valid values).
    /// - Parameter precision: The count of characters to be included in the result (1...12 valid).
    ///
    /// - Returns: The Geohash encoded string.
    ///
    /// - Throws: On invalid arguments.
    public static func encode(
        latitude: Double,
        longitude: Double,
        precision: Int = 12
    ) throws -> String {
        
        var lat = Geoflash.lat
        var lng = Geoflash.lng
        
        guard
            lat.contains(value: latitude),
            lng.contains(value: longitude),
            validPrecisions.contains(precision)
        else { throw CodingError.invalidEncodeArguments }
        
        var hash = Array(repeating: Character("a"),
                         count: precision)
        
        var isEven = true
        var char = 0
        var count = 0
        var pos = 0

        func compare(
            range: Geoflash.Range,
            source: Double
        ) -> Geoflash.Range {
            
            let mean = (range.min + range.max) / 2
            let isLow = source < mean
            
            let (min, max) = isLow
            ? (range.min, mean)
            : (mean, range.max)
            
            if !isLow {
                
                let mask = 0b10000 >> count
                char |= mask
                
            }
            
            return Range(unchecked: min, max: max)

        }

        repeat {
                        
            if isEven {
                
                lng = compare(range: lng, source: longitude)
                
            } else {
                
                lat = compare(range: lat, source: latitude)
                
            }
            
            isEven = !isEven
            count += 1
            
            if count == 5 {
                
                hash[pos] = alphabet[char]
                pos += 1
                count = 0
                char = 0
                
            }

        } while pos < precision

        return String(hash)
        
    }
    
}

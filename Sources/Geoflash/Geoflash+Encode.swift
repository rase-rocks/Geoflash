import Foundation

extension Geoflash {
    
    static let lat = Geoflash.Range(min: -90.0, max: 90.0)!
    static let lng = Geoflash.Range(min: -180.0, max: 180.0)!
    static let validPrecisions = 1...12
    
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
            
            return Range(min: min, max: max)!
            
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

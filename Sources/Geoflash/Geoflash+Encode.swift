import Foundation

extension Geoflash {

    static let lat = Geoflash.Range(unchecked: -90.0, max: 90.0)
    static let lon = Geoflash.Range(unchecked: -180.0, max: 180.0)
    static let validPrecisions = 1...12

    /// Encode latitude/longitude as [Geohash](https://en.wikipedia.org/wiki/Geohash).
    ///
    /// ```swift
    /// let hash = try Geoflash.encode(latitude: 38.897, longitude: -77.036)
    /// // dqcjr0bp7n74
    ///
    /// let short = try Geoflash.encode(latitude: 38.897, longitude: -77.036, precision: 5)
    /// // dqcjr
    /// ```
    ///
    /// - Parameters:
    ///   - latitude: The latitude to be encoded (-90...90 valid values).
    ///   - longitude: The longitude to be encoded (-180...180 valid values).
    ///   - precision: The count of characters to be included in the result (1...12 valid).
    ///
    /// - Returns: The Geohash encoded string.
    ///
    /// - Throws: ``Geoflash/CodingError/invalidEncodeArguments`` when the latitude, longitude
    ///   or precision falls outside its valid range.
    public static func encode(
        latitude: Double,
        longitude: Double,
        precision: Int = 12
    ) throws -> String {

        var lat = Geoflash.lat
        var lon = Geoflash.lon

        guard
            lat.contains(value: latitude),
            lon.contains(value: longitude),
            validPrecisions.contains(precision)
        else { throw CodingError.invalidEncodeArguments }

        var hash = Array(repeating: "a" as Character,
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
                lon = compare(range: lon, source: longitude)
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

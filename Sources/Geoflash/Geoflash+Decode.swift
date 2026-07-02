import Foundation

extension Geoflash {

    /// Narrows a range towards one half based on a single decoded bit.
    ///
    /// - Parameters:
    ///   - range: The range to subdivide.
    ///   - bit: When `true` the upper half is selected, otherwise the lower half.
    ///
    /// - Returns: The selected half, or the unchanged `range` if it can no longer be
    ///   subdivided within `Double` precision.
    static func decodeReducer(
        range: Geoflash.Range,
        bit: Bool
    ) -> Geoflash.Range {

        let mean = (range.min + range.max) / 2

        return bit
            ? (Geoflash.Range(min: mean, max: range.max) ?? range)
            : (Geoflash.Range(min: range.min, max: mean) ?? range)

    }

    static func decode(
        rangeOf hash: String
    ) throws -> (latitude: Geoflash.Range, longitude: Geoflash.Range) {

        guard validPrecisions.contains(hash.count) else {
            throw CodingError.invalidGeohash
        }

        var latRange = lat
        var lonRange = lon
        var isEven = true

        for char in hash {
            guard let value = alphabetMap[char] else {
                throw CodingError.invalidGeohash
            }

            // Read the padSize bits of each character most significant bit first,
            // alternating between the longitude and latitude ranges.
            for shift in stride(from: padSize - 1, through: 0, by: -1) {
                let bit = (value >> shift) & 1 == 1

                if isEven {
                    lonRange = decodeReducer(range: lonRange, bit: bit)
                } else {
                    latRange = decodeReducer(range: latRange, bit: bit)
                }

                isEven.toggle()
            }
        }

        return (latitude: latRange, longitude: lonRange)

    }

    /// Decodes a [Geohash](https://en.wikipedia.org/wiki/Geohash) encoded string.
    ///
    /// To be a valid Geohash the `String` passed must contain only digits 0-9 and lower case
    /// letters from the set `bcdefghjkmnpqrstuvwxyz`. This is the English language alphabet,
    /// excluding the letters `a`, `i`, `l` and `o`, and must be between 1 and 12 characters long.
    ///
    /// ```swift
    /// let hash = "63tn3q5d84bp" // Talca, South America
    /// let points = try Geoflash.decode(geohash: hash)
    /// // [[-71.65901184082031, -35.43046312406659]]
    /// ```
    ///
    /// - Parameters:
    ///   - geohash: The `String` value to attempt to decode.
    ///   - maxPointDistance: The largest span, in degrees, that a decoded range may cover
    ///     before a bounding polygon is returned instead of a single point. Defaults to
    ///     `0.000001`, which yields a single point for 12 character hashes and a polygon otherwise.
    ///
    /// - Returns: An array of [GeoJSON](https://datatracker.ietf.org/doc/html/rfc7946)
    ///   encoded `[longitude, latitude]` coordinates. A single point when the decoded range is
    ///   within `maxPointDistance`, otherwise the four corners of the bounding polygon.
    ///
    /// - Throws: ``Geoflash/CodingError/invalidGeohash`` when passed an invalid geohash.
    public static func decode(
        geohash: String,
        maxPointDistance: Double = 0.000001
    ) throws -> [[Double]] {

        let range = try decode(rangeOf: geohash)

        let pointDistance = max(
            abs(range.latitude.max - range.latitude.min),
            abs(range.longitude.max - range.longitude.min)
        )

        return pointDistance <= maxPointDistance
            ? [[range.longitude.min, range.latitude.min]]
            : [[range.longitude.min, range.latitude.min],
               [range.longitude.max, range.latitude.min],
               [range.longitude.max, range.latitude.max],
               [range.longitude.min, range.latitude.max]]

    }

}

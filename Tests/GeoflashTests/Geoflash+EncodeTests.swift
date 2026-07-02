import Geoflash
import XCTest

final class GeoflashEncodeTests: XCTestCase {

    let talcaLatitude = -35.43046303643829
    let talcaLongitude = -71.65901184082031

    func testOutOfRangeEncoding() {

        let smallestValue = Double.leastNormalMagnitude

        let rnd: (Double, Double) -> Double = { [
            Double.random(in: -1_000_000...($0 - smallestValue)),
            Double.random(in: ($1 + smallestValue)...1_000_000)
        ].randomElement()! }

        for _ in 0..<1_000 {
            let invalidLatitude = rnd(-90, 90)
            let invalidLongitude = rnd(-180, 180)

            XCTAssertThrowsError(try Geoflash.encode(latitude: invalidLatitude,
                                                     longitude: invalidLongitude))
        }

    }

    func testOutOfRangePrecision() {

        let invalidPrecision = { [
            Int.random(in: Int.min...0),
            Int.random(in: 13...Int.max)
        ].randomElement()! }

        for _ in 0..<1_000 {
            let precision = invalidPrecision()

            XCTAssertThrowsError(try Geoflash.encode(latitude: talcaLatitude,
                                                     longitude: talcaLongitude,
                                                     precision: precision))
        }

    }

    func testKnownExample() throws {

        let lat = 57.64911063015461
        let lon = 10.40743969380855

        let expected = "u4pruydqqvj"

        let result = try Geoflash.encode(latitude: lat,
                                         longitude: lon,
                                         precision: 11)

        XCTAssertEqual(result, expected)

    }

    func testKnownExamplePrecision() throws {

        try [
            (precision: 12, expectedPoints: 1),
            (precision: 11, expectedPoints: 4),
            (precision: 6, expectedPoints: 4)
        ].forEach { test in

            let talca = try Geoflash.encode(latitude: talcaLatitude,
                                            longitude: talcaLongitude,
                                            precision: test.precision)

            let points = try Geoflash.decode(geohash: talca)

            XCTAssertEqual(points.count,
                           test.expectedPoints, "Precision \(test.precision)")

        }

    }

    func testPerformance() throws {

        measure {
            let _ = try! Geoflash.encode(latitude: talcaLatitude,
                                         longitude: talcaLongitude,
                                         precision: 12)
        }

    }

}

import Geoflash
import XCTest

final class GeoflashDocumentationTests: XCTestCase {

    func testEncodingExample() throws {
        let hash = try Geoflash.encode(latitude: 38.897,
                                       longitude: -77.036)

        XCTAssertEqual(hash, "dqcjr0bp7n74")
    }

    func testEncodingWithPrecisionExample() throws {
        let hash = try Geoflash.encode(latitude: 38.897,
                                       longitude: -77.036,
                                       precision: 5)

        XCTAssertEqual(hash, "dqcjr")
    }

    func testDecodingExample() throws {
        let hash = "63tn3q5d84bp" // Talca, South America
        let points = try Geoflash.decode(geohash: hash)

        XCTAssertEqual(points, [[-71.65901184082031, -35.43046312406659]])
    }

    func testDecodingMaxPointDistanceExample() throws {
        let hash = "63tn3q"
        let points = try Geoflash.decode(geohash: hash)

        let expected = [
            [-71.663818359375, -35.430908203125],
            [-71.65283203125, -35.430908203125],
            [-71.65283203125, -35.4254150390625],
            [-71.663818359375, -35.4254150390625]
        ]

        XCTAssertEqual(points, expected)
    }
}

@testable import Geoflash
import XCTest

final class GeoflashRangeTests: XCTestCase {

    func testUnableToInitInvertedRange() {

        let invertedRange = Geoflash.Range(min: 10, max: 4)

        XCTAssertNil(invertedRange)

    }

    func testEqualRangeNil() {

        for _ in 0..<1_000 {
            let value = Double.random(in: Double(Int.min)...Double(Int.max))

            let result = Geoflash.Range(min: value, max: value)

            XCTAssertNil(result)
        }

    }

    func testUncheckedInitPreservesBounds() {

        let range = Geoflash.Range(unchecked: -12.5, max: 34.75)

        XCTAssertEqual(range.min, -12.5)
        XCTAssertEqual(range.max, 34.75)

    }

    func testSubdivisionFallsBackWhenRangeCannotSplit() {

        // Two adjacent Double values cannot be subdivided: their mean rounds to one of
        // the bounds, so one half is degenerate and Range(min:max:) returns nil. The
        // subdivision helper must return the unchanged range rather than trapping, which
        // is the regression guard for the removed force unwrap.
        let min = 1.0
        let max = min.nextUp
        let range = Geoflash.Range(unchecked: min, max: max)
        let mean = (min + max) / 2

        XCTAssertTrue(mean == min || mean == max,
                      "Adjacent Doubles should round the mean onto a bound")

        let collapsingBit = mean == min ? false : true
        let result = Geoflash.decodeReducer(range: range, bit: collapsingBit)

        XCTAssertEqual(result.min, min)
        XCTAssertEqual(result.max, max)

    }

    func testConstantsValid() {

        let lat = Geoflash.lat
        let lon = Geoflash.lon

        XCTAssertTrue(lat.contains(value: 0))
        XCTAssertTrue(lon.contains(value: 0))

    }

    func testContains() {

        let baseRange = -90...90

        let range = Geoflash.Range(min: Double(baseRange.lowerBound),
                                   max: Double(baseRange.upperBound))!

        for value in baseRange {
            XCTAssertTrue(range.contains(value: Double(value)))
        }

    }

}

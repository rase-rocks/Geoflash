@testable import Geoflash
import XCTest

final class GeoflashAlphabetTests: XCTestCase {

    func testAllCharsMapToTheirIndex() {

        for (index, char) in Geoflash.alphabet.enumerated() {

            let result = Geoflash.alphabetMap[char]

            XCTAssertEqual(result, index)

        }

    }

    func testAlphabetCoversTheFiveBitRange() {

        XCTAssertEqual(Geoflash.alphabet.count, 1 << Geoflash.padSize)

    }

}

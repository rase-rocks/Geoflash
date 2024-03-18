@testable import Geoflash
import XCTest

final class GeoflashAlphabetTests: XCTestCase {

    func testAllCharsHaveStringRepresentation() {
        
        for char in Geoflash.alphabet {
            
            let result = Geoflash.alphabetMap[char]
            
            XCTAssertNotNil(result)
            XCTAssertEqual(result?.count, Geoflash.padSize)
            
        }
        
    }

}

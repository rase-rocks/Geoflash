@testable import Geoflash
import XCTest

final class GeoflashRangeTests: XCTestCase {

    func testUnableToInitInvertedRange() {
        
        let invertedRange = Geoflash
            .Range(min: 10, max: 4)
        
        XCTAssertNil(invertedRange)
        
    }
    
    func testEqualRangeNil() {
        
        for _ in 0..<1_000 {
            
            let value = Double
                .random(in: Double(Int.min)...Double(Int.max))
            
            let result = Geoflash
                .Range(min: value, max: value)
            
            XCTAssertNil(result)
            
        }
        
    }
    
    func testConstantsValid() {
        
        let lat = Geoflash.lat
        let lng = Geoflash.lng

        XCTAssertTrue(lat.contains(value: 0))
        XCTAssertTrue(lng.contains(value: 0))
        
    }
    
    func testContains() {
        
        let baseRange = -90...90
        
        let range = Geoflash
            .Range(min: Double(baseRange.lowerBound),
                   max: Double(baseRange.upperBound))!
        
        for value in baseRange {
            
            XCTAssertTrue(range.contains(value: Double(value)))
            
        }
        
    }

}

@testable import Geoflash
import XCTest

final class GeoflashDecodeTests: XCTestCase {
    
    func testInvalidGeohashes() {
        
        let invalidHashes = [
            "",
            "notahash",
            "u4aruydqqvj"
        ]
        
        for invalidHash in invalidHashes {
            
            XCTAssertThrowsError(try Geoflash.decode(rangeOf: invalidHash), invalidHash)
            XCTAssertThrowsError(try Geoflash.decode(geohash: invalidHash), invalidHash)
            
        }
        
    }
    
    func testFuzzing() {
        
        for _ in 0...1_000 {
            
            let hash = String.random(in: 0..<1_000)
            
            XCTAssertThrowsError(try Geoflash.decode(geohash: hash))
            
        }
        
    }

    func testLongButValidHashThrows() {

        // A hash composed entirely of valid alphabet characters but far longer than the
        // maximum precision must be rejected rather than subdividing until the range
        // collapses below Double precision (which previously trapped on a force unwrap).
        let longValidHash = String(repeating: "b", count: 200)

        XCTAssertThrowsError(try Geoflash.decode(geohash: longValidHash))
        XCTAssertThrowsError(try Geoflash.decode(rangeOf: longValidHash))

    }

    func testBoundaryLengths() throws {

        let validHash = "u4pruydqqvjk"
        XCTAssertEqual(validHash.count, 12)
        XCTAssertNoThrow(try Geoflash.decode(geohash: validHash))

        let tooLongHash = validHash + "0"
        XCTAssertEqual(tooLongHash.count, 13)
        XCTAssertThrowsError(try Geoflash.decode(geohash: tooLongHash))

    }

    func testKnownValueRangeOf() throws {
        
        // Test hash taken from 
        // https://github.com/nh7a/Geohash/blob/master/Tests/GeohashTests/GeohashTests.swift

        let knownHash = "u4pruydqqvj"
        
        let (latitude: lat, longitude: lon) = try Geoflash.decode(rangeOf: knownHash)

        XCTAssertEqual(lat.min, 57.649109959602356)
        XCTAssertEqual(lat.max, 57.649111300706863)

        XCTAssertEqual(lon.min, 10.407439023256302 )
        XCTAssertEqual(lon.max, 10.407440364360809)
        
    }
    
    func testKnownValueDecodesWithPrecision() throws {
        
        let lat = 57.64911063015461
        let lon = 10.40743969380855
        
        let expected = "u4pruydqqvjk"
        
        for i in 1...expected.count {
            
            let result = try Geoflash
                .encode(latitude: lat,
                        longitude: lon,
                        precision: i)
            
            XCTAssertEqual(result, String(expected.prefix(i)))
            
        }
        
    }

}

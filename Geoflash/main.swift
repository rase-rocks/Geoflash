import Foundation

// MARK: Test Helpers

func title(_ string: String) {
    let underline = Array(repeating: "=", count: string.count).joined()
    print("\n\(underline)\n\(string)\n")
}

func run(message: String = "", op: () -> Bool) {
    let result = op() ? "Passed" : "Failed"
    print("\(result) | \(message)")
}

// Test data taken from
// https://github.com/rase-rocks/byw/blob/master/test/geo-hash-test.js
// To ensure compatability with this project

let knownValues = [
    (latitude: 38.897, longitude: -77.036, hash: "dqcjr0bp", name: "1600 Pennsylvania Avenue, Washington DC"),
    (latitude: 53.105006, longitude: -3.912463, hash: "gcmnngrp148h", name: "Pinnacle Stores, Capel Curig"),
    (latitude: -42.775050, longitude: -65.024357, hash: "683u8m49q8tp", name: "Puerto Madryn, Argentina")
]

// MARK: Testing Known Hashes

title("Testing Hash")

knownValues.forEach { test in
    
    let hash = Geoflash.hash(latitude   : test.latitude,
                             longitude  : test.longitude,
                             precision  : test.hash.count)
    
    run(message: test.name) { hash == test.hash && !hash.contains("a") }
    
}

//MARK: Testing Decode with Invalid hashes

title("Testing Decode with Invalid hashes")

[
    "notahash",
    "",
    "u4aruydqqvj"
].forEach { hash in
    
    run(message: "Invalid hash \(hash)") { Geoflash.decode(rangeOf: hash) == nil }
    
}

//MARK: Test Decode Range from known value

title("Test Decode Range from known value")
// Test hash taken from https://github.com/nh7a/Geohash/blob/master/Tests/GeohashTests/GeohashTests.swift

let knownHash = "u4pruydqqvj"
let (latitude: lat, longitude: lon) = Geoflash.decode(rangeOf: knownHash)!

run(message: knownHash) {
    return lat.min == 57.649109959602356    &&
        lat.max == 57.649111300706863       &&
        lon.min == 10.407439023256302       &&
        lon.max == 10.407440364360809
}

//MARK: Test Decode to GeoJson ooints

title("Test Decode to GeoJson ooints")

let talcaLatitude = -35.43046303643829
let talcaLongitude = -71.65901184082031

[
    (precision: 12, expectedPoints: 1),
    (precision: 11, expectedPoints: 4),
    (precision: 6, expectedPoints: 4)
].forEach { test in
    
    let talca = Geoflash.hash(latitude: talcaLatitude, longitude: talcaLongitude, precision: test.precision)
    let points = Geoflash.decode(geojson: talca)!
    
    run(message: "Precision \(test.precision)") { points.count == test.expectedPoints }
    
}



    

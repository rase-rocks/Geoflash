import Foundation

struct GeoflashTest {
    let latitude    : Double
    let longitude   : Double
    let hash        : String
    let name        : String
}

let results: [(name: String, passed: Bool)] = [
    GeoflashTest(latitude: 38.897, longitude: -77.036, hash: "dqcjr0bp", name: "1600 Pennsylvania Avenue, Washington DC"),
    GeoflashTest(latitude: 53.105006, longitude: -3.912463, hash: "gcmnngrp148h", name: "Pinnacle Stores, Capel Curig"),
    GeoflashTest(latitude: -42.775050, longitude: -65.024357, hash: "683u8m49q8tp", name: "Puerto Madryn, Argentina")
].map { test in
        
        let hash = Geoflash.hash(latitude: test.latitude, longitude: test.longitude, precision: test.hash.count)
        
        return (name: test.name, passed: hash == test.hash)
        
}

results.forEach { print("\($0.passed ? "Passed" : "Failed") | \($0.name)")}


# Geoflash | Performance oriented Geohash implementation

## Background

> Geohash is a public domain geocode system invented in 2008 by Gustavo Niemeyer and (similar work in 1966) G.M. Morton, which encodes a geographic location into a short string of letters and digits. It is a hierarchical spatial data structure which subdivides space into buckets of grid shape, which is one of the many applications of what is known as a Z-order curve, and generally space-filling curves.

[Wikipedia](https://en.wikipedia.org/wiki/Geohash)

## About Geoflash

Geoflash is performance tested against other Swift implementations of the `geohash` algorithm. It is intended to perform well when compared to others and be a single file solution.

### Things Geoflash is

+ A base implementation using `Double` primitives for arguments to be easily integrated into other types as extensions

### Things Geoflash is not

+ A general purpose geodesy framework

## Installation

Via Swift Package Manager

## Usage

The unit tests demonstrate proper usage for common scenarios and are repeated below for quick skim read purposes.

### Encoding as Geohash

To hash a location simply pass the latitude and longitude as `Double` to the `encode(latitude:longitude)` static function.

```swift
let hash = try Geoflash.encode(latitude: 38.897, longitude: -77.036)
// dqcjr0bp7n74
```

Optionally a precision argument can be passed to limit the length of the hash and correspondingly limit the precision should the hash be decoded. The default for precision is `12`.

```swift
let hash = try Geoflash.encode(latitude: 38.897, longitude: -77.036, precision: 5)
// dqcjr
```

### Decoding a Geohash

The following is a sample usage to decode a 12 digit geohash. A 12 digit hash has sufficient resolution to allow for the returning of a single GeoJSON point.

```swift
let hash = "63tn3q5d84bp" // Talca, South America
let points = try Geoflash.decode(geohash: hash)
// [[-71.65901184082031, -35.43046312406659]]
// Latitude: -35.43046312406659
// Longitude: -71.65901184082031
```

The `maxPointDistance` parameter can optionally be passed in to control what level of accuracy is required from the output (or the range of values in other words). The default value is a value of `0.000001` which has the effect of returning a single point for hashes of 12 digits and a polygon drawing the range of values for all lower lengths of hash.

```swift
let hash = "63tn3q"
let points = try Geoflash.decode(geohash: hash)
// [[-71.663818359375, -35.430908203125], [-71.65283203125, -35.430908203125], [-71.65283203125, -35.4254150390625], [-71.663818359375, -35.4254150390625]]
```


# ``Geoflash``

A performance oriented Geohash implementation built on `Double` primitives.

## Overview

Geoflash encodes a latitude and longitude into a short
[Geohash](https://en.wikipedia.org/wiki/Geohash) string, and decodes a Geohash back into
[GeoJSON](https://datatracker.ietf.org/doc/html/rfc7946) coordinates. It is intended as a
compact base implementation that integrates into richer types as an extension, rather than a
general purpose geodesy framework.

### Encoding

```swift
let hash = try Geoflash.encode(latitude: 38.897, longitude: -77.036)
// dqcjr0bp7n74

let short = try Geoflash.encode(latitude: 38.897, longitude: -77.036, precision: 5)
// dqcjr
```

### Decoding

A 12 character hash carries enough resolution to return a single point. Shorter hashes
return the four corners of the bounding polygon that the hash covers.

```swift
let points = try Geoflash.decode(geohash: "63tn3q5d84bp")
// [[-71.65901184082031, -35.43046312406659]]

let polygon = try Geoflash.decode(geohash: "63tn3q")
// four [longitude, latitude] corners
```

## Topics

### Encoding and decoding

- ``Geoflash/encode(latitude:longitude:precision:)``
- ``Geoflash/decode(geohash:maxPointDistance:)``

### Supporting types

- ``Geoflash/Range``
- ``Geoflash/CodingError``

# Geoflash | Performance oriented Geohash implementation

## Background

> Geohash is a public domain geocode system invented in 2008 by Gustavo Niemeyer and (similar work in 1966) G.M. Morton, which encodes a geographic location into a short string of letters and digits. It is a hierarchical spatial data structure which subdivides space into buckets of grid shape, which is one of the many applications of what is known as a Z-order curve, and generally space-filling curves.

[Wikipedia](https://en.wikipedia.org/wiki/Geohash)

## About Geoflash

Geoflash is performance tested against other Swift implementations of the `geohash` algorithm. It is intended to perform well when compared to others and be a single file solution.

### Things Geoflash is

+ A single file solution with the only dependency of `Foundation`, favoring performance
+ A base implementation using `Double` primitives for arguments to be easily integrated into other types as extensions

### Things Geoflash is not

+ A general purpose geodesy framework

## Installation

Copy `Geoflash.swift` into your project

### Xcode project

This repo includes an Xcode project as well as the `Geoflash.swift` file itself. The project compiles to a macOS command line application to test the implementation against some known good results. To use this project simply clone this repo, build and run.

## Usage

To hash a location simply pass the latitude and longitude as `Double` to the `hash` static function.

```swift
let hash = Geoflash.hash(latitude: 38.897, longitude: -77.036)
// dqcjr0bp7n74
```

Optionally a precision argument can be passed to limit the length of the hash and correspondingly limit the precision should the hash be decoded. The default for precision is `12`.

```swift
let hash = Geoflash.hash(latitude: 38.897, longitude: -77.036, precision: 5)
// dqcjr
```


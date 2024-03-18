import Foundation

/// Geohash is a [public domain](https://en.wikipedia.org/wiki/Public_domain)
/// [geocode system](https://en.wikipedia.org/wiki/Geocode#Geocode_system) invented in 2008 by
/// Gustavo Niemeyer which encodes a geographic location into a short string of letters and digits.
/// Similar ideas were introduced by G.M. Morton in 1966. It is a hierarchical spatial data
/// structure which subdivides space into buckets of grid shape, which is one of the many
/// applications of what is known as a Z-order curve, and generally space-filling curves.
///
/// Geohashes offer properties like arbitrary precision and the possibility of gradually removing
/// characters from the end of the code to reduce its size (and gradually lose precision). 
/// Geohashing guarantees that the longer a shared prefix between two geohashes is, the spatially
/// closer they are together. The reverse of this is not guaranteed, as two points can be very
/// close but have a short or no shared prefix.
///
/// Geohashes can be used to find points in proximity to each other based on a common prefix.
/// However, edge case locations close to each other but on opposite sides of the 180 degree
/// meridian will result in Geohash codes with no common prefix (different longitudes for near
/// physical locations). Points close to the North and South poles will have very different
/// geohashes (different longitudes for near physical locations).
///
/// The above explaination is taken directly from
/// [Wikipedia](https://en.wikipedia.org/wiki/Geohash)
///
/// The ``Geoflash`` type exists to namespace encoding and decoding functionality
public struct Geoflash { }

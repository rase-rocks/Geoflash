import Foundation

extension Geoflash {

    /// The number of bits used to represent each character in the 32 character alphabet.
    ///
    /// Geohash uses 5 bits per character to index into its 32 length alphabet.
    static let padSize = 5

    /// The [base 32 alphabet](https://en.wikipedia.org/wiki/Base32) used for Geohash.
    static let alphabet = Array("0123456789bcdefghjkmnpqrstuvwxyz")

    /// A `Dictionary` mapping each alphabet `Character` to its 0...31 value.
    ///
    /// Decoding reads the ``padSize`` bits of each value directly, so no intermediate
    /// string representation is required.
    ///
    /// A description of the base 32 encoding used by Geohash can be found on
    /// [Wikipedia](https://en.wikipedia.org/wiki/Geohash#Textual_representation)
    static let alphabetMap = alphabet
        .enumerated()
        .reduce(into: [Character: Int]()) { $0[$1.element] = $1.offset }

}

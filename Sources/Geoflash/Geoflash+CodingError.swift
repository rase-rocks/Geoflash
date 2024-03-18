import Foundation

extension Geoflash {
    
    /// Errors that can be thrown during encoding/decoding a geohash
    enum CodingError: Error {
        
        /// The passed string geohash is not valid
        case invalidGeohash
        
        /// The arguments passed to encode a latitude/longitude are not valid
        case invalidEncodeArguments
    }
    
}

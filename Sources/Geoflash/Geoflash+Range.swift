import Foundation

extension Geoflash {
    
    /// A range for the purposes of expressing min/max values
    public struct Range {
        
        /// The minimum possible value
        let min: Double
        
        /// The maximum possible value
        let max: Double
        
        /// Initialise a ``Geoflash/Range`` with min/max values
        ///
        /// In common with other range representations, the min (or lower bound) must be
        /// lower than the max (or upper bound) of the range, or a `nil` will be returned
        public init?(min: Double, max: Double) {
            
            guard 
                min < max
            else { return nil }
            
            self.min = min
            self.max = max
            
        }
        
        /// Determine if the passed `value` argument is contained with this instance
        ///
        /// - Parameter value: The value to be checked.
        ///
        /// - Returns: A truthy value if the `value` passed is contained with the instance.
        func contains(value: Double) -> Bool {
            
            return (min...max)
                .contains(value)
            
        }
        
    }
    
}

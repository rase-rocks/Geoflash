import Foundation

extension Geoflash {

    /// A range for the purposes of expressing min/max values.
    public struct Range {

        /// The minimum possible value.
        public let min: Double

        /// The maximum possible value.
        public let max: Double

        /// Initialise a ``Geoflash/Range`` with min/max values.
        ///
        /// This is the only public way to construct a ``Geoflash/Range``. In common with other
        /// range representations, the min (or lower bound) must be strictly lower than the max
        /// (or upper bound), otherwise `nil` is returned. Equal bounds are rejected: a degenerate
        /// single point range is intentionally not supported. Returning `nil` rather than trapping
        /// keeps invalid bounds from crashing a caller.
        public init?(min: Double, max: Double) {

            guard min < max else { return nil }

            self.min = min
            self.max = max

        }

        /// Initialise a ``Geoflash/Range`` from bounds already known to be ordered.
        ///
        /// This trusted initialiser performs no validation. It skips the `min < max` check of
        /// ``init(min:max:)`` so the encode hot path and the fixed latitude and longitude
        /// constants avoid a needless optional. It is deliberately kept `internal`: the caller
        /// is responsible for passing ordered bounds, and no public crash surface is introduced.
        init(unchecked min: Double, max: Double) {

            self.min = min
            self.max = max

        }

        /// Determine if the passed `value` argument is contained within this instance.
        ///
        /// - Parameter value: The value to be checked.
        ///
        /// - Returns: A truthy value if the `value` passed is contained with the instance.
        public func contains(value: Double) -> Bool {
            return (min...max).contains(value)
        }

    }

}

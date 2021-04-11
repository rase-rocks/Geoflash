import Foundation

extension String {
    init(integer n: Int, radix: Int = 10, padding: Int) {
        let s   = String(n, radix: radix)
        let pad = (padding - s.count % padding) % padding
        self    = Array(repeating: "0", count: pad).joined(separator: "") + s
    }
}

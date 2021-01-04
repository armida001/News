//
//  ArrayExtension.swift
//

import UIKit

extension Array where Element: Comparable {
    func isEqual(to: Array) -> Bool {
        guard self.count == to.count else {
            return false
        }
        return self.sorted() == to.sorted()
    }
}

extension Array {
    func isEqual(to: [Element], sort: (Element, Element) -> (Bool), filter: (Element, Element) -> (Bool)) -> Bool {
        if self.count != to.count { return false }
        
        let a1 = to.sorted(by: sort)
        let a2 = to.sorted(by: sort)
        
        return zip(a1, a2).enumerated().filter() { return filter($1.0, $1.1) }.count == a1.count
    }
}

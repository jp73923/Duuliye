//
//  CollectionExtension.swift
//  Yodel
//
//  Created by Dhaval on 11/11/20.
//  Copyright © 2020 DhavalBhimani. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

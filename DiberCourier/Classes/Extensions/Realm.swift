//
//  Realm.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/6/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
    
    func deleteCascade(object: RealmObject) {
        var objectsToDelete = [RealmObject]()
        objectsToDelete.append(object)
        objectsToDelete.append(contentsOf: object.childrenToDelete())
        delete(objectsToDelete)
    }
    
}

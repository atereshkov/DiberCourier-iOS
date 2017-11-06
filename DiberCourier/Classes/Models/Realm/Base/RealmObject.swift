//
//  RealmObject.swift
//  DiberCourier
//
//  Created by Alexander Tereshkov on 11/6/17.
//  Copyright © 2017 Diber. All rights reserved.
//

import RealmSwift

class RealmObject: Object {
    
    func childrenToDelete() -> [RealmObject] {
        return []
    }
    
}

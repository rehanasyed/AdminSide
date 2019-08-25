//
//  User.swift
//  AdminSide
//
//  Created by Hasan on 25/08/2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

enum Gender : String {
    case Male = "Male"
    case Female = "Female"
}

struct EmergencyUser {
    var Gender : Gender
    var Name : String
    var PhoneNumber : String
}

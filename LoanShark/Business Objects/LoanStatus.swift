//
//  LoanStatus.swift
//  LoanShark
//
//  Created by Tyler Morgan on 12/24/19.
//  Copyright © 2019 Tyler Morgan. All rights reserved.
//

import Foundation

enum LoanStatus: String {
    case active = "Active"
    case warning = "Warning"
    case critical = "Critical"
    case expired = "Expired"
    case notSet = "Not Set"
}

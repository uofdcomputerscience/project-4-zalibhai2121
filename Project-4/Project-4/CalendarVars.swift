//
//  CalendarVars.swift
//  Project-4
//
//  Created by Zainab Alibhai on 12/15/19.
//  Copyright © 2019 Zainab Alibhai. All rights reserved.
//

import Foundation

let date = Date()
let calendar = Calendar.current

let day = calendar.component(.day, from: date)
let weekday = calendar.component(.weekday, from: date)
var month = calendar.component(.month, from: date) - 1
var year = calendar.component(.year, from: date)

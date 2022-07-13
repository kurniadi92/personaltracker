//
//  RecordViewParam.swift
//  personaltracker
//
//  Created by kur niadi  on 12/07/22.
//

import Foundation

struct RecordViewParam: Equatable {
    let uid: String
    let title: String
    let category: String
    let type: String
    let amount: Int
    let imageId: String
    let createdAt: Int
}

struct RecordCellViewParam: Equatable{
    let uid: String
    let title: String
    let category: String
    let type: String
    let amount: Int
    let createdAt: Int
    let formattedDate: String
}

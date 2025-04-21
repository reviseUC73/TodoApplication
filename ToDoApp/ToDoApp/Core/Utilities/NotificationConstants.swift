//
//  NotificationConstants.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 21/4/2568 BE.
//

import Foundation

extension Notification.Name {
    // Notification ต่างๆ ที่ใช้ในแอพ
    static let todoCreated = Notification.Name("TodoCreated")
    static let todoUpdated = Notification.Name("TodoUpdated")
    static let todoDeleted = Notification.Name("TodoDeleted")
}

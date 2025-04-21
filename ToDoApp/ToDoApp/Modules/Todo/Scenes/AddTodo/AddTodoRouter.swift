//
//  AddTodoRouter.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 19/4/2568 BE.
//

import UIKit

protocol AddTodoRoutingLogic {
    func routeToTodoList()
}

protocol AddTodoDataPassing {
    var dataStore: AddTodoDataStore? { get }
}

class AddTodoRouter: NSObject, AddTodoRoutingLogic, AddTodoDataPassing {
    weak var viewController: AddTodoViewController?
    var dataStore: AddTodoDataStore?
    
    // MARK: - Routing
    
    func routeToTodoList() {
        // แจ้งเตือนว่ามีการสร้าง Todo ใหม่ ก่อนที่จะปิดหน้าจอ
        // ส่งแบบ delay เล็กน้อยเพื่อให้แน่ใจว่า notification จะถูกส่งหลังจากที่ TodoListViewController พร้อมรับ
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // ต้องอยู่บน main thread เท่านั้น
            NotificationCenter.default.post(name: NSNotification.Name("TodoCreated"), object: nil)
        }
        
        // Make sure UI operations are performed on the main thread
        DispatchQueue.main.async { [weak self] in
            // Simply dismiss this view controller to go back to the TodoList
            self?.viewController?.dismiss(animated: true)
        }
    }
}

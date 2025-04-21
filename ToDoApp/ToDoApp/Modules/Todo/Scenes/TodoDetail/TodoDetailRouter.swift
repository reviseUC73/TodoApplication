//
//  TodoDetailRouter.swift
//  ToDoApp
//
//  Created by ReviseUC73 on 21/4/2568 BE.
//

import UIKit

@objc protocol TodoDetailRoutingLogic {
    func routeBackToList()
}

protocol TodoDetailDataPassing {
    var dataStore: TodoDetailDataStore? { get }
}

class TodoDetailRouter: NSObject, TodoDetailRoutingLogic, TodoDetailDataPassing {
    weak var viewController: TodoDetailViewController?
    var dataStore: TodoDetailDataStore?
    
    // MARK: - Routing
    
    func routeBackToList() {
        // แจ้งเตือนการเปลี่ยนแปลงก่อนนำทางกลับ
        NotificationCenter.default.post(name: NSNotification.Name("TodoCreated"), object: nil)
        
        // นำทางกลับไปยังหน้า list
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    
    // เตรียม Method สำหรับการนำทางไปยังหน้าถัดไป (ถ้าจำเป็น)
    // func prepare(for segue: UIStoryboardSegue, sender: Any?) { }
}

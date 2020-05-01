//
//  User.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-04-24.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import Firebase


class Device: ObservableObject {
    
    let deviceId = UIDevice.current.identifierForVendor!.uuidString
    
    private var listenner: ListenerRegistration?
    
    @Published var data: DeviceData?
    

    func subscribeToDevice() -> Void {
        
        let db = Firestore.firestore()
        let deviceRef = db.collection("devices").document(deviceId)

        listenner = deviceRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
              print("Error fetching device: \(error!)")
              return
            }
            
            guard let deviceData = document.data() else {
              print("Document data was empty.")
              return
            }
            
            self.data = DeviceData(deviceData)
        }
    }
    
    
    func updateDeviceCashier(uid: String, cashierId: Any) -> Void {
    
        let db = Firestore.firestore()
        let deviceRef = db.collection("devices").document(deviceId)
        
        deviceRef.setData([
            "cashier": cashierId,
            "uid": uid,
        ], merge: true)
        
    }
    

    func unsubscribeFromDevice() -> Void {
        if let listenner = listenner {
            listenner.remove()
        }
        
        listenner = nil
        data = nil
    }
}

struct DeviceData {
    
    let visiblePromptIds: [PromptId]
    
    
    init(_ deviceData: [String: Any]) {
        visiblePromptIds = deviceData["visiblePromptIds"] as? [PromptId] ?? []
    }
}

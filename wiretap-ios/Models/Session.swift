//
//  PromptListModel.swift
//  Wiretap
//
//  Created by Nic Laflamme on 2020-03-21.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import Firebase


class Session: ObservableObject {
    
    @Published var isConnected: Bool = false
    @Published var uid: String = "null"

    
    init() {
       subscribeToSession()
    }
    
    
    func subscribeToSession() -> Void {
        
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        
        print()
        print()
        print()
        print()
        print()
        print()
        print(UIDevice.current.name)
        print(UIDevice.current.systemVersion)
        print(UIDevice.current.model)
        print(UIDevice.current.localizedModel)
        print()
        print()
        print()
        print()

        
        let db = Firestore.firestore()
        let sessionRef = db.collection("sessions").document(deviceId)
        
        sessionRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                
                return
            }
            
            guard let data = document.data() else {
                self.isConnected = false
                self.uid = "null"
                
                return
            }
           
            self.isConnected = true
            self.uid = data["uid"] as! String
        }
    }
    
}



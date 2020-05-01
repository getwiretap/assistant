//
//  User.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-04-24.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import Firebase


class User: ObservableObject {
    
    private var listenner: ListenerRegistration?
    
    @Published var uid: String? = "ewDPmmZXhkRDZCxshOQgvXLBDLV2"
    @Published var data: UserData?
    

    func subscribeToUser(uid: String) -> Void {
        
        self.uid = uid
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(uid)

        listenner = userRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
              print("Error fetching document: \(error!)")
              return
            }
            
            guard let userData = document.data() else {
              print("Document data was empty.")
              return
            }
            
            self.data = UserData(userData)
        }
    }

    func unsubscribeFromUser() -> Void {
        if let listenner = listenner {
            listenner.remove()
        }
        
        listenner = nil
        uid = nil
        data = nil
    }
}

struct UserData {
    
    let plan: String
    let visiblePromptIds: [PromptId]
    
    init(_ userData: [String: Any]) {
        plan = userData["plan"] as? String ?? "static"
        visiblePromptIds = userData["visiblePromptIds"] as? [PromptId] ?? []
    }
}

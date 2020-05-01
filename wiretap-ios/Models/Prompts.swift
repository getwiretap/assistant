//
//  Prompts.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-03-27.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import Firebase


typealias PromptId = String


class Prompts: ObservableObject  {
    
    private var listenner: ListenerRegistration?
    
    @Published var prompts: [PromptId: Prompt] = [:]
    

    func subscribeToPrompts(uid: String) -> Void {
        
        let db = Firestore.firestore()
        let promptsRef = db.collection("prompts").whereField("uid", isEqualTo: uid)

        listenner = promptsRef.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching prompts: \(error!)")
                return
            }
            
            for document in documents {
                let promptId = document.documentID
                let prompt = Prompt(document.data(), promptId: promptId)
                
                self.prompts[promptId] = prompt
            }
        }
    }
    
    func unsubscribeFromPrompts() -> Void {
        if let listenner = listenner {
            listenner.remove()
        }
        
        listenner = nil
        prompts = [:]
    }
}

struct Prompt: Identifiable, Codable {
    
    let id: PromptId
    
    let label: String
    let points: Int
    let autonext: Bool
    let canMultiConfirm: Bool
    

    init(_ firebaseData: [String: Any], promptId: PromptId) {
        id = promptId
        
        label = firebaseData["label"] as? String ?? ""
        points = firebaseData["points"] as? Int ?? 1
        autonext = firebaseData["autonext"] as? Bool ?? false
        canMultiConfirm = firebaseData["canMultiConfirm"] as? Bool ?? false
    }
    
    // For SwiftUI preview purposes
    init() {
        id = "123"
        
        label = "Preview mode!"
        points = 1
        autonext = false
        canMultiConfirm = false
    }
}

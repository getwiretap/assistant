//
//  Cashiers.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-04-19.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import Firebase


typealias CashierId = String
typealias CashierPassword = String


class Cashiers: ObservableObject {
    
    private var listenner: ListenerRegistration?
    
    let passwordLength: Int = 4
    
    @Published var cashiers: [CashierPassword: Cashier] = [:]
    @Published var password: CashierPassword = ""
    
    
    func subscribeToCashiers(uid: String) -> Void {
        
        let db = Firestore.firestore()
        let cashiersRef = db.collection("cashiers").whereField("uid", isEqualTo: uid)

        listenner = cashiersRef.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching cashiers: \(error!)")
                return
            }
            
            
            for document in documents {
                
                let cashierId = document.documentID
                let cashier = Cashier(document.data(), cashierId: cashierId)
                let cashierPassword = cashier.password
                
                self.cashiers[cashierPassword] = cashier
            }
        }
    }
    
    func unsubscribeFromCashiers() -> Void {
        if let listenner = listenner {
            listenner.remove()
        }

        cashiers = [:]
        password = ""
    }
    
    func createAppendDigit(_ digit: Int) -> () -> Void {
        
        func appendDigit() {
            if password.count >= passwordLength {
                password = ""
            }
            
            password += String(digit)
        }
        
        return appendDigit
    }
    
    func signOut() {
        password = ""
    }
}


struct Cashier: Codable {
    
    let id: CashierId
    
    let displayName: String
    let password: CashierPassword
    let todayStats: CashierStats
    
    init(_ firebaseData: [String: Any], cashierId: CashierId) {
        id = cashierId
        
        displayName = firebaseData["displayName"] as? String ?? "Anonynous"
        password = firebaseData["password"] as? CashierPassword ?? "X"
        
        let today = Date.getFullDate()
        let statsData = firebaseData["stats"] as? [FormattedDate: Any] ?? [:]
        let todayStatsData = statsData[today] as? [String: Any] ?? [:]
        
        todayStats = CashierStats(todayStatsData)
    }
    
    // For SwiftUI preview purposes
    init() {
        id = "007"
        displayName = "Bob"
        password = "1234"
        todayStats = CashierStats()
    }
}


struct CashierStats: Codable {
    
    let tickets: Int
    let confirmations: Int
    let points: Int
    let promptConfirmations: [PromptId: Int]

    
    
    init (_ firebaseData: [String: Any]) {
        tickets = firebaseData["tickets"] as? Int ?? 0
        confirmations = firebaseData["confirmations"] as? Int ?? 0
        points = firebaseData["points"] as? Int ?? 0
        promptConfirmations = firebaseData["promptConfirmations"] as? [PromptId: Int] ?? [:]
    }
    
    // For SwiftUI preview purposes
    init() {
        tickets = 0
        confirmations = 0
        points = 0
        promptConfirmations = [:]
    }
}

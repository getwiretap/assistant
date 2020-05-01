//
//  Validation.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-04-25.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import Starscream
import Firebase


class Ticket: ObservableObject, WebSocketDelegate {
    
    let socket: WebSocket
    
    
    private var isSocketConnected: Bool = false
    private var validationTimestamps: [PromptId: Date] = [:]
    
    @Published var confirmations: Int = 0
    @Published var points: Int = 0
    @Published var validatedPrompts: [PromptId: Int] = [:]

    
    init() {
        
        // TODO: Maybe not hard-coded && make sur WSS protocol
//        let url = URL(string: "https://wiretap-validator.herokuapp.com")!
        let url = URL(string: "https://6e339062.ngrok.io")!
    
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        
        socket = WebSocket(request: request)
        socket.delegate = self
        
        socket.connect()
    }
    
    func publishTranscription(cashierId: CashierId, transcription: String, visiblePrompts: [Prompt]) {
        
        // FIXME - Allow user to reconnect
        if !isSocketConnected {
            return
        }

        let message = TranscriptionMessage(
            cashierId: cashierId,
            transcription: transcription,
            visiblePrompts: visiblePrompts
        )
        
        do {
            let jsonData = try JSONEncoder().encode(message)
            let jsonString = String(data: jsonData, encoding: .utf8)!

            socket.write(string: jsonString)
        } catch {
            print("Unable to push transcription.")
        }
    }
    
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
      switch event {
      case .connected(_):
        isSocketConnected = true
        
      case .disconnected(_, _):
        isSocketConnected = false
        
      case .text(let jsonString):
        updateTicketStats(jsonString: jsonString)
        break
        
      case .binary(_):
        break
        
      case .pong(_):
        break
        
      case .ping(_):
        break
        
      case .error(_):
        break
        
      case .viabilityChanged:
        break
        
      case .reconnectSuggested:
        break
        
      case .cancelled:
        isSocketConnected = false
      }
    }
    
    
    func updateTicketStats(jsonString: String) {
        
        do {
            let jsonData = jsonString.data(using: .utf8)!
            let confirmationMessage = try JSONDecoder().decode(PromptConfirmationMessage.self, from: jsonData)
            
            let prompt = confirmationMessage.prompt
            let promptId = prompt.id
            
            let cashierId = confirmationMessage.cashierId
            
            // Prevents the multiple validation by the same transcription.
            if let validationTimestamp = validationTimestamps[promptId] {
                let secondsSinceLastValidation = Date().timeIntervalSince(validationTimestamp)
                
                if secondsSinceLastValidation < 5 {
                    return
                }
            }
            validationTimestamps[promptId] = Date()
            
            
            let isConfirmed = validatedPrompts[promptId] != nil
            
            if !isConfirmed || prompt.canMultiConfirm {
                
                confirmations += 1
                points += prompt.points
                
                // TODO: Increment me if prompt.canMultiConfirm
                validatedPrompts[prompt.id] = 1
            }
            
            if (prompt.autonext) {
                let seconds = 1.0
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                    // Put your code which should be executed with a delay here
                    self.saveStatsToCashier(cashierId: cashierId)
                }
            }
            
        } catch {
            print("Unable to push transcription.")
        }
    }
    
    
    func saveStatsToCashier(cashierId: String) -> Void {
           
        var update: [String: FieldValue] = [:]
        
        let total = "total"
        let today = Date.getFullDate()
        let thisMonth = Date.getMonth()
        
        for dateKey in [total, today, thisMonth] {
            
            update["stats.\(dateKey).tickets"] = FieldValue.increment(Double(1))
            update["stats.\(dateKey).confirmations"] = FieldValue.increment(Double(confirmations))
            update["stats.\(dateKey).points"] = FieldValue.increment(Double(points))
            
            for (promptId, increment) in validatedPrompts {
                let promptPath = "stats.\(dateKey).promptConfirmations.\(promptId)"
                update[promptPath] = FieldValue.increment(Double(increment))
            }
        }

    
        let db = Firestore.firestore()
        let cashierRef = db.collection("cashiers").document(cashierId)
        cashierRef.updateData(update)
        
        clearData()
    }
    
    func clearData() {
        confirmations = 0
        points = 0
        validatedPrompts = [:]
    }
}


struct TranscriptionMessage: Codable {
    
    let deviceId = UIDevice.current.identifierForVendor!.uuidString
    
    let cashierId: CashierId
    let transcription: String
    let visiblePrompts: [Prompt]
    
}

struct PromptConfirmationMessage: Codable {
    
    let cashierId: CashierId
    let prompt: Prompt
    
}

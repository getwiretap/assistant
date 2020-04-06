//
//  SpeechRecognizer.swift
//  wiretap-ios
//
//  Created by Nic Laflamme on 2020-03-24.
//  Copyright © 2020 Nic Laflamme. All rights reserved.
//

import Speech


public class SpeechRecognizer: ObservableObject {
    // MARK: Properties
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private let audioEngine = AVAudioEngine()
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    @Published var isMicEnabled = false
    @Published var isRecording = false
    @Published var transcription = Words("")
    
    
    func requestPermission() {
        SFSpeechRecognizer.requestAuthorization { authStatus in

            // Divert to the app's main thread so that the UI can be updated.
            OperationQueue.main.addOperation {
                if authStatus == .authorized {
                    self.isMicEnabled = true
                } else {
                    self.isMicEnabled = false
                }
            }
        }
    }
    
    private func startRecording() throws {
        
        // Cancel the previous task if it's running.
        recognitionTask?.cancel()
        self.recognitionTask = nil
        
        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode

        // Create and configure the speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        
        // Required for real-time results
        recognitionRequest.shouldReportPartialResults = true
        
        // Keep speech recognition data on device
        if #available(iOS 13, *) {
            if speechRecognizer.supportsOnDeviceRecognition {
                recognitionRequest.requiresOnDeviceRecognition = true
            }
        }
        
        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {

                self.transcription = Words(result.bestTranscription.formattedString)
                
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil

                self.isRecording = false
                self.transcription = Words("")
            }
        }

        // Configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
    }
    
    func startRecordingHandled() {
        do {
            try startRecording()
            isRecording = true
        } catch {
            isRecording = false
        }
    }

    func toggleRecording() {
        if audioEngine.isRunning {
          stopRecording()
        } else {
            do {
                try startRecording()
                isRecording = true
            } catch {
                isRecording = false
            }
        }
    }
}

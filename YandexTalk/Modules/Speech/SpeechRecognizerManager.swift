import Speech
import AVFoundation

class SpeechRecognizerManager: NSObject, SFSpeechRecognizerDelegate {
    
    private let speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    var recognizedTextHandler: ((String?, Bool) -> Void)?
    var errorHandler: ((Error) -> Void)?
    var recordingDidStopHandler: (() -> Void)?
    
    override init() {
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ru-RU"))
        super.init()
        
        speechRecognizer?.delegate = self
    }
    
    func startRecording() throws {
        
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            errorHandler?(error)
            return
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
            let error = NSError(domain: "SpeechRecognizerError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Распознавание речи недоступно в данный момент."])
            errorHandler?(error)
            try? audioSession.setActive(false)
            return
        }
        
        guard let recognitionRequest = recognitionRequest else {
            let error = NSError(domain: "SpeechRecognizerError", code: 1002, userInfo: [NSLocalizedDescriptionKey: "Не удалось создать SFSpeechAudioBufferRecognitionRequest."])
            errorHandler?(error)
            try? audioSession.setActive(false)
            return
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { [weak self] result, error in
            guard let self = self else { return }
            
            var isFinal = false
            
            if let result = result {
                self.recognizedTextHandler?(result.bestTranscription.formattedString, result.isFinal)
                isFinal = result.isFinal
            }
            
            if let error = error {
                self.audioEngine.stop()
                self.audioEngine.inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                try? AVAudioSession.sharedInstance().setActive(false)
                self.errorHandler?(error)
                self.recordingDidStopHandler?()
            }
            
            if isFinal {
                self.audioEngine.stop()
                self.audioEngine.inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
                try? AVAudioSession.sharedInstance().setActive(false)
                self.recordingDidStopHandler?()
            }
        })
        
        let inputNode = audioEngine.inputNode
        guard inputNode.outputFormat(forBus: 0).streamDescription != nil else {
            let error = NSError(domain: "SpeechRecognizerError", code: 1003, userInfo: [NSLocalizedDescriptionKey: "Не удалось получить формат записи."])
            errorHandler?(error)
            try? AVAudioSession.sharedInstance().setActive(false)
            return
        }
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputNode.outputFormat(forBus: 0)) { buffer, _ in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            errorHandler?(error)
            try? AVAudioSession.sharedInstance().setActive(false)
            return
        }
    }
    
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask = nil
        try? AVAudioSession.sharedInstance().setActive(false)
        
        recordingDidStopHandler?()
    }
}

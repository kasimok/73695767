import AVFoundation
import Foundation

class Coordinator {
    
    let synthesizer: AVSpeechSynthesizer
    var player: AVAudioPlayer?
    
    init() {
        let synthesizer = AVSpeechSynthesizer()
        self.synthesizer = synthesizer
    }
    
    var recordingPath:  URL {
        let soundName = "Finally.caf"
        // I've tried numerous file extensions.  .caf was in an answer somewhere else.  I would think it would be
        // .pcm, but that doesn't work either.
        
        // Local Directory
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(soundName)
    }
    
    func speakPhrase(phrase: String) {
        let utterance = AVSpeechUtterance(string: phrase)
        utterance.voice = AVSpeechSynthesisVoice(language: "en")
        synthesizer.speak(utterance)
    }
    
    func playFile() {
        print("Trying to play the file")
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: recordingPath, fileTypeHint: AVFileType.caf.rawValue)
            guard let player = player else {return}
            
            player.play()
        } catch {
            print("Error playing file.")
        }
    }
    
    func saveAVSpeechUtteranceToFile() {
        
        let utterance = AVSpeechUtterance(string: "This is speech to record")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.50
        
        // Only create new file handle if `output` is nil.
        var output: AVAudioFile?
        
        synthesizer.write(utterance) { [self] (buffer: AVAudioBuffer) in
            guard let pcmBuffer = buffer as? AVAudioPCMBuffer else {
                fatalError("unknown buffer type: \(buffer)")
            }
            if pcmBuffer.frameLength == 0 {
                // Done
            } else {
                // this closure is called multiple times. so to save a complete audio, try create file handle only for once.
                
                do{
                    if output == nil {
                        try  output = AVAudioFile(
                            forWriting: recordingPath,
                            settings: pcmBuffer.format.settings,
                            commonFormat: .pcmFormatInt16,
                            interleaved: false)
                    }
                    try output?.write(from: pcmBuffer)
                }catch {
                    print(error.localizedDescription)
                }
                
            }
            
        }
    }
}

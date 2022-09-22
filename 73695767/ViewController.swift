

import UIKit

class ViewController: UIViewController {
    
    let coordinator: Coordinator = Coordinator()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func speechAction(_ sender: Any) {
        coordinator.speakPhrase(phrase: "Hello World")
    }
    
    @IBAction func generateAction(_ sender: Any) {
        // 1. Generate synthesizer
        coordinator.saveAVSpeechUtteranceToFile()
    }
    
    @IBAction func replayAction(_ sender: Any) {
        coordinator.playFile()
    }
    
    
    
    
}


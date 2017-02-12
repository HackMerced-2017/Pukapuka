//
//  ViewController.swift
//  AcessabilityScroller
//
//  Created by Craig on 2/11/17.
//  Copyright © 2017 Craig. All rights reserved.
//

import UIKit
import AudioKit

class ViewController: UIViewController {

    var noteArray = Array<[Note]!>(repeating: nil, count: 10)
    @IBOutlet weak var textView: UITextView!
    var y = 0;
    let mic = AKMicrophone()
    
    
    @IBAction func buttonPress(_ sender: Any) {
        UIView.animate(withDuration: 2.0, animations: {
            self.textView.contentOffset = CGPoint(x: 0, y: self.y)
        }, completion: nil)
        y += 25
        let yMax = self.textView.contentSize
        if(Int(yMax.height/1.5) < y){
        y -= 25
      }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let tracker = AKFrequencyTracker(mic, hopSize: 20, peakCount: 2000)
        AudioKit.output = tracker
        AudioKit.start()
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            let possibleNotes = Note.possibleNotes(for: tracker.frequency)
            print(possibleNotes)
            self.noteArray.removeLast()
            self.noteArray.insert(possibleNotes, at: 0)
        })
        
    }

    
    
    override func viewDidLoad() {
        super.loadView()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


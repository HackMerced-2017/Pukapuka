//
//  NoteTestViewController.swift
//  AutoScroller1
//
//  Created by Cal Stephens on 2/11/17.
//  Copyright © 2017 Krysia. All rights reserved.
//

import UIKit
import AudioKit

class NoteTestViewController: UIViewController {
    
    let mic = AKMicrophone()
    
    override func viewDidAppear(_ animated: Bool) {
     
        let tracker = AKFrequencyTracker(mic, hopSize: 20, peakCount: 2000)
        AudioKit.output = tracker
        AudioKit.start()
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
            let possibleNotes = Note.possibleNotes(for: tracker.frequency)
            print(possibleNotes)
        })
        
    }
    
    
}

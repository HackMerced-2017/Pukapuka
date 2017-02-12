//
//  ViewController.swift
//  AcessabilityScroller
//
//  Created by Craig on 2/11/17.
//  Copyright © 2017 Craig. All rights reserved.
//

import UIKit
import AudioKit

import Foundation

func matches(for regex: String, in text: String) -> [String] {
    
    do {
        let regex = try NSRegularExpression(pattern: regex)
        let nsString = text as NSString
        let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
        return results.map { nsString.substring(with: $0.range)}
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}


class ViewController: UIViewController {

    var noteArray = Array<[Note]!>(repeating: nil, count: 10)
    var songNotes = Array<String>()
    var microphoneNotes = Array<String>()
    @IBOutlet weak var textView: UITextView!
    var y = 0;
    let mic = AKMicrophone()
    
    var counter = 0;
    
    
    @IBAction func buttonPress(_ sender: Any) {
        UIView.animate(withDuration: 2.0, animations: {
            self.textView.contentOffset = CGPoint(x: 0, y: self.y)
        }, completion: nil)
        y += 10
        let yMax = self.textView.contentSize
        if(Int(yMax.height/1.5) < y){
        y -= 10
      }
    }
    
    func startScroll(_ animated: Bool)
    {
        songNotes = matches (for: "\\[[A-z0-9]{1,2}\\]", in: textView.text )
        for var j in songNotes {
            if( j.contains("m")){
                j = j.replacingOccurrences(of: "m", with: "")
            }
            else if (j.contains("7"))
            {
                j = j.replacingOccurrences(of: "7", with: "")
            }
            microphoneNotes.append(j)
        }

        print(microphoneNotes)
        }
 
    
    override func viewDidAppear(_ animated: Bool) {
        
        let tracker = AKFrequencyTracker(mic, hopSize: 20, peakCount: 2000)
        AudioKit.output = tracker
        AudioKit.start()
        
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true, block: { _ in
            let possibleNotes = Note.possibleNotes(for: tracker.frequency)
            print(possibleNotes)
            self.noteArray.removeLast()
            self.noteArray.insert(possibleNotes, at: 0)
            
            for i in self.microphoneNotes {
                
                if (i == possibleNotes.description)
                {
                    self.buttonPress(self)
                }
            }
            

        })
        self.startScroll(true);
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


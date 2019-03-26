//
//  ViewController.swift
//  Hangman
//
//  Created by Peter Salz on 26.03.19.
//  Copyright © 2019 Peter Salz App Development. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet var guessesLabel: UILabel!
    @IBOutlet var wordView: UIView!
    @IBOutlet var letterView: UIView!
    
    var words = [String]()
    var wordIndex = 0
    
    var letterLabels = [UILabel]()
    var letterButtons = [UIButton]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(loadWords), with: nil)
    }


    @IBAction func skipWordPressed(_ sender: UIButton)
    {
        
    }
    
    @objc func loadWords()
    {
        if let fileURL = Bundle.main.url(forResource: "HangmanWords",
                                         withExtension: "txt")
        {
            if let fileContents = try? String(contentsOf: fileURL)
            {
                words = fileContents.components(separatedBy: "\n")
                words.shuffle()
            }
        }
        
        DispatchQueue.main.async
        {   [weak self] in
            print(self?.words ?? "")
            
            guard let strongSelf = self else { return }
            strongSelf.setupNewWord(strongSelf.word(for: strongSelf.wordIndex))
        }
    }
    
    func clearLetterLabels()
    {
        letterLabels.forEach { $0.removeFromSuperview() }
        letterLabels.removeAll(keepingCapacity: false)
    }
    
    func setupLetterLabels(for word: String)
    {
        let wordLength = word.count
        
        for i in 0 ..< wordLength
        {
            let label = UILabel()
            label.text = "_"
            label.font = UIFont.systemFont(ofSize: 36, weight: .semibold)
            label.translatesAutoresizingMaskIntoConstraints = false
            
            letterLabels.append(label)
            
            wordView.addSubview(label)
            
            label.centerYAnchor.constraint(equalTo: wordView.centerYAnchor).isActive = true
            
            switch i
            {
            case 0:
                label.leadingAnchor.constraint(equalTo: wordView.leadingAnchor,
                                               constant: 20).isActive = true
            case word.count-1:
                label.leadingAnchor.constraint(equalTo: letterLabels[i-1].trailingAnchor,
                                               constant: 20).isActive = true
                label.trailingAnchor.constraint(equalTo: wordView.trailingAnchor,
                                                constant: 20).isActive = true
            default:
                label.leadingAnchor.constraint(equalTo: letterLabels[i-1].trailingAnchor,
                                               constant: 20).isActive = true
            }
        }
    }
    
    func setupNewWord(_ word: String)
    {
        clearLetterLabels()
        setupLetterLabels(for: word)
        setupLetterButtons()
    }
    
    func word(for index: Int) -> String
    {
        return words[index]
    }
    
    func setupLetterButtons()
    {
        
    }
}


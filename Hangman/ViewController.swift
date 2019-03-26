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
    
    let alphabet = ["A","B","C","D","E","F",
                    "G","H","I","J","K","L",
                    "M","N","O","P","Q","R",
                    "S","T","U","V","W","X",
                    "Y","Z"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        letterView.backgroundColor = .clear
        wordView.backgroundColor = .clear
        
        performSelector(inBackground: #selector(loadWords), with: nil)
        
        setupLetterButtons()
    }


    @IBAction func skipWordPressed(_ sender: UIButton)
    {
        guard wordIndex < words.count-1
        else
        {
            // TODO: TODO: Show alert.
            return
        }
        
        wordIndex = wordIndex + 1
        
        setupNewWord(word(for: wordIndex))
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
            //print(self?.words ?? "")
            
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
        
        letterButtons.forEach { $0.isHidden = false }
    }
    
    func word(for index: Int) -> String
    {
        return words[index]
    }
    
    func setupLetterButtons()
    {
        // Create 4x6 + 2 grid
        let scale = UIScreen.main.scale
        let width = Int((letterView.bounds.width / 6.0 / scale) * 0.9)
        let height = Int((letterView.bounds.height / 5.0 / scale) * 0.9)
        
        //print("letterView.width = \(letterView.bounds.width), letterView.height = \(letterView.bounds.height)")
        print("width = \(width), height = \(height)")
        
        for row in 0 ..< 5
        {
            let numberOfCols = row < 4 ? 6 : 2
            for col in 0 ..< numberOfCols
            {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
                letterButton.setTitle(alphabet[6*row + col], for: .normal)
                
                let frame = CGRect(x: col * width,
                                   y: row * height,
                                   width: width,
                                   height: height)
                letterButton.frame = frame
                
                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor.lightGray.cgColor
                
                letterView.addSubview(letterButton)
                letterButtons.append(letterButton)
                
                letterButton.addTarget(self,
                                       action: #selector(letterTapped),
                                       for: .touchUpInside)
            }
        }
    }
    
    @objc func letterTapped(_ sender: UIButton)
    {
        guard let letter = sender.titleLabel?.text else { return }
        
        // TODO: TODO: Check occurrences of the letter
        
        // TODO: TODO: If found, replace all letter labels with that letter
        
        // TODO: TODO: If not found, reduce guess count by 1
        
        // TODO: TODO: If guess count == 0, game over, then new game
        
        // TODO: TODO: If last letter was found, show message, then new game
        
        sender.isHidden = true
    }
}


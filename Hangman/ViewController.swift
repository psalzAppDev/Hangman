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
    {
        didSet
        {
            if !words.isEmpty
            {
                word = words[wordIndex]
            }
        }
    }
    
    var word = ""
    
    var letterLabels = [UILabel]()
    var letterButtons = [UIButton]()
    
    let maxNumberOfGuesses: Int = 7
    
    var numberOfGuesses: Int = 0
    {
        didSet
        {
            guessesLabel.text = String(numberOfGuesses)
        }
    }
    
    var numberOfCorrectGuesses: Int = 0
    
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
            let ac = UIAlertController(title: "Game over",
                                       message: "No more words!",
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Restart",
                                       style: .default, handler:
                                       {    [weak self] _ in
                                            self?.restart()
                                       }))
            present(ac, animated: true)
            
            return
        }
        
        nextWord()
    }
    
    func nextWord()
    {
        wordIndex = wordIndex + 1
        
        setupNewWord()
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
                
                DispatchQueue.main.async
                {   [weak self] in
                    
                    self?.wordIndex = 0
                    self?.setupNewWord()
                }
            }
        }
    }
    
    func clearLetterLabels()
    {
        letterLabels.forEach { $0.removeFromSuperview() }
        letterLabels = [UILabel]()
    }
    
    func setupLetterLabels(for word: String)
    {
        let wordLength = word.count
        
        let scale = UIScreen.main.scale
        let width = Int(wordView.bounds.width / scale / CGFloat(wordLength))
        //let width = 20
        let height = Int((wordView.bounds.height / scale)*0.5)
        
        for i in 0 ..< wordLength
        {
            let label = UILabel()
            label.text = "_"
            label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
            
            let frame = CGRect(x: i*(width + 20),
                               y: 0,
                               width: width,
                               height: height)
            
            label.frame = frame
            
            wordView.addSubview(label)
            letterLabels.append(label)
            
            /*
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
            */
        }
    }
    
    func restart()
    {
        words.shuffle()
        wordIndex = 0
        
        setupNewWord()
    }
    
    func setupNewWord()
    {
        clearLetterLabels()
        setupLetterLabels(for: word)
        
        numberOfGuesses = maxNumberOfGuesses
        numberOfCorrectGuesses = 0
        
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
        let width = Int(letterView.bounds.width / 6.0 / scale)
        let height = Int(letterView.bounds.height / 5.0 / scale)
        
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
        guard let tappedLetter = sender.titleLabel?.text?.lowercased() else { return }
        
        sender.isHidden = true
        
        var counter = 0
        var occurrences = [Int]()
        
        for letter in word
        {
            if tappedLetter == String(letter)
            {
                occurrences.append(counter)
            }
            counter += 1
        }
        
        if occurrences.isEmpty
        {
            numberOfGuesses -= 1
        }
        else
        {
            numberOfCorrectGuesses += occurrences.count
            for letter in occurrences
            {
                letterLabels[letter].text = tappedLetter.uppercased()
            }
        }
        
        checkGameOver()
    }
    
    func checkGameOver()
    {
        if numberOfGuesses == 0
        {
            let ac = UIAlertController(title: "Game over",
                                       message: "No more guesses!",
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Restart",
                                       style: .default,
                                       handler: { [weak self] _ in self?.restart() }))
            present(ac, animated: true)
        }
        else if numberOfCorrectGuesses == word.count
        {
            let ac = UIAlertController(title: "You win!",
                                       message: "\(word.uppercased()) is correct",
                                       preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Next",
                                       style: .default,
                                       handler: {[weak self] _ in self?.nextWord() }))
            present(ac, animated: true)
        }
    }
}


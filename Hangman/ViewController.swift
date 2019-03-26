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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func skipWordPressed(_ sender: UIButton) {
    }
}


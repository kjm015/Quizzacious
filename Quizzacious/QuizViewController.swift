//
//  QuizViewController.swift
//  Quizzacious
//
//  Created by Kevin Miyata on 11/27/18.
//  Copyright © 2018 Kevin Miyata. All rights reserved.
//

import Foundation
import UIKit

class QuizViewController: UIViewController {
    
    @IBOutlet weak var questionNameLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    func configureView() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    
    
}

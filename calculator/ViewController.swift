//
//  ViewController.swift
//  calculator
//
//  Created by Beatriz Carlos on 13/04/20.
//  Copyright © 2020 Beatriz Carlos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum Operations: String {
        case percentage = "%"
        case division = "÷"
        case multiplication = "x"
        case subtraction =  "-"
        case addition = "+"
        case equal = "="
        case none = ""
    }

    @IBOutlet weak var displayTextField: UILabel!
    @IBOutlet weak var equalButton: UIButton!
    
    var previousValue = 0.0
    var previousOperation = Operations.none
    var restartDisplay = false
    var runningOperation = false
    
    var valueDisplay: String = "0" {
        didSet {
            // When totaling, remove the .0 if it does not have decimal places.
            if runningOperation && valueDisplay.contains(".") {
                let value = Double(valueDisplay)!
                
                if value.truncatingRemainder(dividingBy: 1) == 0 {
                    valueDisplay.removeLast(2)
                }
            }
            displayTextField.text = valueDisplay
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRoundObject(equalButton)
    }

    //Leave the object round.
    func setRoundObject(_ object: AnyObject) {
        object.layer?.cornerRadius = object.frame.size.width / 2
        object.layer?.masksToBounds = true
    }
    
    // Clean button
    @IBAction func cleanClick() {
        previousValue = 0.0
        previousOperation = Operations.none
        restartDisplay = false
        runningOperation = false
        valueDisplay = "0"
    }
    
    @IBAction func backspaceClick() {
        if valueDisplay.count > 1 {
            valueDisplay.removeLast()
        }
        else {
            valueDisplay = "0"
        }
    }
    
    @IBAction func numberClick(_ sender: UIButton) {
        // Take the contents of that button.
        if let number = sender.titleLabel!.text {
            if valueDisplay == "0" || restartDisplay == true {
                valueDisplay = number == "." ? "0." : number
                restartDisplay = false
            }
            else {
                valueDisplay += number
            }
        }
    }
    
    
    @IBAction func operationClick(_ sender: UIButton) {
        if let operation = Operations(rawValue: sender.titleLabel!.text!) {
            if operation == .percentage {
                calculatePercentage()
            }
            else if operation == .equal {
                totalize()
            }
            else {
                if previousOperation != .none {
                    totalize()
                }
                
                previousValue = Double(valueDisplay)!
                previousOperation = operation
                restartDisplay = true
            }
        }
    }
    
    func calculatePercentage() {
        runningOperation = true
        defer {
            runningOperation = false
        }
              
        if previousValue != 0 && (previousOperation == .addition || previousOperation == .subtraction) {
            valueDisplay = String(previousValue * (Double(valueDisplay)! / 100))
        } else {
            valueDisplay = String(Double(valueDisplay)! / 100)
        }
    }
    
    func totalize() {
      runningOperation = true
      defer {
          runningOperation = false
      }
      
      let currentValue = Double(valueDisplay)!
      var amount = 0.0
      
      if previousOperation == .division {
          amount = previousValue / currentValue
      }
      else if previousOperation == .multiplication {
          amount = previousValue * currentValue
      }
      else if previousOperation == .subtraction {
          amount = previousValue - currentValue
      }
      else if previousOperation == .addition {
          amount = previousValue + currentValue
      }
      
      valueDisplay =  String(amount)
      previousOperation = .none
      restartDisplay = true
    }
}

//
//  mainViewController.swift
//  Calculator
//
//  Created by Daddy on 01/10/2024.
//

import UIKit

class mainViewController: UIViewController {
    var numberBeforeOpp: String!
    var fullOpp: String!
    var isResultShown: Bool = false
    var lastTappedNumber: String = ""

    @IBOutlet weak var numberViwer: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        numberBeforeOpp = ""
        fullOpp = ""
        numberViwer.adjustsFontSizeToFitWidth = true
    }

    func resetIfResultShown() {
        if isResultShown {
            numberViwer.text = "0"
            fullOpp = ""
            isResultShown = false
        }
    }

    func btnValues(_ number: String) {
        lastTappedNumber = number
        if numberViwer.text == "0" {
            numberViwer.text! = number
        } else {
            numberViwer.text! += number
        }
    }

    @IBAction func numberTapped(_ sender: UIButton) {
        resetIfResultShown()
        let number = String(sender.tag)
        btnValues(number)
    }

    @IBAction func btnDotTapped(_ sender: Any) {
        resetIfResultShown()
        if numberViwer.text?.contains(".") == false {
            numberViwer.text! += "."
        }
    }

    @IBAction func btnClearTapped(_ sender: Any) {
        numberViwer.text = "0"
        fullOpp = ""
        isResultShown = false
    }

    func processOperation(_ operation: String) {
        if numberViwer.text?.isEmpty == false {
            numberBeforeOpp = numberViwer.text
            fullOpp += numberBeforeOpp
            numberViwer.text = ""
            fullOpp += operation
        } else if let last = fullOpp.last, "+-×÷".contains(last) {
            fullOpp.removeLast()
            fullOpp += operation
        }
    }

    @IBAction func divideBtnTapped(_ sender: Any) {
        resetIfResultShown()
        processOperation("÷")
    }

    @IBAction func multiplyBtnTapped(_ sender: Any) {
        resetIfResultShown()
        processOperation("×")
    }

    @IBAction func minusBtnTapped(_ sender: Any) {
        resetIfResultShown()
        processOperation("-")
    }

    @IBAction func plusBtnTapped(_ sender: Any) {
        resetIfResultShown()
        processOperation("+")
    }

    @IBAction func backspaceTapped(_ sender: Any) {
        if var text = numberViwer.text, !text.isEmpty {
            text.removeLast()
            if text.isEmpty {
                numberViwer.text = "0"
            } else {
                numberViwer.text = text
            }
        }
    }

    @IBAction func equlaBtnTapped(_ sender: Any) {
        if let lastChar = fullOpp.last, "+-×÷".contains(lastChar) {
            fullOpp += lastTappedNumber
        } else {
            fullOpp += lastTappedNumber
        }

        print("Full Operation: \(fullOpp ?? "")")
        if let result = evaluateMathExpression(expression: fullOpp) {
            numberViwer.text = "\(result)"
            isResultShown = true
        } else {
            numberViwer.text = "Error"
            isResultShown = true
        }
        fullOpp = ""
    }

    func evaluateMathExpression(expression: String) -> Double? {
        let modifiedExpression = expression.replacingOccurrences(of: "÷", with: "/")
                                            .replacingOccurrences(of: "×", with: "*")

        let exp = NSExpression(format: modifiedExpression)

        if let result = exp.expressionValue(with: nil, context: nil) as? NSNumber {
            return result.doubleValue
        }

        return nil
    }
}


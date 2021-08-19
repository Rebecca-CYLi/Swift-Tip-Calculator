//
//  ViewController.swift
//  TipCalculator
//
//  Created by Rebecca Li on 8/18/21.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
   
    
    //Bill Amount Text Field
    @IBOutlet weak var billAmountTextField: UITextField!
    //Tip Amount Label $0.00
    @IBOutlet weak var tipAmountLabel: UILabel!
    // Segmented Tip Bar to Calculate Tip
    @IBOutlet weak var tipControl: UISegmentedControl!
    //Total Label $0.00
    @IBOutlet weak var totalLabel: UILabel!
    //(Optional) Number of People
    @IBOutlet weak var numOfPeople: UITextField!
    //display Bill Split Between Number of People
    @IBOutlet weak var billSplitLabel: UILabel!
    
    
    //Extra Feature: Tip Slider
    @IBOutlet weak var tipSlider: UISlider!
    //Tip slider Number
    @IBOutlet weak var tipSliderLabel: UILabel!
    
    
    //-------------- Sliding Bar Version -------------------------------------------
    //(Optional) Number of People Field
    @IBOutlet weak var slidingNumPeople: UITextField!
    //Bill Amount for Sliding Bar
    @IBOutlet weak var slidingBillAmount: UITextField!
    //tip amount for sliding
    @IBOutlet weak var slidingJustTips: UILabel!
    //Bill + Tips for Sliding Bar
    @IBOutlet weak var billNTips: UILabel!
    //Splitting the Bill+Tips evenly btw parties
    @IBOutlet weak var billSplitParty: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Tip Calculator"
        billAmountTextField.delegate = self
        billAmountTextField.becomeFirstResponder()
        
        //Looks for single or multiple taps
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    //Segment Tip Bar - Calculating Tip
    @IBAction func calculateTip(_ sender: Any) {
        
        //(Optional) Number of People
        let partyNum = Int(numOfPeople.text!) ?? 1
        
        //Get bill amount from text field input
        let bill = Double(billAmountTextField.text!) ?? 0
        
        //Get Total tip by multiplying tip * tipPercentage
        let tipPercentages = [0.15, 0.18, 0.2, 0.25, 0.30]
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        //Update Tip Amout Label
        tipAmountLabel.text = String(format: "$%.2f", tip)
        //Update Total Amount
        totalLabel.text = String(format: "$%.2f", total)
        
        //Split btw the number of people
        billSplitLabel.text = String(format: "$%.02f", total / Double(partyNum))
    }

    //Function for changing Tip Slider Values -------------------------------------------------
    @IBAction func tipSliderValueChange(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        tipSliderLabel.text = "\(currentValue)"
        
        // (Optional)
        let numPeople = Double(slidingNumPeople.text!) ?? 1
        //get bill amount from user
        let firstBillamount = Double(slidingBillAmount.text!) ?? 0
        //calculate tips
        let tip = firstBillamount * Double(currentValue)/100.00
        let newBillamount = firstBillamount + tip
        
        //update labels
        slidingJustTips.text = String(format: "$%.2f", tip)
        billNTips.text = String(format: "$%.2f", newBillamount)
        billSplitParty.text = String(format: "$%.2f", newBillamount / numPeople)
        
    }
    
    
    
    

}


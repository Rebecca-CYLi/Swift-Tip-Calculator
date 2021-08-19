//
//  ViewController.swift
//  TipCalculator
//
//  Created by Rebecca Li on 8/18/21.
//

import UIKit

class ViewController: UIViewController {
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
    
    // to store the current active textfield
    var activeTextField : UITextField? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Tip Calculator"
        billAmountTextField.delegate = self
        billAmountTextField.becomeFirstResponder()
        numOfPeople.delegate = self
        slidingNumPeople.delegate = self
        slidingBillAmount.delegate = self
        
        
        //Looks for single or multiple taps
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        //calls function to close keyboard
        view.addGestureRecognizer(tap)
        
        // call the 'keyboardWillShow' function when the view controller receive notification that keyboard is going to be shown
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            
            // if keyboard size is not available for some reason, dont do anything
           return
        }
        
        var shouldMoveViewUp = false
        
        // if active text field is not nil
        if let activeTextField = activeTextField {
            
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            
            if bottomOfTextField > topOfKeyboard {
                shouldMoveViewUp = true
            }
        }
        
        if(shouldMoveViewUp) {
            self.view.frame.origin.y = 0 - keyboardSize.height
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.view.frame.origin.y = 0
    }
    @objc func backgroundTap(_ sender: UITapGestureRecognizer) {
        // go through all of the textfield inside the view, and end editing thus resigning first responder
        // ie. it will trigger a keyboardWillHide notification
        self.view.endEditing(true)
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

extension ViewController : UITextFieldDelegate {
  // when user select a textfield, this method will be called
  func textFieldDidBeginEditing(_ textField: UITextField) {
    // set the activeTextField to the selected textfield
    self.activeTextField = textField
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    self.activeTextField = nil
  }
}

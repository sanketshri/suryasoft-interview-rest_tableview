//
//  ViewController.swift
//  Sankets-TestApp
//
//  Created by Sanket on 29/11/18.
//  Copyright © 2018 Developer Sanket. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    let searchAPI = SearchAPI()

    //Unwind Segue for coming on home screen from result page.
    @IBAction func unwind(_ segue:UIStoryboardSegue){
    }

    @IBOutlet weak var email_Text: UITextField!

    @IBOutlet weak var submit_Button:UIButton!

    @IBAction func submit_Button(_ sender: Any) {
        //validating the user input on button click
        if email_Text.text != nil && email_Text.text != ""{
            if (email_Text.text?.isValidEmail())!{
                self.performSegue(withIdentifier: "toResults", sender: self)
            }else{
                print("Invalid Email id")
                showPopUp(tittle: "Invalid Email Id", messsage: "Please enter a valid email address.", action: self.invalidInput)
            }
        }else{
            showPopUp(tittle: "No Email Id Entered", messsage: "Please enter a valid email address.", action: self.noInput)
            print("Empty text field")
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        submit_Button.layer.cornerRadius = 10
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ResultVC

        if email_Text.text != nil{

            destination.searchKey = email_Text.text

        }
    }

    //for Hiding keypad on outside touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    //for showing pop Up
    func showPopUp(tittle:String,messsage: String, action: @escaping (UIAlertAction) -> Void)  {

        let showPopUp = UIAlertController(title: tittle, message: messsage, preferredStyle: .alert)

        let Done = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: (action))
        showPopUp.addAction(Done)

        self.present(showPopUp, animated: true)

    }

    func invalidInput(alert:UIAlertAction!) {
        email_Text.text = ""
        email_Text.isFirstResponder
    }

    func noInput(alert:UIAlertAction!) {
        email_Text.isFirstResponder
    }




}

//for validating the entered email address
extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}


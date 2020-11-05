//
//  ViewController.swift
//  covid-screening-tool
//
//  Created by Sahil Arora on 2020-11-03.
//  Copyright © 2020 Sahil Arora. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var lbl_Thanlyou: UILabel!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak  var contentview:UIView!
    @IBOutlet weak var btnyes_ques1:UIButton!
    @IBOutlet weak var btnyes_ques2:UIButton!
    @IBOutlet weak var btnyes_ques3:UIButton!
    @IBOutlet weak var btnno_ques1:UIButton!
    @IBOutlet weak var btnno_ques2:UIButton!
    @IBOutlet weak var btnno_ques3:UIButton!
    @IBOutlet weak var textfield_date: UITextField!
    @IBOutlet weak var textfield_department: UITextField!
    @IBOutlet weak var txtfield_name: UITextField!
    @IBOutlet weak var txtfield_id: UITextField!
    
    
    //variables
       var name:String?
       var department:String?
       var time:String?
       var id:String?
       var symptoms:Bool?
       var travelled:Bool?
       var closeContact:Bool?
    
    //Firebase database refernece
    var reference:DatabaseReference!
    
    var commomColor =  UIColor.systemBlue
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        textfield_department.delegate = self
        textfield_date.delegate = self
        txtfield_name.delegate = self
        txtfield_id.delegate = self
        
        
        reference = Database.database().reference()
    
    }
    
    //MARK: ButtonActions
    @IBAction func action_submitresponse(_ sender: UIButton) {
        
        
        name = txtfield_name.text
        department = textfield_department.text
        id = txtfield_id.text
        time = textfield_date.text
        
        //Validation
        if name?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || department?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || time?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || id?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||   symptoms  == nil ||   travelled ==  nil || closeContact == nil
        {
            showAlert(message: "Fill the form completely")
        }
        else{
            let date = Date()
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "dd MMM yyyy"
            let datestring = dateformatter.string(from: date)
            let dict = ["id":id!,"name":name,"deptt":department,"response":false] as [String : Any]
            
            self.reference.child("\(datestring)").child("\(id!)").setValue(dict)
            if  symptoms == true || travelled == true    || closeContact == true
            {
                showAlert(message: "Kindly reach nearest covid test center and isolate yourself")
            }
            else
            {
                scrollview.isHidden = true
                lbl_Thanlyou.isHidden = false
            }
        }

        
        
    }
    
    @IBAction func action_symptoms(_ sender: UIButton) {
        
        if sender.tag == 1
        {
            changeButtonColor(btn1: btnyes_ques1, btn2: btnno_ques1)
            symptoms = true
            
        }else{
            symptoms = false
            changeButtonColor(btn1: btnno_ques1, btn2: btnyes_ques1)
        }
        
    }
    
    
    
    @IBAction func action_travelled(_ sender: UIButton) {
        
        if sender.tag == 1
        {
            changeButtonColor(btn1: btnyes_ques2, btn2: btnno_ques2)
            travelled = true
        }else{
            travelled = false
            changeButtonColor(btn1: btnno_ques2, btn2: btnyes_ques2)
            
        }
    }
    
    @IBAction func action_closecontact(_ sender: UIButton) {
        
        if sender.tag == 1
        {changeButtonColor(btn1: btnyes_ques3, btn2: btnno_ques3)
            
            closeContact = true
        }else{
            closeContact = false
            changeButtonColor(btn1: btnno_ques3, btn2: btnyes_ques3)
            
        }
    }
    //MARK: Method of Changing colors of button of questions
    func changeButtonColor(btn1:UIButton , btn2 :UIButton)
    {
        
        
        btn1.setTitleColor(UIColor.white, for: .normal)
        btn1.backgroundColor  =  UIColor.systemBlue
        
        btn2.setTitleColor(UIColor.systemBlue, for: .normal)
        btn2.backgroundColor  =  UIColor.white
    }
    //MARK : alert message
    func showAlert(message:String){
        let alertVc = UIAlertController(title: "Covid Screening Tool", message: message, preferredStyle: .actionSheet)
        alertVc.addAction(UIAlertAction(title: "Ok" , style: .default, handler: { _ in
            if  (self.symptoms == true || self.travelled == true    || self.closeContact != true) && (self.name?.trimmingCharacters(in: .whitespacesAndNewlines) != "" && self.department?.trimmingCharacters(in: .whitespacesAndNewlines) != "" && self.time?.trimmingCharacters(in: .whitespacesAndNewlines) != "" && self.id?.trimmingCharacters(in: .whitespacesAndNewlines) != "")
                       {
                        self.scrollview.isHidden = true
                        self.lbl_Thanlyou.isHidden = false
            }
            
        }))
        self.present(alertVc, animated: true, completion: nil)
    }
}

extension  ViewController:UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.layer.borderWidth = 1.5
        textField.clipsToBounds = true
        textField.layer.borderColor =  commomColor.cgColor
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor =  UIColor.clear.cgColor
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor =  UIColor.clear.cgColor
        if textField == txtfield_name
        {
            textfield_department.becomeFirstResponder()
        }
        if textField == textfield_department
        {
          
            textfield_date.becomeFirstResponder()
        }
        if  textField  == textfield_date{
            txtfield_id.becomeFirstResponder()
        }
        if textField == txtfield_id
        {
            textField.resignFirstResponder()
        }
        return  true
    }
    
}

//
//  BaseViewController.swift
//  MakeYourNotes
//
//  Created by Anuj Mohan Saxena on 03/10/21.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func customAlertController(ctrl:UIViewController){
        let alert = UIAlertController(title: "Alert", message: "Message", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")
                
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            }
        }))
        ctrl.present(alert, animated: true, completion: nil)
    }
}

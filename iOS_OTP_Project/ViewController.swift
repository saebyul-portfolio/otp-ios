//
//  ViewController.swift
//  iOS_OTP_Project
//
//  Created by saebyul on 2021/11/08.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBAction func AddNewProgram(_ sender: Any) {
        let alert = UIAlertController(title: "오류", message: "아직 이 기능은 지원하지 않습니다.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in }
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
    }
    
    @IBOutlet weak var token: UILabel!
    
    var timer : Int = 0
    var tokenValue : String = "000000"
    let oauthUrl = URL(string: "http://localhost/oauth")

    override func viewDidLoad() {
        super.viewDidLoad()
        loopTask()
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(loopTask), userInfo: nil, repeats: true)
    }
    
    @objc func loopTask() {
        tokenValue = makeToken()
        token.text = tokenValue
        let param = ["token" : tokenValue]
        guard let paramData = try? JSONEncoder().encode(param)
        else { return }
        
        var request = URLRequest(url: oauthUrl!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: paramData) {
            (data, response, error) in
            
            if let e = error {
                print("Error Excepted: \(e.localizedDescription)")
                return
            }
        }
        task.resume()
    }
    
    func makeToken() -> String {
        var numbers:[Int] = []
        var intStr : String = ""
        while numbers.count < 6{
            let number = Int.random(in: 0...9)
            if !numbers.contains(number) {
                numbers.append(number)
                intStr += String(number)
            }
        }
        return intStr
    }
}


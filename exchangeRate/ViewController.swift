//
//  ViewController.swift
//  exchangeRate
//
//  Created by Yejin on 2022/11/14.
//  한국수출입은행 SE2Y6C6EGD70paAx6BU80KLzlep1s7Ou
//  https://www.koreaexim.go.kr/site/program/financial/exchangeJSON?authkey=SE2Y6C6EGD70paAx6BU80KLzlep1s7Ou&searchdate=20221114&data=AP01
// searchdate 값에 오늘 날짜를 구해서 string 변환 후 넣기


import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var exchangeRateLb: UILabel!
    @IBOutlet weak var euroExchangeRateLb: UILabel!
    @IBOutlet weak var yenExchangeRateLb: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }


    @IBAction func dollarBtn(_ sender: Any) {
        self.getExchangeRate(from:"USD")
        self.view.endEditing(true)
    }
    @IBAction func euroBtn(_ sender: Any) {
        self.getExchangeRate(from:"EUR")
    }
    @IBAction func yenBtn(_ sender: Any) {
        self.getExchangeRate(from:"JPY")
    }
    
    func getExchangeRate(from: String) {
//        guard let url = URL(string: "ttps://api.apilayer.com/currency_data/convert?to=USD&from=KRW&amount=1") else { return }
//        let session = URLSession(configuration: .default)
//        session.dataTask(with: url) { data, response, error in
//            guard let data = data, error == nil else { return }
//            let decoder = JSONDecoder()
//            let exchangeRateData = try? decoder.decode(exchangeRateData.self, from: data)
//            debugPrint(exchangeRateData)
//        }.resume()
        
        var semaphore = DispatchSemaphore (value: 0)

        let url = "https://api.apilayer.com/currency_data/convert?to=KRW&from=\(from)&amount=1"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue("Kdy5E91UBaArB7RjmxtRmMxqYNtt3wEZ", forHTTPHeaderField: "apikey")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            let decoder = JSONDecoder()
            let exchangeRateData = try? decoder.decode(exchangeRateData.self, from: data)
            
            guard let exchangeRateData = exchangeRateData else {
                print("error")
                return
            }
            
            //소수점 둘째자리까지만 나오도록
            let exchangeRateResult = round(exchangeRateData.result*100)/100
            let euroResult = round(exchangeRateData.result*100)/100
            let yenResult = round(exchangeRateData.result*100)/100
            
            //스토리보드 라벨 업데이트
            DispatchQueue.main.async {
                switch from {
                case "USD":
                    self.exchangeRateLb.text = String(exchangeRateResult)
                case "EUR":
                    self.euroExchangeRateLb.text = String(euroResult)
                case "JPY":
                    self.yenExchangeRateLb.text = String(yenResult)
                default:
                    print("error")
                }
                                
            }
            
        
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        
    }

    
}


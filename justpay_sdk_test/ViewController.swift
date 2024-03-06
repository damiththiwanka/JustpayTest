//
//  ViewController.swift
//  justpay_sdk_test
//
//  Created by Damith Chandrasiri on 2024-02-21.
//

import UIKit
import LPTrustedSDK


class ViewController: UIViewController , LPTrustedSDKDelegate {
    
    
var token:String = "Bearer 48296EFEB8D6EC43E8208E76C20AB03EC597FC02F4EE885080375B384822784B0712B1DACB7E5053ACC8059631959C6492A934C2E997A7C30BD33EE6D6729CD9D58BC352520A30FAF2BCC33D95830F068E69FB27CD26E48D3D5FBD1626819E47ADAE0D12A91B4781F6B15B2B9BD7B51387CB7B680DA59207142C890A6B174E57531B534EB2CA83132F1E5A73671F28FCC5EF742709FADF20F3A6A7AD8CCFFBD1393405AF10EC12FD2FE25120A89E50B71AC30C97ED32235CBDA8BE5ED10D4FA0FCBFFC30A67BBDB8705832E69204B436498BA51808EBA8A99E59400753AC6E0F9A46412B6E40461796B6049DE0DAD5DD6717114F48208A9D9A4F3392519CC6ECAB7EFE5B4910411CE2B93A0F9B5D9B454D6649878BA657F4D7752380545C2F5F5477CEF3E4A57E2F6C673A1642584FC2824B520A136658B5774FABF1DDC927F4BE1304FEAFB2640746A9DF4C20772C5AC69704A0FEF781916AD3451A238F00B09E2C96A6C3658E882DAFCFE7B2C2BAE7B21AE0408651EBA384C9677B5BC3C70DE110F75E152FCD7C9323685C7C681E79142496C5379B7163C79FF720BB1FA3E3C939E4D3F881A3B04B84D2339D8200AF77536A3BDAAC32036E0D67AB33C10F656FE500E5F6F0551485ABEF00C0C3F4B78FC2B15CB40F6A263209A85700DC04E04C7A437C085AD605677C0B5946A14C66A6361A1EEE075C4CCDA86AC4056367EAA4C9A26EDFCE8BB3C6F3CBB06AA53BCC3B5734B8EB45F246917C8AB051A4FF2BF372F567BF86E7C8119E5ED8E3888618263D2E4B95F59807CB810B0BC044D06B0A2AB773C905326A6C4783B0B8FAF5C9798B8008BF62CC4B1E4265AC3FC3C9CF15C21F5D"
    
    var instrumentID:String!
    var challange:String!
    
    var registerResponceData:ResponseData!
    var verifyResponceData:ResponseData!
    
    @IBOutlet weak var loadinIndicator: UIActivityIndicatorView!
    @IBOutlet weak var creatIdentityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signMassageIndicator: UIActivityIndicatorView!
    @IBOutlet weak var accNumber: UITextField!
    
    @IBOutlet weak var CH_Name: UITextField!
    @IBOutlet weak var alias: UITextField!
    
    @IBOutlet weak var otp_text: UITextField!
    @IBOutlet weak var registerResponce: UILabel!
    @IBOutlet weak var challengeText: UILabel!
    
    @IBOutlet weak var createIdentityTogle: UISwitch!
    @IBOutlet weak var signMassageTogle: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LPTrustedSDK().delegate = self
        
       print(LPTrustedSDK().getVersion() ?? "N/A")
       
       // LPTrustedSDK().clearIdentity()
        
        creatIdentityIndicator.hidesWhenStopped=true
        signMassageIndicator.hidesWhenStopped=true
        
        loadinIndicator.hidesWhenStopped=true
        loadinIndicator.color=UIColor.orange
        loadinIndicator.style=UIActivityIndicatorView.Style.large
        
        createIdentityTogle.isHidden=true
        createIdentityTogle.setOn(false, animated:false)
        
        signMassageTogle.isHidden=true
        signMassageTogle.setOn(false, animated:false)
        
       
    }
    struct createAccModel: Codable {
        let accountNumber: String
        let accountName: String
        let alias: String
        let deviceId:String
        let platform:String
        let accountBankCode:String
        let isExistingUser:Bool
        
    }
    
    struct ResponseData: Codable {
        let account: Account!
        let challenge: String!
        }
    
   

    // MARK: - Account
    struct Account: Codable {
        let accountNumber, accountName, bankCode: String!
        let balance: [Balance]
        let instrumentID, name, alias: String!
        let remainingTime: Int!
        let instrumentType, status: String!
        let activated, isvisible: Bool!
        let isVishwa: Bool!
        let delete: Bool!
        let template: Template!
    }

    // MARK: - Balance
    struct Balance: Codable {
        let currency: String!
        let balance: Int!
        let merchantBalance: Int!
        let account: String!
    }

    // MARK: - Template
    struct Template: Codable {
        let templateID: String!
        let templateURL: String!

        enum CodingKeys: String, CodingKey {
            case templateID
            case templateURL = "templateUrl"
        }
    }
    
   
    // MARK: - VerifyBody
    struct VerifyBody: Codable {
        let amount:String
        let instrumentID: String
        let deviceId: String
        
    }
    
    struct ErrorResponse: Codable {
            let errorMessage: String // Adjust this based on your actual error response structure
        }
    

    
    func makeAPICall_register() {
        
        // Show loading indicator
        loadinIndicator.startAnimating()
        print("register API Call Starts")
        
        // Prepare the object with values from TextFields
        let myObject = createAccModel(
            accountNumber: accNumber.text ?? "",
            accountName: CH_Name.text ?? "",
            alias: alias.text ?? "",
            deviceId: LPTrustedSDK().getDeviceId(),
            platform: "ios",
            accountBankCode: "6990",
            isExistingUser: false)
        
       
        
        // Convert object to JSON data
        guard let jsonData = try? JSONEncoder().encode(myObject) else {
                    print("Failed to encode object to JSON")
                    // Hide loading indicator in case of failure
            loadinIndicator.stopAnimating()
                    return
                }
        
        
        print(String(data: jsonData, encoding: String.Encoding.utf8) ?? "N/A")
        
        // Define API URL
        let apiUrl = URL(string: "https://uatweb.sampath.lk/upgrade-api-iwallet/gateway/smb/jpy/registerAccount")!
        
        // Prepare URLRequest
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token,forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        // Make API call
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                           // Hide loading indicator when response received
                           self.loadinIndicator.stopAnimating()
                       }
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if httpResponse.statusCode == 200 {
                print("API call successful")
                
                // Parse response data
                if let registerResponceData = data {
                    do {
                        let decodedData = try JSONDecoder().decode(ResponseData.self, from: registerResponceData)
                        // Handle decoded data
                        DispatchQueue.main.async {
                            self.registerResponce.text = "\(String(describing: decodedData.account))"
                        }
                        self.instrumentID=decodedData.account.instrumentID
                        self.challange=String(describing: decodedData.challenge)
                        
                        print(decodedData)
                    } catch {
                        print("Error decoding response data: \(error)")
                    }
                }
                
                
            } else {
                print("Error response: \(httpResponse.statusCode)")
                
                // Parse error response data
                if let responseData = data {
                    do {
                        let decodedError = try JSONDecoder().decode(ErrorResponse.self, from: responseData)
                        // Handle decoded error
                        
                        // Display error message in the UILabel
                        DispatchQueue.main.async {
                            print( decodedError.errorMessage)
                        }
                    } catch {
                        print("Error decoding error response data: \(error)")
                    }
                }
                // Handle error response
            }
        }.resume()
    }
    
    func makeAPICall_Verify() {
        
        print("Verify API Call")
        
        // Show loading indicator
        loadinIndicator.startAnimating()
        
        
        
        // Prepare the object with values from TextFields
        let myObject = VerifyBody(
            amount: otp_text.text ?? "", instrumentID: instrumentID ?? "", deviceId: LPTrustedSDK().getDeviceId())
        
        // Convert object to JSON data
        guard let jsonDataVerify = try? JSONEncoder().encode(myObject) else {
                    print("Failed to encode object to JSON")
                    // Hide loading indicator in case of failure
            loadinIndicator.stopAnimating()
                    return
                }
        
        print(String(data: jsonDataVerify, encoding: String.Encoding.utf8) ?? "N/A")
        
        // Define API URL
        let apiUrl = URL(string: "https://uatweb.sampath.lk/upgrade-api-iwallet/gateway/smb/jpy/verifyAccount")!
        
        print(token)
        
        // Prepare URLRequest
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token,forHTTPHeaderField: "Authorization")
        request.httpBody = jsonDataVerify
        
        // Make API call
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                           // Hide loading indicator when response received
                           self.loadinIndicator.stopAnimating()
                       }
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            if httpResponse.statusCode == 200 {
                print("API call successful")
                
                // Parse response data
                                if let verifyResponceData = data {
                                    do {
                                        let decodedData = try JSONDecoder().decode(ResponseData.self, from: verifyResponceData)
                                      
                                        // Handle decoded data
                                        DispatchQueue.main.async {
                                            self.challengeText.text =  decodedData.challenge
                                        }
                                        self.challange=decodedData.challenge
                                        print(decodedData)
                                    } catch {
                                        print("Error decoding response data: \(error)")
                                    }
                                }
                
               
            } else {
                print("Error response: \(httpResponse.statusCode)")
                print("Error response: \(httpResponse.description)")
                
                // Parse error response data
                if let responseData = data {
                    do {
                        let decodedError = try JSONDecoder().decode(ErrorResponse.self, from: responseData)
                        // Handle decoded error
                        
                        // Display error message in the UILabel
                        DispatchQueue.main.async {
                            print( decodedError.errorMessage)
                        }
                    } catch {
                        print("Error decoding error response data: \(error)")
                    }
                }
               
                // Handle error response
            }
        }.resume()
    }
    
    
    
    @IBAction func createAccAPICall(_ sender: Any) {
        view.endEditing(true)
        makeAPICall_register()
    }
    @IBAction func otpVerifyAPICall(_ sender: Any) {
        view.endEditing(true)
        makeAPICall_Verify()
    }
    @IBAction func isIdentityCheck(_ sender: Any) {
        print(LPTrustedSDK().isIdentityExist())
    }
    
    func onIdentitySuccess() {
        creatIdentityIndicator.stopAnimating()
        createIdentityTogle.isHidden=false
        createIdentityTogle.setOn(true, animated:true)
       print("onIdentitySuccess")
    }
    
    func onIdentityFailed(_ errorCode: Int32, message errorMessage: String!) {
        creatIdentityIndicator.stopAnimating()
        createIdentityTogle.isHidden=false
        createIdentityTogle.setOn(false, animated:true)
        print( errorMessage ?? "identity error" )
    }
    
    func onMessageSignSuccess(_ signedMessage: String!, status: String!) {
        signMassageIndicator.stopAnimating()
        signMassageTogle.isHidden=false
        signMassageTogle.setOn(true, animated:true)
        print("onMessageSignSuccess" + signedMessage,status!)
    }
    
    func onMessageSignFailed(_ errorCode: Int32, message errorMessage: String!) {
        signMassageIndicator.stopAnimating()
        signMassageTogle.isHidden=false
        signMassageTogle.setOn(false, animated:true)
        print("onMessageSignFailed" + errorMessage ,errorCode)
    
    }
    
    @IBAction func getDeviceID(_ sender: Any) {
        print(LPTrustedSDK().getDeviceId()!)
    
    }
    
    @IBAction func crateIdentity(_ sender: Any) {
        // Show loading indicator
        creatIdentityIndicator.startAnimating()
        print("Challenge CeateIdentity : \(challange ?? "nill")")
        LPTrustedSDK().createIdentity(challange)
    
    }
    
    @IBAction func signMessage(_ sender: Any) {
        signMassageIndicator.startAnimating()
        LPTrustedSDK().signMessage("I hereby authorize Sampath Bank to debit my account not exceeding the transaction plus the convenience fee acceptable for the transaction (if applicable), \nfurther understand that should the debtor be someone other than me, Bank will not be concerned or required to inquire whether the debtor’s name on the record of the party to be credited is the same as that herein stated by me.")
    }


}


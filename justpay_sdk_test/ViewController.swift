//
//  ViewController.swift
//  justpay_sdk_test
//
//  Created by Damith Chandrasiri on 2024-02-21.
//

import UIKit
import LPTrustedSDK


class ViewController: UIViewController , LPTrustedSDKDelegate {
    
    
var token:String = "Bearer 3DEF4973566976F4B2A80A57453C68AA98FCAD8775F7582FACC0A09D5C38F4B93E713BE1627AAFA6C581CB2AC4AD69FFA3FC195E3E3D7ECE052470AA77E70AB736F82B08A56EA4B65C9205F37ABC6934DFA765A09FD5A3F85E14D062A10D67325DFDD200B049BCD1C9205D64649875117FF0E64E37359C16307CC8E987907B305EE35A0CEFFF421983CAFD87C8FA5355DC65A98E56B4341C9A7CB15AC69C345F1C9C15B243F334C392AEBA0CBD77F4ACEACE0767FE1CA66A440A7EFD7D83B23AEB43A25C39E6BFDD8885CF7F580E3BFE769C73EAF200311A791A16C85E85373940AA140F8FD189A7AEF03640FB785CBCDA30E9C88EF4FBA8C5D16AA133AFD68882ABDBCFEFA81FB255BE020E1BA772BE78CF1BD14D5E27DB95099E669C960E3E4E4AF4647DC3B53D2BFFB60A7EA6B7CA5443A650BDFB5F95D0F4213C8751430201326E5E4BA5BBE0187A3B4CDB29AD168F0E226C58874AD948DE58EEE488BC5A6C19B2ECF2CFD23A784C5254185850DCC10B9AFC0659AC10BAECF9D0F2A7BBC88DE8C0102432E25A12903376F1958E127C8DE95533A68FB3EB0AFFC2B271052D2C5FE357BA77D93B562D6C8600F0E59B1B978F8E11783D004DC46E9DAE8CB6B8C727B5DB9469461876E849861B22921FF7EEE02A224D55E3F565A389E0F3667CD2DA613F32D049F52D4FD00D2A58474ADC4A7D9C68E3EDDFEA7BBC087DE67EA3AB9222AA1D0EBACF7A405C7815C23CFB1DB7F7A93B2D82FF38FF61FDB3C23A9F6C1A09216DD034BA2C8B7890B596F4BCB3430BEC810A7BF5C00E07068A3B83B987C2D40437C1A44C0826EC7FB00A8A60CEABB54FF88AB5F338F9937355F14B958A7855FA"
    
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


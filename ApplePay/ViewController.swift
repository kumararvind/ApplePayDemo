//
//  ViewController.swift
//  ApplePay
//
//  Created by VISHAL-SETH on 1/31/17.
//  Copyright © 2017 Infoicon. All rights reserved.
//

import UIKit
import PassKit
class ViewController: UIViewController ,PKPaymentAuthorizationViewControllerDelegate
{
    var cancelButtonPressed = false
    var authorizationFailed: Bool?
    
//    @available(iOS 8.0, *)
//    public func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController)
//    {
//        
//    }
    
    private var marchentId="merchant.com.infoicon.ApplePayDemo"
    var paymentRequest : PKPaymentRequest!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    
    func itemToSell(shipping:Double)->[PKPaymentSummaryItem]
    {
        let tShirt = PKPaymentSummaryItem(label:"Jordan T-Shirt",amount :45.00)
        let discount = PKPaymentSummaryItem(label:"discount",amount :-5.00)
        let shipping = PKPaymentSummaryItem(label:"shipping",amount:NSDecimalNumber(string:"\(shipping)"))
        let totalAmount=tShirt.amount.adding(discount.amount)
        let total = PKPaymentSummaryItem(label:"Infoicon Inc",amount:totalAmount)
        
        return[tShirt,discount,shipping,total]
        
        
    }
    
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect shippingMethod: PKShippingMethod, completion: @escaping (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem]) -> Void)
    {
        completion(PKPaymentAuthorizationStatus.success,itemToSell(shipping: Double(shippingMethod.amount)))
    }
    
   
    
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void)
//    {
//        completion(PKPaymentAuthorizationStatus.success)
//        
//    }
    
    // When touch id is pressed on apple pay sheet to authorize the payment.
     func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping ((PKPaymentAuthorizationStatus) -> Void)) {
        self.cancelButtonPressed = false;
        if authorizationFailed == true {
            print("\(#function) Payment failed")
            completion(PKPaymentAuthorizationStatus.failure)
            /*When the completion block executes here the
             control goes to paymentAuthorizationViewControllerDidFinish
             with the cancelButtonPressed set to false*/
        }else{
            print("\(#function) Payment success")
            /*When the completion block executes here
             the control goes to paymentAuthorizationViewControllerDidFinish
             with the cancelButtonPressed set to false*/
            completion(PKPaymentAuthorizationStatus.success)
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: {
            
            guard self.cancelButtonPressed == true || self.cancelButtonPressed == nil else {
                //Cancel button NOT tapped
                print("\(#function) Cancel button NOT tapped")
                return
            }
            //Cancel button tapped
            print("\(#function) Cancel button tapped")
        })
    }
    
    
    
    @IBAction func pay(_ sender: Any)
    {
        
        let paymentNetwork=[PKPaymentNetwork.amex, .masterCard,.discover]
        if PKPaymentAuthorizationViewController .canMakePayments(usingNetworks:paymentNetwork)
        {
            paymentRequest = PKPaymentRequest()
            paymentRequest.currencyCode="USD"
            paymentRequest.countryCode="US"
            paymentRequest.merchantIdentifier="merchant.com.infoicon.ApplePayDemo"
            paymentRequest.supportedNetworks=paymentNetwork
            paymentRequest.merchantCapabilities = .capability3DS
            paymentRequest.requiredShippingAddressFields=[.all]
        paymentRequest.paymentSummaryItems=self.itemToSell(shipping: 4.99)
            let sameDayShiiping = PKShippingMethod(label:"Same day delivery",amount:12.99)
            sameDayShiiping.detail="Delivery is guranted by same day."
            sameDayShiiping.identifier="sameDay."

            
            let twoDayShiiping = PKShippingMethod(label:"Same day delivery",amount:4.99)
            twoDayShiiping.detail="Delivery is guranted by two day."
            twoDayShiiping.identifier="twoDay"
            
            let freeDayShiiping = PKShippingMethod(label:"Same day delivery",amount:0.0)
            freeDayShiiping.detail="Delivery to u within 7 days."
            freeDayShiiping.identifier="freeShipping"
            
            paymentRequest.shippingMethods=[sameDayShiiping,twoDayShiiping,freeDayShiiping]
            let applePayVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            applePayVC.delegate=self
            self.present(applePayVC, animated: true, completion: nil)
            
        }
        else
        {
            print("Set apple pay in your device")
        }
        

        
    }
    
    
    
    
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    
}


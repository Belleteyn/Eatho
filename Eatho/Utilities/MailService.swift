//
//  MailService.swift
//  Eatho
//
//  Created by Серафима Зыкова on 06/11/2019.
//  Copyright © 2019 Серафима Зыкова. All rights reserved.
//

import Foundation
import MessageUI

class MailService {
    
    static let instance = MailService()
    
    enum Address: String {
        case support = "eatho@support.com"
    }
    
    enum Subject: String {
        case passwordResetCode = "Password reset: code was not received"
    }
    
    enum Message: String {
        case passwordResetCode = "I didn't receive confirmation code, please help me with it.\n\nReset requested for account:"
    }
    
    
    func createEmailVC(to: String, subject: String, text: String) -> MFMailComposeViewController? {
        if !MFMailComposeViewController.canSendMail() {
            return nil
        }
        
        let mail = MFMailComposeViewController()
        mail.setToRecipients([to])
        mail.setSubject(subject)
        mail.setMessageBody(text, isHTML: true)
        
        return mail
    }
}

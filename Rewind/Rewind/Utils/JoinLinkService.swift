//
//  JoinLinkService.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 28.03.2024.
//

import Foundation
import CommonCrypto

final class JoinLinkService {
    static func createJoinLink(groupId: Int) -> URL? {
        guard let encryptedGroupId = encrypt(intValue: groupId, key: "777") else {
            print("Failed to encrypt group ID")
            return nil
        }
        
        let urlString = "https://rewindapp.ru/join?gid=\(encryptedGroupId)"
        return URL(string: urlString)
    }
}

// MARK: - Encrypt Funcs
extension JoinLinkService {
    private static func encrypt(intValue: Int, key: String) -> String? {
        var data = Data()
        withUnsafeBytes(of: intValue) { rawBuffer in
            data.append(contentsOf: rawBuffer)
        }
        
        guard let encryptedData = encrypt(data: data, key: key) else {
            return nil
        }
        
        let encryptedString = encryptedData.base64EncodedString()
        return encryptedString
    }
    
    private static func encrypt(data: Data, key: String) -> Data? {
        let keyData = key.data(using: .utf8)!
        let inputData = data as NSData
        let encryptedData = NSMutableData(length: Int(inputData.length) + kCCBlockSizeAES128)!
        let keyLength = size_t(kCCKeySizeAES128)
        let operation = CCOperation(kCCEncrypt)
        let algorithm = CCAlgorithm(kCCAlgorithmAES)
        let options = CCOptions(kCCOptionPKCS7Padding)
        
        var numBytesEncrypted: size_t = 0
        
        let cryptStatus = CCCrypt(
            operation,
            algorithm,
            options,
            (keyData as NSData).bytes, keyLength,
            nil,
            inputData.bytes, inputData.length,
            encryptedData.mutableBytes, encryptedData.length,
            &numBytesEncrypted
        )
        
        if cryptStatus == kCCSuccess {
            encryptedData.length = Int(numBytesEncrypted)
            return encryptedData as Data
        }
        
        return nil
    }
}

// MARK: - Decrypt Funcs
extension JoinLinkService {
    static func decrypt(encryptedString: String) -> Int? {
        guard let encryptedData = Data(base64Encoded: encryptedString) else {
            return nil
        }
        
        guard let decryptedData = decrypt(data: encryptedData, key: "777") else {
            return nil
        }
        
        var intValue: Int = 0
        decryptedData.withUnsafeBytes { rawBuffer in
            intValue = rawBuffer.load(as: Int.self)
        }
        
        return intValue
    }
    
    private static func decrypt(data: Data, key: String) -> Data? {
        let keyData = key.data(using: .utf8)!
        let inputData = data as NSData
        let decryptedData = NSMutableData(length: Int(inputData.length) + kCCBlockSizeAES128)!
        let keyLength = size_t(kCCKeySizeAES128)
        let operation = CCOperation(kCCDecrypt)
        let algorithm = CCAlgorithm(kCCAlgorithmAES)
        let options = CCOptions(kCCOptionPKCS7Padding)
        
        var numBytesDecrypted: size_t = 0
        
        let cryptStatus = CCCrypt(
            operation,
            algorithm,
            options,
            (keyData as NSData).bytes, keyLength,
            nil,
            inputData.bytes, inputData.length,
            decryptedData.mutableBytes, decryptedData.length,
            &numBytesDecrypted
        )
        
        if cryptStatus == kCCSuccess {
            decryptedData.length = Int(numBytesDecrypted)
            return decryptedData as Data
        }
        
        return nil
    }
}

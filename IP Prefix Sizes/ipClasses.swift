//
//  IpAddress.swift
//  170304 IP Calculator
//
//  Created by Anders Pedersen on 05/03/17.
//  Copyright © 2017 Anders Pedersen. All rights reserved.
//

import Foundation
import GameplayKit


/* **** Classes goes here **** */

class IpAddress {
    var byte: [Int]
    
    init() {
        byte = [0,0,0,0]
    }
    
    func genIpAddress() {
        // generate IP address first octet restricted to >1 and <223
        byte[0] = GKRandomSource.sharedRandom().nextInt(upperBound: 223) + 1

        // generate IP address first octet restricted to >1 and <254
        for i in 0 ... 3 {
            byte[i] = GKRandomSource.sharedRandom().nextInt(upperBound: 254) + 1
        }
    }
    
    func dotted() -> String {
        return ("\(byte[0]).\(byte[1]).\(byte[2]).\(byte[3])")
    }
}

class NetworkAddress: IpAddress {

        func calcNetworkAddress (funcIpAddress: IpAddress, funcPrefixLength: Prefix) {
            // calculate network address (int) from IP address and prefix length
            let networkAddressValue = (addressToInt64(funcIpAddress: funcIpAddress) & funcPrefixLength.SubnetMask())
    
            // convert network address (int) to bytes
            let funcNetworkAddress = int64ToAddress(funcInt64: networkAddressValue)
            for i in 0 ... 3 {
                self.byte[i] = funcNetworkAddress.byte[i]
            }
        }
}

class Prefix {
    var length: Int

    init() {
        length = 0
    }
    
    func genPrefixLength() {
        // generate a prefix length from array of pre-selected values
        let funcPrefixArray = [12,16,19,20,21,22,22,22,23,24,24,24,24,25,26,27,28,28,28,29]
        let funcRandomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: funcPrefixArray.count)
        length = funcPrefixArray[funcRandomNumber]
    }
    
    func SubnetMask () -> Int64 {
        // convert prefix (class) into a binary subnet mask (string)
        let funcOneStr = "11111111111111111111111111111111"
        let funcZeroStr = "00000000000000000000000000000000"
        let oneIndex = funcOneStr.index(funcOneStr.startIndex, offsetBy: (length))
        let zeroIndex = funcOneStr.index(funcOneStr.startIndex, offsetBy: (32 - length))
        let funcSubnetMaskString = funcOneStr.substring(to: oneIndex) + funcZeroStr.substring(to: zeroIndex)
        
        return (Int64(funcSubnetMaskString, radix: 2)!) // convert binary (string) to integer value
    }

    func toInt32 () -> Int {
        var value = 1
        for _ in 1 ... (32-length) {value *= 2} // missing 2^x math function
        return (value - 1)
    }
}


/* **** Functions goes here **** */

func addressToInt64(funcIpAddress: IpAddress) -> Int64 {
    // convert IP address (class) to integer value
    // using Int64 instead of Int to support iPhone 5
    var funcInt64 = Int64(funcIpAddress.byte[0])*256*256*256
    funcInt64 += Int64(funcIpAddress.byte[1])*256*256
    funcInt64 += Int64(funcIpAddress.byte[2])*256
    funcInt64 += Int64(funcIpAddress.byte[3])

    return funcInt64
}

func int64ToAddress(funcInt64: Int64) -> IpAddress {
    // convert integer value to IP address (class)
    let funcIpAddress = IpAddress() // init and placeholder value
    var funcValue = funcInt64     // move input value into mutable variable

    funcIpAddress.byte[0] = Int(funcValue/(256*256*256))
    funcValue -= Int64(funcIpAddress.byte[0])*256*256*256
    funcIpAddress.byte[1] = Int(funcValue/(256*256))
    funcValue -= Int64(funcIpAddress.byte[1])*256*256
    funcIpAddress.byte[2] = Int(funcValue/256)
    funcIpAddress.byte[3] = Int(funcValue - Int64(funcIpAddress.byte[2]*256))

    return funcIpAddress
}

func broadcast(address: IpAddress, prefix: Int) -> [Int] {
    var broadcast = addressToInt64(funcIpAddress: address)
    broadcast += (prefix)
    return(int64ToAddress(funcInt64: broadcast).byte)
}


//
//  quizClasses.swift
//  170304 IP Calculator
//
//  Created by Anders Pedersen on 05/03/17.
//  Copyright © 2017 Anders Pedersen. All rights reserved.
//

import Foundation
import GameplayKit


/* **** Classes goes here **** */

class PrefixTuple {
    var prefixes = [Prefix]()
    var right: Int
    
    init() {
        right = 0
        for _ in 0 ... 3 {
            prefixes.append(Prefix())
        }
    }
    
    func generate(funcPrefix: Prefix) {
        right = GKRandomSource.sharedRandom().nextInt(upperBound: 4)
        for i in 0 ... 3 {
            prefixes[i].length = funcPrefix.length + i - right
        }
        /*
         Examples
         0: (0:0, 1:1, 2:2, 3:3)
         2: (0:-2, 1:-1, 2:0, 3:1)
         */
    }
}

class NetworkTuple {
    var networks = [NetworkAddress]()
    
    init() {
        for _ in 0 ... 3 {
            networks.append(NetworkAddress())
        }
    }
    
    func checkForDuplicates() -> Bool {
        var duplicates = true
        if (networks[0].byte != networks[1].byte) {
            if (networks[1].byte != networks[2].byte) {
                if (networks[2].byte != networks[3].byte) {
                    duplicates = false
                }
            }
        }
        return duplicates
    }
}

class IpNetworkTuple {
    var ipAddress: IpAddress
    var networkTuple: NetworkTuple
    var prefix: Prefix
    var prefixTuple: PrefixTuple
    
    init() {
        ipAddress = IpAddress()
        networkTuple = NetworkTuple()
        prefix = Prefix()
        prefixTuple = PrefixTuple()
    }
    
    func genSet() {
        
        var check: Bool
        
        repeat {
            repeat {
                ipAddress.genIpAddress()
                prefix.genPrefixLength()
                prefixTuple.generate(funcPrefix: prefix)
                for i in 0 ... 3 {
                    networkTuple.networks[i].calcNetworkAddress(funcIpAddress: ipAddress, funcPrefixLength: prefixTuple.prefixes[i])
                }
            } while (networkTuple.checkForDuplicates() == true)
            
            check = (ipAddress.byte == networkTuple.networks[prefixTuple.right].byte)
            if check {print("equal to network id")} else {
                print("network \(networkTuple.networks[prefixTuple.right].byte)")
            }
            check = check || (ipAddress.byte == broadcast(address: networkTuple.networks[prefixTuple.right], prefix: prefixTuple.prefixes[prefixTuple.right].toInt32()))
            if check {print("equal to broadcast")} else {
                print("broadcast", terminator: "")
                print(broadcast(address: networkTuple.networks[prefixTuple.right], prefix: prefixTuple.prefixes[prefixTuple.right].toInt32()))
            }
        } while check
    }
}

class RouteNetworkTuple {
    var ipAddress: IpAddress
    var networkTuple: NetworkTuple
    var prefix: Prefix
    var prefixTuple: PrefixTuple
    var metric: [Int]
    var match: [Bool]
    var distance: [Float]
    var bestMatch: Int
    
    init() {
        ipAddress = IpAddress()
        networkTuple = NetworkTuple()
        prefix = Prefix()
        prefixTuple = PrefixTuple()
        metric = [10, 10, 10, 10]
        match = [true,true,true,true]
        distance = [0, 0, 0, 0]
        bestMatch = 0
    }
    
    func genSet() {
        
        var shortestDistance: Float
        var duplicates: Bool
        
        repeat {
            ipAddress.genIpAddress()
            prefix.genPrefixLength() // gen length in [12;29]
            
            var randInt1, randInt2: Int // gen Int in [0;3]
            for i in 0 ... 3 {
                // generate random prefixes and metrics
                randInt1 = GKRandomSource.sharedRandom().nextInt(upperBound: 4)
                randInt2 = GKRandomSource.sharedRandom().nextInt(upperBound: 4)
                prefixTuple.prefixes[i].length = prefix.length - 1 + randInt1
                metric[i] = (randInt2+1) * 10
                // generate networks
                networkTuple.networks[i].calcNetworkAddress(funcIpAddress: genOffsetIp(ipaddress: ipAddress), funcPrefixLength: prefixTuple.prefixes[i])
            }
            
            shortestDistance = 0
            duplicates = false
            for i in 0 ... 3 {
                // check if ip address matches network
                match[i] = matchIpAndPrefix(ipadress: ipAddress, network: networkTuple.networks[i], prefix: prefixTuple.prefixes[i])
                
                // calculate distance, check for duplicates and remember shortest
                if (match[i]) {
                    distance[i] = Float(prefixTuple.prefixes[i].length)
                    distance[i] += ((100 - Float(metric[i])) / 100)
                    if distance[i] == shortestDistance { duplicates = true }
                    if distance[i] > shortestDistance {
                        shortestDistance = distance[i]
                        bestMatch = i
                    }
                } else {
                    distance[i] = -1
                }
            }
        } while (shortestDistance == 0 || duplicates == true)
        
        /* debug */
        print("* ipAddress: \(ipAddress.dotted())/\(prefix.length) *")
        for i in 0 ... 3 {
            print("\(networkTuple.networks[i].dotted())", terminator: "/")
            print("\(prefixTuple.prefixes[i].length)", terminator: ", ")
            print("match: \(match[i])", terminator: ", ")
            print("distance: \(distance[i])")
            
        }
        print ("Best match: \(bestMatch)")
        /* debug */
    }
    
    func logicalAndIpAndPrefix(ipaddress: IpAddress, prefix: Prefix) -> IpAddress {
        let ip32 = addressToInt64(funcIpAddress: ipaddress)
        let prefix32 = prefix.SubnetMask()
        let result64 = Int64( UInt32(ip32) & UInt32(prefix32) )
        return( int64ToAddress(funcInt64: result64) )
    }
    
    func matchIpAndPrefix(ipadress: IpAddress, network: NetworkAddress, prefix: Prefix) -> Bool {
        let resultIp = logicalAndIpAndPrefix(ipaddress: ipAddress, prefix: prefix)
        if resultIp.dotted() == network.dotted() {
            return true
        } else {
            return false
        }
    }
    
    func genOffsetIp(ipaddress: IpAddress) -> IpAddress {
        let randInt = GKRandomSource.sharedRandom().nextInt(upperBound: 16) // gen Int in [0;15]
        var randBigInt = 1
        for _ in 1 ... (randInt + 1) {randBigInt *= 2} // missing 2^x math function
        let ipInt64 = ( addressToInt64(funcIpAddress: ipaddress) + randBigInt )
        return int64ToAddress(funcInt64: ipInt64)
    }

}

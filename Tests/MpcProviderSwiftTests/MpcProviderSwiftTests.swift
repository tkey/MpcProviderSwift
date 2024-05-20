import XCTest

import mpc_core_kit_swift
@testable import MpcProviderSwift
import BigInt
import web3

final class MpcProviderSwiftTests: XCTestCase {
    let example1 = """
        {
          "types": {
            "EIP712Domain": [
              {
                "name": "name",
                "type": "string"
              },
              {
                "name": "version",
                "type": "string"
              },
              {
                "name": "chainId",
                "type": "uint256"
              },
              {
                "name": "verifyingContract",
                "type": "address"
              }
            ],
            "Person": [
              {
                "name": "name",
                "type": "string"
              },
              {
                "name": "wallet",
                "type": "address"
              }
            ],
            "Mail": [
              {
                "name": "from",
                "type": "Person"
              },
              {
                "name": "to",
                "type": "Person"
              },
              {
                "name": "contents",
                "type": "string"
              }
            ]
          },
          "primaryType": "Mail",
          "domain": {
            "name": "Ether Mail",
            "version": "1",
            "chainId": 1,
            "verifyingContract": "0xCcCCccccCCCCcCCCCCCcCcCccCcCCCcCcccccccC"
          },
          "message": {
            "from": {
              "name": "Account",
              "wallet": "0x048975d4997d7578a3419851639c10318db430b6"
            },
            "to": {
              "name": "Bob",
              "wallet": "0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB"
            },
            "contents": "Hello, Bob!"
          }
        }
    """.data(using: .utf8)!
    
    func resetMPC(email: String, verifier: String, clientId: String) async throws {
        var coreKitInstance = MpcCoreKit(web3AuthClientId: clientId, web3AuthNetwork: .SAPPHIRE_DEVNET, localStorage: MemoryStorage())
        
        let data = try  mockLogin2(email: email)
        let token = data
        
        
        let keyDetails = try await coreKitInstance.loginWithJwt(verifier: verifier, verifierId: email, idToken: token)
        try await coreKitInstance.resetAccount()
    }
    
    
    func testMpcProviderSigning() async throws {
        
        let email = "testiosEmail004"
        let verifier = "torus-test-health"
        let clientId = "torus-test-health"
        
        // reset account for testing
        try await resetMPC(email: email, verifier: verifier, clientId: clientId)
        
        
        // setup mpc
        let memoryStorage = MemoryStorage()
        var coreKitInstance = MpcCoreKit( web3AuthClientId: clientId, web3AuthNetwork: .SAPPHIRE_DEVNET, localStorage: memoryStorage)
        
        let data = try  mockLogin2(email: email)
        let token = data
        
        let _ = try await coreKitInstance.loginWithJwt(verifier: verifier, verifierId: email, idToken: token)
        
        //
        let provider = MPCEthereumProvider(evmSigner: coreKitInstance )
        let msg = "hello world"
        let result = try provider.sign(message: msg)
        print(result)
        
        let decoder = JSONDecoder()
        let typedData = try decoder.decode(TypedData.self, from: example1)
        let typedDataResult = try provider.signMessage(message: typedData)
        print(typedDataResult)
    }
}

//
//  CipherAESTests.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 27/12/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation
import XCTest
import CryptoSwift

class AESTests: XCTestCase {
    // 128 bit key
    let aesKey:[Byte] = [0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f]

    func testAES_encrypt2() {
        let key:[Byte]   = [0x36, 0x37, 0x39, 0x66, 0x62, 0x31, 0x64, 0x64, 0x66, 0x37, 0x64, 0x38, 0x31, 0x62, 0x65, 0x65];
        let iv:[Byte]    = [0x6b, 0x64, 0x66, 0x36, 0x37, 0x33, 0x39, 0x38, 0x44, 0x46, 0x37, 0x33, 0x38, 0x33, 0x66, 0x64]
        let input:[Byte] = [0x62, 0x72, 0x61, 0x64, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00];
        
        let expected:[Byte] = [0xae,0x8c,0x59,0x95,0xb2,0x6f,0x8e,0x3d,0xb0,0x6f,0x0a,0xa5,0xfe,0xc4,0xf0,0xc2];
        
        if let aes = AES(key: NSData.withBytes(key), iv: NSData.withBytes(iv), blockMode: .CBC) {
            let encrypted = aes.encrypt(NSData.withBytes(input))
            XCTAssertEqual(encrypted!, NSData.withBytes(expected), "encryption failed")
            let decrypted = aes.decrypt(encrypted!)
            XCTAssertEqual(decrypted!, NSData.withBytes(input), "decryption failed")
        } else {
            XCTAssert(false, "failed")
        }
    }

    func testAES_encrypt() {
        let input:[Byte] = [0x00, 0x11, 0x22, 0x33,
            0x44, 0x55, 0x66, 0x77,
            0x88, 0x99, 0xaa, 0xbb,
            0xcc, 0xdd, 0xee, 0xff];
        
        let expected:[Byte] = [0x69, 0xc4, 0xe0, 0xd8,
            0x6a, 0x7b, 0x4, 0x30,
            0xd8, 0xcd, 0xb7, 0x80,
            0x70, 0xb4, 0xc5, 0x5a];
        
        if let aes = AES(key: NSData.withBytes(aesKey), iv: nil, blockMode: .ECB) {
            let encrypted = aes.encrypt(NSData.withBytes(input))
            XCTAssertEqual(encrypted!, NSData.withBytes(expected), "encryption failed")
            let decrypted = aes.decrypt(encrypted!)
            XCTAssertEqual(decrypted!, NSData.withBytes(input), "decryption failed")
        } else {
            XCTAssert(false, "failed")
        }
    }

    func testAES_encrypt_cbc() {
        let key:[Byte] = [0x2b,0x7e,0x15,0x16,0x28,0xae,0xd2,0xa6,0xab,0xf7,0x15,0x88,0x09,0xcf,0x4f,0x3c];
        let iv:[Byte] = [0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,0x0E,0x0F]
        let plaintext:[Byte] = [0x6b,0xc1,0xbe,0xe2,0x2e,0x40,0x9f,0x96,0xe9,0x3d,0x7e,0x11,0x73,0x93,0x17,0x2a]
        let expected:[Byte] = [0x76,0x49,0xab,0xac,0x81,0x19,0xb2,0x46,0xce,0xe9,0x8e,0x9b,0x12,0xe9,0x19,0x7d];
        
        if let aes = AES(key: NSData.withBytes(key), iv:NSData.withBytes(iv), blockMode: .CBC) {
            XCTAssertTrue(aes.blockMode == .CBC, "Invalid block mode")
            let encrypted = aes.encrypt(NSData.withBytes(plaintext))
            XCTAssertEqual(encrypted!, NSData.withBytes(expected), "encryption failed")
            let decrypted = aes.decrypt(encrypted!)
            XCTAssertEqual(decrypted!, NSData.withBytes(plaintext), "decryption failed")
        } else {
            XCTAssert(false, "failed")
        }
    }
    
    func testAES_encrypt_cfb() {
        let key:[Byte] = [0x2b,0x7e,0x15,0x16,0x28,0xae,0xd2,0xa6,0xab,0xf7,0x15,0x88,0x09,0xcf,0x4f,0x3c];
        let iv:[Byte] = [0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x0A,0x0B,0x0C,0x0D,0x0E,0x0F]
        let plaintext:[Byte] = [0x6b,0xc1,0xbe,0xe2,0x2e,0x40,0x9f,0x96,0xe9,0x3d,0x7e,0x11,0x73,0x93,0x17,0x2a]
        let expected:[Byte] = [0x3b,0x3f,0xd9,0x2e,0xb7,0x2d,0xad,0x20,0x33,0x34,0x49,0xf8,0xe8,0x3c,0xfb,0x4a];
        
        if let aes = AES(key: NSData.withBytes(key), iv:NSData.withBytes(iv), blockMode: .CFB) {
            XCTAssertTrue(aes.blockMode == .CFB, "Invalid block mode")
            let encrypted = aes.encrypt(NSData.withBytes(plaintext))
            XCTAssertEqual(encrypted!, NSData.withBytes(expected), "encryption failed")
            let decrypted = aes.decrypt(encrypted!)
            XCTAssertEqual(decrypted!, NSData.withBytes(plaintext), "decryption failed")
        } else {
            XCTAssert(false, "failed")
        }
    }
    
    func testAES_SubBytes() {
        let input:[[Byte]] = [[0x00, 0x10, 0x20, 0x30],
            [0x40, 0x50, 0x60, 0x70],
            [0x80, 0x90, 0xa0, 0xb0],
            [0xc0, 0xd0, 0xe0, 0xf0]]
        
        let expected:[[Byte]] = [[0x63, 0xca, 0xb7, 0x04],
            [0x09, 0x53, 0xd0, 0x51],
            [0xcd, 0x60, 0xe0, 0xe7],
            [0xba, 0x70, 0xe1, 0x8c]]
        
        let substituted = AES(key: NSData.withBytes(aesKey))!.subBytes(input)
        XCTAssertTrue(compareMatrix(expected, substituted), "subBytes failed")
        let inverted = AES(key: NSData.withBytes(aesKey))!.invSubBytes(substituted)
        XCTAssertTrue(compareMatrix(input, inverted), "invSubBytes failed")
    }
    
    func testAES_shiftRows() {
        let input:[[Byte]] = [[0x63, 0x09, 0xcd, 0xba],
            [0xca, 0x53, 0x60, 0x70],
            [0xb7, 0xd0, 0xe0, 0xe1],
            [0x04, 0x51, 0xe7, 0x8c]]
        
        let expected:[[Byte]] = [[0x63, 0x9, 0xcd, 0xba],
            [0x53, 0x60, 0x70, 0xca],
            [0xe0, 0xe1, 0xb7, 0xd0],
            [0x8c, 0x4, 0x51, 0xe7]]
        
        let shifted = AES(key: NSData.withBytes(aesKey))!.shiftRows(input)
        XCTAssertTrue(compareMatrix(expected, shifted), "shiftRows failed")
        let inverted = AES(key: NSData.withBytes(aesKey))!.invShiftRows(shifted)
        XCTAssertTrue(compareMatrix(input, inverted), "invShiftRows failed")
    }
    
    func testAES_multiply() {
        XCTAssertTrue(AES(key: NSData.withBytes(aesKey))?.multiplyPolys(0x0e, 0x5f) == 0x17, "Multiplication failed")
    }
    
    func testAES_expandKey() {
        let expected:[Byte] = [0x0, 0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xa, 0xb, 0xc, 0xd, 0xe, 0xf, 0xd6, 0xaa, 0x74, 0xfd, 0xd2, 0xaf, 0x72, 0xfa, 0xda, 0xa6, 0x78, 0xf1, 0xd6, 0xab, 0x76, 0xfe, 0xb6, 0x92, 0xcf, 0xb, 0x64, 0x3d, 0xbd, 0xf1, 0xbe, 0x9b, 0xc5, 0x0, 0x68, 0x30, 0xb3, 0xfe, 0xb6, 0xff, 0x74, 0x4e, 0xd2, 0xc2, 0xc9, 0xbf, 0x6c, 0x59, 0xc, 0xbf, 0x4, 0x69, 0xbf, 0x41, 0x47, 0xf7, 0xf7, 0xbc, 0x95, 0x35, 0x3e, 0x3, 0xf9, 0x6c, 0x32, 0xbc, 0xfd, 0x5, 0x8d, 0xfd, 0x3c, 0xaa, 0xa3, 0xe8, 0xa9, 0x9f, 0x9d, 0xeb, 0x50, 0xf3, 0xaf, 0x57, 0xad, 0xf6, 0x22, 0xaa, 0x5e, 0x39, 0xf, 0x7d, 0xf7, 0xa6, 0x92, 0x96, 0xa7, 0x55, 0x3d, 0xc1, 0xa, 0xa3, 0x1f, 0x6b, 0x14, 0xf9, 0x70, 0x1a, 0xe3, 0x5f, 0xe2, 0x8c, 0x44, 0xa, 0xdf, 0x4d, 0x4e, 0xa9, 0xc0, 0x26, 0x47, 0x43, 0x87, 0x35, 0xa4, 0x1c, 0x65, 0xb9, 0xe0, 0x16, 0xba, 0xf4, 0xae, 0xbf, 0x7a, 0xd2, 0x54, 0x99, 0x32, 0xd1, 0xf0, 0x85, 0x57, 0x68, 0x10, 0x93, 0xed, 0x9c, 0xbe, 0x2c, 0x97, 0x4e, 0x13, 0x11, 0x1d, 0x7f, 0xe3, 0x94, 0x4a, 0x17, 0xf3, 0x7, 0xa7, 0x8b, 0x4d, 0x2b, 0x30, 0xc5]
        
        if let aes = AES(key: NSData.withBytes(aesKey)) {
            XCTAssertEqual(expected, aes.expandKey(), "expandKey failed")
        }
        
    }
    
    func testAES_addRoundKey() {
        let input:[[Byte]] = [[0x00, 0x44, 0x88, 0xcc],
            [0x11, 0x55, 0x99, 0xdd],
            [0x22, 0x66, 0xaa, 0xee],
            [0x33, 0x77, 0xbb, 0xff]]
        
        let expected:[[Byte]] = [[0, 64, 128, 192],
            [16, 80, 144, 208],
            [32, 96, 160, 224],
            [48, 112, 176, 240]]
        
        if let aes = AES(key: NSData.withBytes(aesKey)) {
            let result = aes.addRoundKey(input, aes.expandKey(), 0)
            XCTAssertTrue(compareMatrix(expected, result), "addRoundKey failed")
        }
    }
    
    func testAES_mixColumns() {
        let input:[[Byte]] = [[0x63, 0x9, 0xcd, 0xba],
            [0x53, 0x60, 0x70, 0xca],
            [0xe0, 0xe1, 0xb7, 0xd0],
            [0x8c, 0x4, 0x51, 0xe7]]
        
        let expected:[[Byte]] = [[0x5f, 0x57, 0xf7, 0x1d],
            [0x72, 0xf5, 0xbe, 0xb9],
            [0x64, 0xbc, 0x3b, 0xf9],
            [0x15, 0x92, 0x29, 0x1a]]
        
        if let aes = AES(key: NSData.withBytes(aesKey)) {
            let mixed = aes.mixColumns(input)
            XCTAssertTrue(compareMatrix(expected, mixed), "mixColumns failed")
            let inverted = aes.invMixColumns(mixed)
            XCTAssertTrue(compareMatrix(input, inverted), "invMixColumns failed")
        }
    }

}

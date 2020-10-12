//
//  PeripheralESP32.swift
//  RoshyBLE2
//
//  Created by Roshy on 10/11/20.
//

import UIKit
import CoreBluetooth

class ParticlePeripheral: NSObject {

    /// MARK: - Particle LED services and charcteristics Identifiers

    public static let particleLEDServiceUUID     = CBUUID.init(string: "4fafc201-1fb5-459e-8fcc-c5c9c331914b")
    public static let redLEDCharacteristicUUID   = CBUUID.init(string: "beb5483e-36e1-4688-b7f5-ea07361b26a8")

}

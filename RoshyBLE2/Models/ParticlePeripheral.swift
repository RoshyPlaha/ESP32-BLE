import UIKit
import CoreBluetooth

protocol ParticleDelegate {
    
}

class ParticlePeripheral: NSObject {
    
    /// MARK: - Particle LED services and charcteristics Identifiers
    
    public static let particleLEDServiceUUID     = CBUUID.init(string: "4fafc201-1fb5-459e-8fcc-c5c9c331914b")
    public static let redLEDCharacteristicUUID   = CBUUID.init(string: "beb5483e-36e1-4688-b7f5-ea07361b26a8")
    public static let greenLEDCharacteristicUUID = CBUUID.init(string: "b4250402-fb4b-4746-b2b0-93f0e61122c6")
    public static let blueLEDCharacteristicUUID  = CBUUID.init(string: "b4250403-fb4b-4746-b2b0-93f0e61122c6")
    
    public static let batteryServiceUUID         = CBUUID.init(string: "180f")
    public static let batteryCharacteristicUUID  = CBUUID.init(string: "2a19")
    
}

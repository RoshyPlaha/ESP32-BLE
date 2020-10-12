import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate {

    // Properties
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    private var counter = 0
    
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var EventBluetoothState: UILabel!
    @IBOutlet weak var eventBleState: UILabel!
    @IBOutlet weak var eventCloudStateCounter: UILabel!
    @IBOutlet weak var eventCloudSync: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View loaded")
        // Do any additional setup after loading the view.
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    // If we're powered on, start scanning
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update")
        
        
        DispatchQueue.main.async
        {

            
            self.eventBleState.textColor = UIColor.red
            self.eventBleState.text = "Disconnected"

        }
        
        if central.state != .poweredOn {
            print("Central is not powered on")
            
            DispatchQueue.main.async
            {
                self.EventBluetoothState.textColor = UIColor.red
                self.EventBluetoothState.text = "Off"
            }
            
        } else {
            
            DispatchQueue.main.async
            {
                self.EventBluetoothState.textColor = UIColor.green
                self.EventBluetoothState.text = "On"
            }
            
            print("Central scanning for", ParticlePeripheral.particleLEDServiceUUID);
            centralManager.scanForPeripherals(withServices: [ParticlePeripheral.particleLEDServiceUUID],
                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }

    // Handles the result of the scan
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        // We've found it so stop scan
        self.centralManager.stopScan()
        
        // Copy the peripheral instance
        self.peripheral = peripheral
        self.peripheral.delegate = self
        
        // Connect!
        self.centralManager.connect(self.peripheral, options: nil)
        
    }
    
    // The handler if we do connect succesfully
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected to your Device")
            
            DispatchQueue.main.async
            {
                self.eventBleState.textColor = UIColor.green
                self.eventBleState.text = "Connected"
            }
            
            // Start of AWS post
            let url = URL(string: "https://hz0dua7oid.execute-api.eu-west-2.amazonaws.com")!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data,
                    let response = response as? HTTPURLResponse,
                    error == nil else {                                              // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                    return
                }

                guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                    print("statusCode should be 2xx, but is \(response.statusCode)")
                    print("response = \(response)")
                    return
                }

                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString)")
                
                DispatchQueue.main.async
                {
                    self.eventCloudSync.textColor = UIColor.white;
                    self.eventCloudSync.text = responseString
                }
                
            }
            task.resume()
            // end of AWS post
            
            counter = counter + 1;
            DispatchQueue.main.async
            {
                self.eventCloudStateCounter.textColor = UIColor.white
                self.eventCloudStateCounter.text = String(self.counter);
            }
            
            
//            peripheral.discoverServices([ParticlePeripheral.particleLEDServiceUUID,ParticlePeripheral.batteryServiceUUID]);
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if peripheral == self.peripheral {
            print("Disconnected")
            
            DispatchQueue.main.async
            {
                self.eventBleState.textColor = UIColor.yellow
                self.eventBleState.text = "Disconnected"
            }
            
            self.peripheral = nil
            
            // Start scanning again
            print("Central scanning for", ParticlePeripheral.particleLEDServiceUUID);
            centralManager.scanForPeripherals(withServices: [ParticlePeripheral.particleLEDServiceUUID],
                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    // Handles discovery event
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == ParticlePeripheral.particleLEDServiceUUID {
                    print("LED service found")
                    //Now kick off discovery of characteristics
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                     didUpdateNotificationStateFor characteristic: CBCharacteristic,
                     error: Error?) {
        print("Enabling notify ", characteristic.uuid)
        
        if error != nil {
            print("Enable notify error")
        }
    }

    func peripheral(_ peripheral: CBPeripheral,
                     didUpdateValueFor characteristic: CBCharacteristic,
                     error: Error?) {
        }
    
    
    // Handling discovery of characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for _ in characteristics {
            }
        }
    }
}

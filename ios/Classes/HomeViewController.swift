import WeScanBatch
import Flutter
import Foundation

class HomeViewController: UIViewController, ImageScannerControllerDelegate {    

    var _result:FlutterResult?   

    override func viewDidAppear(_ animated: Bool) {       

        if self.isBeingPresented {
            let scannerObjects = ImageScannerOptions()
            let scannerVC = ImageScannerController(options: scannerObjects)
            scannerVC.imageScannerDelegate = self
            present(scannerVC, animated: true, completion: nil)
        }  
    }

    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        print(error)
        _result!(nil)
        self.dismiss(animated: true)
    }    

    func imageScannerController(_ scanner: ImageScannerController, didFinishWithSession results: MultiPageScanSession) {
        // Your ViewController is responsible for dismissing the ImageScannerController
        scanner.dismiss(animated: true)
        
        
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let newPath = path + "/" + randomString(length: 10) + ".pdf"
        path = path + "/file.pdf"
        
        let fileManager = FileManager.default
        do {
            try fileManager.moveItem(atPath: path, toPath: newPath)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        // so now we want to rename the new file to a random string
        // let fileData = NSData(contentsOfFile: path)
        // let pdfString:String = fileData!.base64EncodedString(options: .endLineWithLineFeed)
        
        // _result!(pdfString)
         _result!(newPath)
        self.dismiss(animated: true)
        //let imagePath = saveImage(image:results.scannedImage)
        // _result!(imagePath)
          // self.dismiss(animated: true)
        }
        

        func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        // Your ViewController is responsible for dismissing the ImageScannerController
        
        scanner.dismiss(animated: true)
         _result!(nil)
        self.dismiss(animated: true)
    }
    

//    func saveImage(image: UIImage) -> String? {
//        guard let data = image.UIImageJPEGRepresentation(compressionQuality: 1) ?? image.pngData() else {
//            return nil
//        }
//
//        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
//            return nil
//        }
//        var fileName = randomString(length:10);
//        let filePath: URL = directory.appendingPathComponent(fileName + ".png")!
//
//
//        do {
//            let fileManager = FileManager.default
//
//            // Check if file exists
//            if fileManager.fileExists(atPath: filePath.path) {
//                // Delete file
//                try fileManager.removeItem(atPath: filePath.path)
//            } else {
//                print("File does not exist")
//            }
//
//        }
//        catch let error as NSError {
//            print("An error took place: \(error)")
//        }
//
//        do {
//            try data.write(to: filePath)
//            return filePath.path
//        } catch {
//            print(error.localizedDescription)
//            return nil
//        }
//    }
    

    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}

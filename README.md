## BarCodeReaderView
BarCodeReaderView is a swift class that inherits from `UIView` which can read Barcodes.

## Installing
The prefered way to integrate `BarCodeReaderView` is through cocoapods.

Add `pod 'BarCodeReaderView'` to your Podfile.


## Using it
first thing you need to import it
```swift
import BarCodeReaderView
```
Then you can either hook it through InterfaceBuilder, or using code as follows:
```swift
let barcodeReader = BarcodeReaderView(frame: CGRect(x: 20.0, y: 20.0, width: 200, height: 200))
self.view.addSubview(barcodeReader)
```

after that you just set the delegate and barcode types:
```swift
barcodeReader.delegate = self
barcodeReader.barCodeTypes = [.Code128]
```
for supported barcode types see supported barcode types section


delegate should implement two methods:
```swift
func barcodeReader(barcodeReader: BarcodeReaderView, didFailReadingWithError error: NSError) {
// handle error
}

func barcodeReader(barcodeReader: BarcodeReaderView, didFinishReadingString info: String) {
//handle success reading
}
```

once every thing ready, you call 
```swift
barcodeReader.startCapturing()
```
and you can stop capturing by calling
```swift
barcodeReader.stopCapturing()
```

## Supported Barcode Types
Aztec

Code128

PDF417Barcode

QR

UPCECode

Code39Code

Code39Mod43Code

EAN13Code

EAN8Code

Interleaved2of5Code

ITF14Code

DataMatrixCode


## Licence
BarCodeReaderView is available under the MIT license.

## Author
Omar Alshammari

[@Follow me on Twitter](http://twitter.com/omaarr90)


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/omaarr90/barcodereaderview/trend.png)](https://bitdeli.com/free "Bitdeli Badge")


Pod::Spec.new do |spec|
  spec.name = "BarCodeReaderView"
  spec.version = "1.0.3"
  spec.summary = "This Framework allows app to read barcodes"
  spec.homepage = "https://github.com/omaarr90/BarCodeReaderView"
  spec.license = { :type => 'MIT', :file=> 'LICENSE' }
  spec.authors = { "Omar Alshammari" => 'omar.alshammary@hotmail.com' }
  spec.social_media_url = "http://twitter.com/omaarr90"

  spec.source = { :git=> "https://github.com/omaarr90/BarCodeReaderView.git", :tag=> "v#{spec.version}", :submodules=> true }
  spec.source_files  ="BarCodeReader/**/*.{h,swift}"
  spec.requires_arc = true
  spec.platform     = :ios
  spec.ios.deployment_target = "8.0"
end
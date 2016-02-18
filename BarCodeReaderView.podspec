Pod::Spec.new do |spec|
  spec.name = "BarCodeReaderView"
  spec.version = "1.0.0"
  spec.summary = "This Framework allows app to read barcodes"
  spec.homepage = "https://github.com/jakecraige/RGB"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Omar Alshammari" => 'omar.alshammary@hotmail.com' }
  spec.social_media_url = "http://twitter.com/omaarr90"

  spec.platform = :ios, "8.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/omaarr90/BarCodeReaderView.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "BarCodeReaderView/**/*.{h,swift}"
end
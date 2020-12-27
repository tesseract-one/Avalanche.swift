Pod::Spec.new do |s|
  s.name             = 'Avalanche'
  s.version          = '0.0.1'
  s.summary          = 'Avalanche.swift - The Avalanche Platform Swift Library'

  s.description      = <<-DESC
Avalanche.swift is a Swift Library for interfacing with the Avalanche Platform.
The library allows one to issue commands to the Avalanche node APIs.
                       DESC

  s.homepage         = 'https://github.com/tesseract-one/Avalanche.swift'

  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { 'Tesseract Systems, Inc.' => 'info@tesseract.one' }
  s.source           = { :git => 'https://github.com/tesseract-one/Avalanche.swift.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.12'
  s.tvos.deployment_target = '10.0'
  s.watchos.deployment_target = '6.0'
  
  s.swift_versions = ['5', '5.1', '5.2']

  s.module_name = 'Avalanche'
  
  s.subspec 'Avalanche' do |ss|
    ss.source_files = 'Sources/Avalanche/**/*.swift'

    ss.dependency 'Avalanche/Bech32'
    ss.dependency 'Avalanche/RPC'
    ss.dependency 'BigInt', '~> 5.2'
    ss.dependency 'Serializable.swift', '~> 0.2'
    
    ss.test_spec 'AvalancheTests' do |test_spec|
      test_spec.platforms = {:ios => '10.0', :osx => '10.12', :tvos => '10.0'}
      test_spec.source_files = 'Tests/AvalancheTests/**/*.swift'
    end
  end

  s.subspec 'Bech32' do |ss|
    ss.source_files = 'Sources/Bech32/**/*.swift'
    
    ss.test_spec 'Bech32Tests' do |test_spec|
      test_spec.platforms = {:ios => '10.0', :osx => '10.12', :tvos => '10.0'}
      test_spec.source_files = 'Tests/Bech32Tests/**/*.swift'
    end
  end
  
  s.subspec 'RPC' do |ss|
    ss.source_files = 'Sources/RPC/**/*.swift'

    ss.dependency 'TesseractWebSocket', '~> 0.0.7'
    
    ss.test_spec 'RPCTests' do |test_spec|
      test_spec.platforms = {:ios => '10.0', :osx => '10.12', :tvos => '10.0'}
      test_spec.source_files = 'Tests/RPCTests/**/*.swift'
    end
  end
  
  s.default_subspecs = 'Avalanche'
end

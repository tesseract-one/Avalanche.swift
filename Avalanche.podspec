Pod::Spec.new do |s|
  s.name             = 'Avalanche'
  s.version          = '0.0.1'
  s.summary          = 'Avalanche platform Swift SDK'

  s.description      = <<-DESC
Swift language SDK for Avalanche blockchain platform
                       DESC

  s.homepage         = 'https://github.com/tesseract-one/Avalanche.swift'

  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { 'Tesseract Systems, Inc.' => 'info@tesseract.one' }
  s.source           = { :git => 'https://github.com/tesseract-one/Avalanche.swift.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'
  
  s.swift_versions = ['5', '5.1', '5.2']

  s.module_name = 'Avalanche'

  s.source_files = 'Sources/Avalanche/**/*.swift'
  
  s.dependency 'BigInt', '~> 5.2'
  s.dependency 'Starscream', '~> 4.0'
  
  s.test_spec 'Tests' do |test_spec|
    test_spec.platforms = {:ios => '9.0', :osx => '10.10', :tvos => '9.0'}
    test_spec.source_files = 'Tests/AvalancheTests/**/*.swift'
  end
end

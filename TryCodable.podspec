Pod::Spec.new do |s|
  s.name = 'TryCodable'
  s.version = '0.1.0'
  s.license = 'MIT'
  s.summary = 'A more flexible way to Decode and Encode data'
  s.homepage = 'https://github.com/plspalding/TryCodable'
  s.authors = { 'Preston Spalding' => 'gsnpreston@gmail.com' }
  s.source = { :git => 'https://github.com/plspalding/TryCodable.git', :tag => s.version }
  s.documentation_url = 'https://github.com/plspalding/TryCodable'

  s.ios.deployment_target = '10.1'

  s.source_files = 'Source/*.swift'
end

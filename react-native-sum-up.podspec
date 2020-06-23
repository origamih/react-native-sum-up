require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-sum-up"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-sum-up
                   DESC
  s.homepage     = "https://github.com/origamih/react-native-sum-up"
  s.license      = "MIT"
  s.license      = { :type => "MIT" }
  s.authors      = { "Razzle Tran" => "origamih@email.com" }
  s.platforms    = { :ios => "9.0" }
  s.source       = { :git => "https://github.com/origamih/react-native-sum-up.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true

  s.dependency "React"
  s.dependency "SumUpSDK", '>= 3.5b1'
  # ...
  # s.dependency "..."
end


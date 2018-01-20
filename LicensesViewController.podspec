Pod::Spec.new do |s|
  s.name             = "LicensesViewController"
  s.version          = "0.6.5"
  s.summary          = "Give credit where credit is due."
  s.description      = <<-DESC
                        Recursively finds all LICENSE.* files in a given directory and generates that can be displayed via Settings.bundle or the provided view controller.
                       DESC

  s.homepage         = "https://github.com/carloe/LicenseGenerator-iOS"
  s.screenshot       = "https://github.com/carloe/LicenseGenerator-iOS/raw/master/screenshot.png"
  s.license          = 'MIT'
  s.author           = { "Carlo Eugster" => "carlo@relaun.ch" }
  s.source           = { :git => "https://github.com/carloe/LicenseGenerator-iOS.git", :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.requires_arc = true

  s.source_files = 'LicensesViewController/**/*.swift'
end

Pod::Spec.new do |spec|
    spec.name = 'RTProgressBar'
    spec.version = '1.0'
    spec.summary = 'Simple progress bar in swift for macOS'
    spec.description = <<-DESC
    RTProgressBar is a lightweight progress bar for macOS in Swift
                        DESC
    spec.homepage = 'https://github.com/RuntimeLLC/RTProgressBar'
    spec.screenshots = ['https://raw.githubusercontent.com/RuntimeLLC/RTProgressBar/master/images/determinate.gif', 'https://raw.githubusercontent.com/RuntimeLLC/RTProgressBar/master/images/indeterminate.gif']
    spec.license = 'MIT'
    spec.author = { 'Daniyar Salakhutdinov' => 'bluesbastards@gmail.com' }
    
    spec.source = { :git => 'https://github.com/RuntimeLLC/RTProgressBar.git', :tag => "v#{spec.version}" }
    spec.source_files = 'src'
    spec.frameworks = 'QuartzCore', 'Cocoa'
    
    spec.platform = :osx, '10.9'
    spec.requires_arc = true
end
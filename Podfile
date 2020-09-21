platform :ios, '10.0'
use_modular_headers!

def shared_pods
    pod 'Alamofire', '~> 4.9.1'
    pod 'AlamofireImage'
    pod 'AlamofireNetworkActivityIndicator'
    pod 'Firebase/Auth'
    pod 'Firebase/Messaging'
    pod 'SwiftMaskTextfield', :git => 'https://github.com/Twfik/swift-mask-textfield.git'
    pod 'GooglePlaces'
    pod 'GoogleMaps'
end

def metrics
    pod 'AlamofireNetworkActivityLogger'
    pod 'Firebase/Analytics'
end


target 'FanPassport' do
    shared_pods
    metrics
end

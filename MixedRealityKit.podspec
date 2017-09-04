Pod::Spec.new do |s|
	s.name = 'MixedRealityKit'
	s.version = '0.1.7'
	s.summary = 'Easily add a stereoscopic ARKit SceneView to your project.'
	s.description = <<-DESC
The MixedRealityKit class extends ARSCNView and splits camera in two stereoscopic SceneViews. Works with Google Cardboard or any VR Viewer that supports non-barrel distorted VR.
		DESC

	s.homepage = 'https://github.com/scottfinkelstein/MixedRealityKit'
	s.license = { :type => 'MIT', :file => 'LICENSE' }
	s.author = { 'Scott Finkelstein' => 'sbf0202@gmail.com' }
	s.source = { :git => 'https://github.com/scottfinkelstein/MixedRealityKit.git', :tag => s.version.to_s }
	
	s.ios.deployment_target = '11.0'
	s.source_files = 'MixedRealityKit/Source/MixedRealityKit.swift'
	s.frameworks = 'Foundation', 'UIKit', 'SceneKit', 'ARKit'
	s.platform = :ios, '11.0'
end

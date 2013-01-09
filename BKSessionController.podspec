Pod::Spec.new do |s|
  s.name         = "BKSessionController"
  s.version      = "0.1.0"
  s.summary      = "BKSessionController deals with transfer over bluetooth using GameKit."
  s.description  = <<-DESC
  # BKSessionController

  Due to the limitation of GameKit, data larger than 87 Kb need to be split into smaller chunks in order to be sent to other devices. BKSessionController deals with such a large file transfer between devices. Data to be sent will be automatically split into smaller chunk than the GKSession object can afford to. BKSessionController consists of the following classes and protocols:

  * BKSessionController - A class controlling a GKSession object and data to be transferred.
  * BKChunkDataContainer - A data container for data to be transfered. Since this is a private helper class, you don't normally care about it. 
  * BKSessionControllerDelegate - A protocol controlling the behavior of a BKSessionController object.
                   DESC
  s.homepage     = "https://github.com/lixar/BKSessionController"
  s.license      = 'MIT'
  s.authors       = { "boreal-kiss.com" => "", "Sylvain Guillope" => "sguillope@lixar.com" }
  s.source       = { :git => "https://github.com/lixar/BKSessionController.git", :tag => s.version.to_s }
  s.platform     = :ios, '5.0'
  s.source_files = 'BKSessionController/Classes/BKChunkDataContainer', 'BKSessionController/Classes/BKSessionController', 'BKSessionController/Classes/BKSessionControllerDelegate'
  s.framework  = 'GameKit'
end

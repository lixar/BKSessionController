# BKSessionController

Due to the limitation of GameKit, data larger than 87 Kb need to be split into smaller chunks in order to be sent to other devices. BKSessionController deals with such a large file transfer between devices. Data to be sent will be automatically split into smaller chunk than the GKSession object can afford to. BKSessionController consists of the following classes and protocols:

* BKSessionController - A class controlling a GKSession object and data to be transferred.
* BKChunkDataContainer - A data container for data to be transfered. Since this is a private helper class, you don't normally care about it. 
* BKSessionControllerDelegate - A protocol controlling the behavior of a BKSessionController object.

# Related article

* [Game Kit Programming Guide](http://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/GameKit_Guide/)
* [GameKit Bluetooth Transfer Problem - Stack Overflow](http://stackoverflow.com/questions/2877523/gamekit-bluetooth-transfer-problem)

#License

This project is provided under the terms of the [MIT License](http://www.opensource.org/licenses/mit-license.php).

#Contact

* [http://blog.boreal-kiss.net/](http://blog.boreal-kiss.net/)
* [http://twitter.com/borealkiss](http://twitter.com/borealkiss)
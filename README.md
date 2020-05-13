# PureBasic - Raw Disk Access <!--<sup><sub><sup>Are you feeling that <b>pure</b> power now ?</sup></sub></sup>-->

This repository contains a couple of example and tests regarding raw disk access in Windows.

<b>Be mindful of what code you are compiling and running since some of the examples may corrupt data on your computer if you use them improperly !</b><br>
<b>If something breaks, it will be on you !</b>


## Preamble

Since all the code in this repository is accessing physical and virtual drives in a raw manner, I <b>strongly</b> recommend you either setup a Virtual Disk to play with or a VM to protect your data.
<!--[Since this is accessing raw drives, use a VM or virtual disk and check your code and add security checks.]
[A guide on how to setup a Vdisk is present in the guides folder/section]-->

And since all programs need raw access to the drives, they need to be ran with administrator rights.<br>
You will need to manually activate it in the compiler options in the PureBasic IDE.

<!--## Guides
Click [here]() to go to the guide section/readme.<!---->


## Examples

### [SimpleDiskRead.pb](SimpleDiskRead.pb)

This piece if code simply opens a drive and reads the first couple of pages using the standard PureBasic functions.<br>
Unless you are using a custom virtual disk or an unitialized drive, you should simply see a hexdump of the MBR in the debugger.

Under normal circumstances, your data <b><i>should</i></b> be safe when using this program since it is only reading, but you can never be too careful.

#### Remarks

In this example we are using the ```ReadFile()``` procedure provided by PureBasic itself instead of ```CreateFile_()``` from the WIN32 API.<br>

Opening the drive in this way only allows us to read data and not write it [NOT SURE !!!].

It also allows us to read data off of the drive without having to first copy said data into a buffer whose size is a multiple of the number of bytes per sector on the drive.<br>
This is probably caused by the [internal buffering](https://www.purebasic.com/documentation/file/readfile.html), but I'm not entirely sure.

<sub>TODO: check if writing with 512 size actually writes stuff to it.</sub>

<hr>

### [ComplexDiskRead.pb](ComplexDiskRead.pb)

This piece of code retrieves the disk size and geometry and then uses this information to open the physical drive and read one sector.

While this code <b><i>should</i></b> also be safe, you have to be more careful since the handle ```hDisk``` you get allows you to also write to the disk.


## Credits

● Lunasole<br>
&emsp;&emsp; ⚬ IOCTL related code and original idea/motivation.
&nbsp;([Thread](http://forums.purebasic.com/english/viewtopic.php?f=13&t=67490))<br>

● kinglestat<br>
&emsp;&emsp; ⚬ Original idea/motivation.
&nbsp;([Thread](https://www.purebasic.fr/english/viewtopic.php?f=12&t=75125))

## License

[Unlicense](LICENSE)

<b>The software is provided "As is", without warranty of any kind,
Express or implied, including but not limited to the warranties of
Merchantability, fitness for a particular purpose and noninfringement.<br>
In no event shall the authors be liable for any claim, damages or
Other liability, whether in an action of contract, tort or otherwise,
Arising from, out of or in connection with the software or the use or
Other dealings in the software.</b>

# PureBasic - Raw Disk Access <!--<sup><sub><sup>Are you feeling that <b>pure</b> power now ?</sup></sub></sup>-->

This repository contains a couple of example and tests regarding raw disk access in Windows.

<b>Be mindful of what code you are compiling and running since some of the examples may corrupt data on your computer if you use them improperly !</b><br>
<b>If something breaks, it will be on you !</b>


## Preamble

Since all the code in this repository is accessing physical and virtual drives in a raw manner, I <b>strongly</b> recommend you either setup a [Virtual Disk](https://docs.microsoft.com/en-us/windows-server/storage/disk-management/manage-virtual-hard-disks) to play with or a VM to protect your data.
<!--[Since this is accessing raw drives, use a VM or virtual disk and check your code and add security checks.]
[A guide on how to setup a Vdisk is present in the guides folder/section]-->

And since all programs need raw access to the drives, they need to be ran with administrator rights.<br>
You will need to manually activate it in the compiler options in the IDE.

<!--## Guides
Click [here]() to go to the guide section/readme.<!---->


## Examples

### ⮞ [SimpleDiskRead.pb](SimpleDiskRead.pb)

This piece of code simply opens a drive and reads the first couple of pages using the standard PureBasic procedures.<br>
Unless you are using a custom virtual disk or an unitialized drive, you should simply see a hexdump of the MBR in the debugger.

Under normal circumstances, your data <b><i>should</i></b> be safe when using this program since it is only reading, but you can never be too careful.

<details>
<summary>Remarks</summary>
  
In this example we are using the ```ReadFile()``` procedure provided by PureBasic instead of ```CreateFile_()``` from the WIN32 API.<br>

Opening the drive in this way only allows us to read data and not write it [NOT SURE !!!].

It also allows us to read data off of the drive without having to first copy said data into a buffer whose size is a multiple of the number of bytes per sector on the drive.<br>
This is probably caused by the [internal file buffering system](https://www.purebasic.com/documentation/file/readfile.html) in PureBasic, but I'm not entirely sure.

<sub>TODO: Check if writing a sector (512B) actually writes stuff to it even when using ```ReadFile()```.</sub>
</details>

<br>

### ⮞ [ComplexDiskRead.pb](ComplexDiskRead.pb)

This piece of code retrieves the disk's size and geometry and then uses this information to open the physical drive and to read one sector.

While this code <b><i>should</i></b> also be safe, you have to be more careful since the handle ```hDisk``` you get allows you to also write to the disk.<br>
This is due to the fact that, according to [Microsoft's documentation](https://support.microsoft.com/en-us/help/100027/info-direct-drive-access-under-win32), you have to open the drive with the shared read <b>and</b> shared write flags.


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
express or implied, including but not limited to the warranties of
merchantability, fitness for a particular purpose and noninfringement.<br>
In no event shall the authors be liable for any claim, damages or
other liability, whether in an action of contract, tort or otherwise,
arising from, out of or in connection with the software or the use or
other dealings in the software.</b>


# Star Trek : Deep Space Nine
Deep Space Nine is loved by many people.  Unfortunately, we will most likely never see a studio release of Deep Space Nine in HD.  I want to see it in something better than what is available.  Online streaming services have SD copies with flaws... it can be better.

After lots of research, I see this is a project that many people have started but never finished.  Its my goal to create a repository of scripts and tools that you can use to do this yourself.  


Special thanks for the folks over at doom9 -- 
Without the patience of Stereodude and bladerunner1982, this wouldn't be possible!

### **NOTE** : 
>You should be aware that this project is **not complete**.  There are lots of blank files that are used as place holders.  The files that do contain data may be partial or incorrect.  With the help of the commuity, hopefully we will be able to create a complete and accurate reference files for all seasons!  

## Feel like helping?
> Grab an existing set of files and test them out.  Make sure to give feedback with necessary changes if you find something wrong!
>
>Grab an episode, or two, or even a season and submit some OVR files!  



___
[TIVTC Official Documentation](https://github.com/pinterf/TIVTC/tree/master/Doc_TIVTC)
___
#### TFM OVR: [docs]( https://github.com/pinterf/TIVTC/blob/master/Doc_TIVTC/TFM%20-%20READ%20ME.txt)
>The following *codes* can be used in an OVR file to control actions that are taken on a frame.


#### Match Codes:
>*Match Codes force a frame, or range of frames, to be matched according to the code.*

|Code|Description                                  |
|------|-------------------------------------------|
|p     | Match to Previous Field                   | 
|c     | Match to Current Field                    |
|n     | Match to Next Field                       |
|b     | Match to previous field, Opposite Parity  |
|u     | Match to next field, Opposite parity      |



#### Combed Frame Codes:
>*Combed frames codes can be used to force actions on a frame, or range of frames.*

|Code|Description           |
|----|----------------------|
|+   | Force combed         |
|-   | Force **not** combed |

#### Paramter Codes
>*Parameter Codes can be used to adjust the parameters of a specific frame.  They require a value as well as the code to function.*

|Code|Description|
|----|-----------|
|f   | Field     |
|o   | Order     |
|m   | Mode      |
|M   | mThresh   |
|P   | PP        |
|i   | MI        |

___
#### TDecimate OVR: [docs](https://github.com/pinterf/TIVTC/blob/master/Doc_TIVTC/TDecimate%20-%20READ%20ME.txt)
>The following *codes* can be used in an OVR file to control actions that are taken on a frame.

|Ovrride|Description|Notes|
|-------|------------------------------|---------|
|v      | Specify frame(s) as **video* ||
|f      | Specify frame(s) as **film** |Hybrid muse be greater than 0|
|-      | Drop frame(s)               ||
|+      | placeholder for specifying patterns | +-++ skips every second frame in the specified range.|



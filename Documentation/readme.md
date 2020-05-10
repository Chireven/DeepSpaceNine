# The Problem:
There are a few problems that need to overcome.  This portion of the documentation is dedicate to dealing with the problem as well as providing a high level to solution to how the project intends to solve it.


## Why no HD?
Beleieve it or not, there was a time when quality wasn't our primary concearn.  The days of standard definition lasted for years, and it really wasn't until DVD exploded into mainstream that people started thinking about the Ps, Ks, and Is.

During this time, television shows were shot on Film.  Film is shot at 23.97 frames per second, but here in the United States, televion had adapted the NTSC standard which ran at 29.97 fps.

As you can see, this introduces the first problem -- framerates don't match.  The easy solution would be to speed up the film so that it ran at 29.97 fps, but the end result would make things run too fast and it would not look good.

To solve this problem, the telecining process was invented.  This allowed film to be translated to video frame rates by duplicating frames.  While not perfect, it got the job done.

When our beloved Deep Space Nine was created, it was shot on film.  However, it was common practice to lay down the special effects on video instead of the film.  Remember, we didn't really care about the quality back then as the resolution of our TVs were so poor, so this worked fine.

This is why we don't have, and most likely never will get an official HD version of Deep Space Nine.  I can't say for certain that the original 35mm film still exists, but I expect it does.  To produce an HD version, we'd have to go back to the film and re-create every single special effect.  This process was done for Original Trek as well as Next Gen.  While fans argue diffenretly, the studios claim that it wasn't worth the effort to do this.

## What Problems do We have to deal with
Our best source of media is DVD.  In order to get a good HD version, we need to start with this.

Each episode is made up of a mix of film and video -- the telecine.  In order to fix this, the project has chosen to use an Inverse Telecine function called TFM, which is part of the IVTC package for AVI Synth.  While this gets us close, it's not perfect and requires some manual intervention -- which is the main reason this project exists.  The OVR files identify and fix the frames that are missed or incorrectly processed by TFM.

The second problem that we have are all those duplicate frames that get created during the telecine.  The project has chosen TDecimate, anbother component of the TVTC package for AVISYnth, to remove these.  Aagain, this gets use really close but it's not perfect.  Some slow moving scenes can be incorrectly identified as duplicates and dropped by TDecimate.  The OVR files idnentify and fix the frames that are missed or incorrectly processed by TDecimate.

## Where do we go from here?
The following workflow has been created to process the video.  

First, you must own the original DVDs for this process.  You will not find any video, or links to video here.

### DVD Decrypter
While you might want to pull out something like MakeMKV to extract the video, please don't.  What you want is an exact copy of the VOB file from the DVD for each episode.  With DVD Decrypter, it is very easy to obtain this.

Start by opening the DVD Decrypter.  From the Mode menu, choose IFO.  Choose the DVD drive with the disc inserted and select the Stream Processing tab.  You'll see each episode here -- one at a time select the episode.  It's up to you if you want to leave the video, or enable stream processing and remove it.  Select a folder and click the button to extract the video.  You'll end up with a VOB file.

### DGMPGEnc
Now that we have a VOB file, we need to create a D2V project using DGMPEGEnc.  From an installation of this software, open the DGIndex.exe application.

Once the application is loaded, choose open from the file menu and choose your VOB file.  It's import to make sure that DGIndex will honor pulldown flags, which we need it to do because of the telecine.  To verify this option, open the Video menu and choose Field Operation > Honor Pulldown Flags.

At this point, save the D2V project using the File > Save Project menu.  Notice the film/video percentage -- it's not necessary to record it, just shows you why we need to process it this way instead of just using the vob.

### AVISynth
Everyone seems intimated with AVISynth, and rightly so.  It's a very powerfull program.  The good news -- you don't have to do much with it, and for people just starting out, know that you don't really have to interact with it directly.  You'll want to use something likve VirtualDub2 to interact with it.

You'll want to make sure you have all the required plugins installed in the plugins folders where you installed AviSynth.  I recommend Avisynth+ -- a fork and more updated version of Avisynth.

### VirtualDub 2
At this point, you're going to want to grab the scripts from the project for the episode that you're working with.  Open up the AVS script with VirtualDub 2.  You'll probably get an error, but thats ok for now.  This error is most likely because you need to update the variables in the script.

You'll want to modify the filenames for the following variables:

*d2vFile*
This variable should point directly to the d2v project file that you created.  If the d2v file is not in the same folder as the AVS script, you should specify the complete path.

*tfmOVR*
This variable points to the OVR file used for TFM.  It needs to exist, even if it's just an empty file. 

*decimateOVR*
This vairable points to the OVR file used for TDecimate.  It needs to exist, even if it's just an empty file.

Once you've populated the variables with the correct information, press F5.  It will save and reload the script.  You should now see a the video and can step through.

### How to use the script:
There are two TFM and TDecimate script lines -- one for testing and one for our final results.  

Start by commenting out both TDceimate statements, and the Production TFM.  You can comment a line out by putting a # sign at the beginning of the line.

You can now step through the film and find frames that need to be added to the OVR file to TFM.  The testing statement is special in that it won't actually remove the frames which will help you identify frames that may be incorrectly identified.  Any changes that you need to make can be added to the OVR files.  After adding frames to the OVR, just press F5 on the script window and it will reload everything.

Once you are happy with the TFM results, comment it out and uncomment the production statment.  You will also want to uncomment the testing TDecimate statement.

At this point you can step through the episode again.  With the production TFM enabled, the telecine will be removed.  You should now look for frames that are incorrectly identified as duplicates, such as very still scenes.

Once the OVR files are complete we can create a video from the AVS file using FFMPEG.  Since we're using DGMPEGenc, we'll need to make sure we use the x86 version.  The following command will produce an MKV file:

ffmpeg.exe -i (path to avs file) -map 0:v -c:v copy (ouput file.mkv)

At this point, we should have a file that we can send through whichever program we've chosen to do the upscale.
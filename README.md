# Co-Activity Detction from Multiple videos using Absorbing Markov Chain

This code is for the following paper.

<a href="http://cvlab.postech.ac.kr/research/coactivity/">Unsupervised Co-activity Detection from Multiple Videos using Absorbing Markov Chain,</a><br>
Donghun Yeo, Bohyung Han, JoonHee Han, AAAI'16

# Step 1 - Feature Extraction
To run this git code, you should use following feature extraction code.<br>
Download: <a href="http://cvlab.postech.ac.kr/research/coactivity/yeo-han.pdf">Feature extraction link</a>

# Step 2 - Initial Settings
## Input videos
  1. Make a directory as _<input_root>/<folder_name>/_ <br>
  2. Put the videos in this directory. (I recommend you to use .avi file. If you want different type you should change code in "Initialization/UT_make_gt.m".)
  3. Please note that the vidoes are ordered by their name.
  4. Put ground-truth information _<input_root>/<folder_name>/folder_name_GT.txt_ <br>
  Here is an example of _Gt.txt_ file.
<pre><code>
1 1 470
2 1 750
3 198 500
3 681 1281
</code></pre>
  Each line consists of 1) video number, 2) the start frame and 3) the end frame of the co-activity in the video.<br>
  For some videos which have multiple instances of the co-activity, you should put the information about each instance in each line like the last two lines of the example.


Run UT_Initial_Step.m <br>

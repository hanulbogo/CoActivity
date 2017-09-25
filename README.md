# Co-Activity Detction from Multiple videos using Absorbing Markov Chain

This code is for the following paper.

- <a href="http://cvlab.postech.ac.kr/research/coactivity/">Unsupervised Co-activity Detection from Multiple Videos using Absorbing Markov Chain,</a><br>
Donghun Yeo, Bohyung Han, JoonHee Han, AAAI'16

# Step 1 - Prepare input videos and ground truth file
  1. Make a directory as _<input_root>/<folder_name>/_ <br>
  2. Put the videos in this directory. (I recommend you to use .avi file. If you want different type you should change code in "Initialization/UT_make_gt.m".)
  3. Please note that the vidoes are ordered by their name.
  4. Put ground-truth information _<input_root>/<folder_name>/folder_name_GT.txt_ <br>
  Here is an example of _GT.txt_ file.
<pre><code>
1 1 470
2 1 750
3 198 500
3 681 1281
</code></pre>
  - Each line consists of 1) video number, 2) the start frame and 3) the end frame of the co-activity in the video.<br>
  - For some videos which have multiple instances of the co-activity, you should put the information about each instance in each line like the last two lines of the example.

  5. The original videos used in the experiments of the paper is in the following link
  - Download: <a href="https://drive.google.com/open?id=0B89l1vetFfpqYzZqR3RXZ09jeDg">YouTube co-activity dataset</a> </li>

# Step 2 - Feature Extraction
To run this git code, you should use following feature extraction code.<br>
- Download: <a href="http://cvlab.postech.ac.kr/research/coactivity/yeo-han.pdf">Feature extraction link</a>
  1. Edit and run _CoActDiscovery_Feature_Extraction_Youtube.m_ with your own input video path _<input_root>_.
  2. Run the ".bat" files, the output of running _CoActDiscovery_Feature_Extraction_Youtube.m_., to get the features.

# Step 3 - Run UT_Initial_Step.m
This code translate information about input, ground truth and the extracted features into _".mat"_ files.<br>
Edit and run this code with your own directories.

# Step 4 - Run UT_RUN_THIS.m
This code returns the co-activity frames of the input videos and precision, recall and F-measure.
Edit and run this code with your own directories.

# Co-Activity Detction from Multiple videos using Absorbing Markov Chain

This code is for the following paper.

<a href="http://cvlab.postech.ac.kr/research/coactivity/">Unsupervised Co-activity Detection from Multiple Videos using Absorbing Markov Chain,</a><br>
Donghun Yeo, Bohyung Han, JoonHee Han, AAAI'16

# Step 1 - Feature Extraction
To run this git code, you should use following feature extraction code.<br>
Download: <a href="http://cvlab.postech.ac.kr/research/coactivity/yeo-han.pdf">Feature extraction link</a>

# Step 2 - Initial Settings
## Input videos
  Make a directory as <input_root>/<folder_name>/ <br>
  Put ground-truth information <input_root>/<folder_name>/folder_name_GT.txt <br>
<pre><code>
1 1 470
2 1 750
3 198 500
3 681 1281
</code></pre>
  
  
You need a videos and the ground truth information 
ground-truth.txt file in each 

Run UT_Initial_Step.m <br>

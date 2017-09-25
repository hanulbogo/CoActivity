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
<code>
1 1 470//
2 1 750<br>
3 681 1281<br>
4 198 500<br>
5 1 825<br>
6 250 1500<br>
7 127 375<br>
8 740 2154<br>
9 294 803<br>
10 151 459<br>
11 521 1520<br>
11 1856 2790<br>
12 1 320<br>
12 377 430<br>
12 1317 2280<br>
13 871 1200<br>
13 1500 1991<br>
</code>  
  
  
You need a videos and the ground truth information 
ground-truth.txt file in each 

Run UT_Initial_Step.m <br>

# **EE4C03 Adaptive ECG Noice Cancellation**
**Time: 05-11-2021**  
**Student: Xuan Gao. Milla Rahmadiva**  
All our simulations are tested on **MATLAB R2021b**
## **How To Verify Our Work**
Please follow the steps below.  
## **Step 1**  
 Install the following Add-on on MATLAB: `DSP System Toolbox`, `Signal Processing Toolbox`.  
## **Step 2**

```
git clone https://github.com/xuangao6/EE4C03_ADAPTIVE_ECG_NOISE_CANCELLATION/tree/master
```
There are 1 instance for the data `ECG_database.mat` and 5 instances for MATLAB codes in which `ee4c03_main.m` is the main file for our project.

For the main file, open `ee4c03_main.m` located at `.\EE4C03_ADAPTIVE_NOISE_CANCELLATION\ee4c03_main.m`.

For LMS algorithm, open `LMS.m` located at `.\EE4C03_ADAPTIVE_NOISE_CANCELLATION\LMS.m`.    

For NLMS algorithm, open `LMS.m` located at `.\EE4C03_ADAPTIVE_NOISE_CANCELLATION\NLMS.m`.

For RLS algorithm, open `LMS.m` located at `.\EE4C03_ADAPTIVE_NOISE_CANCELLATION\RLS.m`.

For PSD algorithm, open `LMS.m` located at `.\EE4C03_ADAPTIVE_NOISE_CANCELLATION\PSD.m`.

## **Step 3**
Run `ee4c03_main.m`, then you will get the same results as the figures located at `.\EE4C03_ADAPTIVE_NOISE_CANCELLATION\figures`.  

Make sure that all 6 files (ECG_database.mat and 5 MATLAB files) are in the same folder.

## **References**
Our referenced papers are located at `.\EE4C03_ADAPTIVE_NOISE_CANCELLATION\papers`.  

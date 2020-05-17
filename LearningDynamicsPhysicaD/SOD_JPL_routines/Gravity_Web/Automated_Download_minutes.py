"""
Script for downloading minute data, it needs to run for a long period of time to get the desired data. 
We will try for 400 years, done in 100 year batches then uploaded to the server. 
"""

planetdict = {1:'Mercury', 2:'Venus', 301:'Moon', 399:'Earth2' ,3:'Earth', 4:'Mars', 5: 'Jupiter', 6:'Saturn', \
              7:'Uranus', 8:'Neptune', 10:'Sun'}
#CHANGE THIS HERE. 
codedir = "C:\\Users\\Jason\\Desktop\\MaggioniWork\\Learning-Dynamics\\Code\\LearningDynamics_v2.1.1\\Gravity_Web\\"
savedir = "D:\\DataAnalyses\\TrajectoriesMins1900-1999\\"
savedir2 = "D:\\DataAnalyses\\Trajectories2Mins1900-1999\\"
#END OF DIRECTORY Changes
import os as os
os.chdir(codedir)  
import Helpers as H
import requests  #Web scraping.
import urllib.request as ur
import time
from bs4 import BeautifulSoup

#Download the remainder of the hourly data. 
start_date = "1900-01-01 00:00"
end_date = "1999-12-31 23:59" 
interval = "minutes"
start_dates, end_dates = H.splitTime(start_date, end_date, interval)
"""
#Go planet by planet, year range at a time, this failed a few times because the server kicked me, but if you wait a few minutes, then rerun it will keep giving you data. 
for j in planetdict.keys():
    for i in range(len(start_dates)):
        downloadstring = H.assembleString(j,start_dates[i], end_dates[i],interval)
        savestring = savedir + str(planetdict.get(j)) +  "_" + str(i) +  \
            "_"+start_dates[i].split(':')[0]+"-" + start_dates[i].split(':')[1]  + "_to_"  \
            + end_dates[i].split(':')[0] + "-"+ end_dates[i].split(':')[1] + ".csv"  #Set the file savestring, everything before colon.       
        if not os.path.exists(savestring): #Check if we have already downloaded the file. 
            print(savestring)
            ur.urlretrieve(downloadstring, savestring)
            time.sleep(15)  #Pause for a moment to try not to annoy the server, waiting 15 seconds, could make much longer if desired. 
"""
#Robust method to run for long periods of time without having to check back (hopefully)
d = 1
while d < len(start_dates)*len(planetdict.keys()):  #Keep iterating until we have gone through all the planets for all the dates
    d = 1
    try:
        for j in planetdict.keys():
            for i in range(len(start_dates)):
                downloadstring = H.assembleString(j,start_dates[i], end_dates[i],interval)
                savestring = savedir + str(planetdict.get(j)) +  "_" + str(i) +  \
                    "_"+start_dates[i].split(':')[0]+"-" + start_dates[i].split(':')[1]  + "_to_"  \
                    + end_dates[i].split(':')[0] + "-"+ end_dates[i].split(':')[1] + ".csv"  #Set the file savestring, everything before colon.       
                if not os.path.exists(savestring): #Check if we have already downloaded the file. 
                    print(savestring)
                    ur.urlretrieve(downloadstring, savestring)
                    time.sleep(15) 
                d = d+1 #Increment the global counter after running for that file if needed
    except:   #When we hit a network connection error, we take a longer break, but do not increment d, because that file failed. 
        time.sleep(560)
print("All data has been downloaded in the desired ranges for all bodies in planetdict.")

#Now change the extension to .csv, only run this when needed. 
#files = os.listdir(savedir)
#for file in files:
#    if not os.path.exists(savedir+file + '.csv'): 
#        testss = savedir + file
#        os.rename(savedir+file, testss[:-4])
    

#First we create a duplicate set of files that just has the raw data, no headings etc. this maintains the original files, and enables easy combination
#Could be more memory efficient
#PRIMARY.
csvfiles = H.find_csv_filenames(savedir) 
for j in planetdict.keys():
    planetfiles = [filename for filename in csvfiles if planetdict.get(j) == filename.split("_")[0]]  #Check for just the filenames related to the particular planet.
    for f in planetfiles: 
        with open(savedir + f) as f_in:
            with open(savedir2 + f, 'w') as f_out:
                #if not os.path.exists(savedir2 + f):  #If this has already been run, no need to rerun it. 
                starter = False
                stop = False
                for line in f_in:
                    if "$$SOE" in line:
                        starter = True
                        continue #skip any further calculation and move on to the next line
                    #output= line.rstrip('\n') #city = line.rstrip('\n')
                    if "$$EOE" in line:
                        stop = True
                    if stop:  #Check if we have hit the end of the file, if so break out                      
                        break
                    if starter:
                        f_out.write(line) #Going forward, write the full line. 

#SECONDARY.
##Ad hoc for parsing specific planet files if needed.
csvfiles = H.find_csv_filenames(savedir) 
for j in planetdict.keys():
    planetfiles = [filename for filename in csvfiles if planetdict.get(j) == filename.split("_")[0] and planetdict.get(j) in ["Mars"]]# and planetdict.get(j) in ["Earth2", "Moon"] ]  #Check for just the filenames related to the particular planet.
    for f in planetfiles: 
        with open(savedir + f) as f_in:
            with open(savedir2 + f, 'w') as f_out:
                #if not os.path.exists(savedir2 + f):  #If this has already been run, no need to rerun it. 
                starter = False
                stop = False
                for line in f_in:
                    if "$$SOE" in line:
                        starter = True
                        continue #skip any further calculation and move on to the next line
                    #output= line.rstrip('\n') #city = line.rstrip('\n')
                    if "$$EOE" in line:
                        stop = True
                    if stop:  #Check if we have hit the end of the file, if so break out                      
                        break
                    if starter:
                        f_out.write(line)


#Now we combine each of the .csv files in the new directory in a simple way BUT we need to monitor the ordering.
import os
import glob
import pandas as pd
csvfiles = H.find_csv_filenames(savedir2)  #Get all csv files in the new directory with the truncated files. 
for j in planetdict.keys():
    #if not os.path.exists(savedir2 + planetdict.get(j)+"_"+start_dates[i].split(':')[0] + \
    #                    "_to_" + end_dates[i].split(':')[0] + ".csv"):
    planetfiles = [filename for filename in csvfiles if planetdict.get(j) == filename.split("_")[0]]
    planetfiles2= []
    for k in range(0,len(planetfiles)):
        filestring = planetdict.get(j) + "_"+ str(k) + "_"
        kthfile = [filename for filename in planetfiles if filestring in filename] #Extract the correct file IN ORDER, don't trust the default ordering                        
        kthfile = kthfile[0]  #Extract the string
        planetfiles2.append(savedir2 + kthfile)        #Add the appropriate file with the full path
    combined_csv = pd.concat([pd.read_csv(f, header = None) for f in planetfiles2 ])  #Iterate through the properly sorted list of files.
    combined_csv.to_csv(savedir2 + planetdict.get(j)+"_"+start_date.split(':')[0] + \
                        "_to_" + end_date.split(':')[0] + ".csv",index=False,header = False, encoding='utf-8-sig')  #Save this as one giant csv
    del combined_csv  #Clear the variable for the next planet


##SECONDARY  
import os
import glob
import pandas as pd
csvfiles = H.find_csv_filenames(savedir2)  #Get all csv files in the new directory with the truncated files. 
for j in planetdict.keys():
    #if not os.path.exists(savedir2 + planetdict.get(j)+"_"+start_dates[i].split(':')[0] + \
    #                    "_to_" + end_dates[i].split(':')[0] + ".csv"):
    planetfiles = [filename for filename in csvfiles if planetdict.get(j) == filename.split("_")[0] and planetdict.get(j) in ["Mars"]]
    if len(planetfiles) == 0:
        continue
    planetfiles2= []
    for k in range(0,len(planetfiles)):
        filestring = planetdict.get(j) + "_"+ str(k) + "_"
        kthfile = [filename for filename in planetfiles if filestring in filename] #Extract the correct file IN ORDER, don't trust the default ordering                        
        kthfile = kthfile[0]  #Extract the string
        planetfiles2.append(savedir2 + kthfile)        #Add the appropriate file with the full path
    combined_csv = pd.concat([pd.read_csv(f, header = None) for f in planetfiles2 ])  #Iterate through the properly sorted list of files.
    combined_csv.to_csv(savedir2 + planetdict.get(j)+"_"+start_date.split(':')[0] + \
                        "_to_" + end_date.split(':')[0] + ".csv",index=False,header = False, encoding='utf-8-sig')  #Save this as one giant csv
    del combined_csv  #Clear the variable for the next planet


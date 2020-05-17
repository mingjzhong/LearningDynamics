"""
A script to automate the download of files from JPL horizons online system using links.
"""
planetdict = {1:'Mercury', 2:'Venus', 3:'Earth', 4:'Mars', 5: 'Jupiter', 6:'Saturn', \
              7:'Uranus', 8:'Neptune', 10:'Sun'}
#CHANGE THIS HERE. 
codedir = "C:\\Users\\Jason\\Desktop\\MaggioniWork\\Learning-Dynamics\\Code\\LearningDynamics_v2.1.1\\Gravity_Web\\"
savedir = "D:\\DataAnalyses\\Trajectories\\"
savedir2 = "D:\\DataAnalyses\\Trajectories2\\"
#END OF DIRECTORY Changes

import os as os
os.chdir(codedir)  
import Helpers as H


testLink = H.assembleString(4, "1748-01-01 00:00","1749-12-31 23:00", "hours")

#Web scraping.
import requests
import urllib.request as ur
import time
from bs4 import BeautifulSoup


#Download the remainder of the hourly data. 
start_date = "1766-01-01 00:00"
end_date = "1999-12-31 23:00"
interval = "hours"
start_dates, end_dates = H.splitTime(start_date, end_date, interval)
#Go planet by planet, year range at a time, this failed a few times because the server kicked me, but if you wait a few minutes, then rerun it will keep giving you data. 
for j in planetdict.keys():
    for i in range(len(start_dates)):
        downloadstring = H.assembleString(j,start_dates[i], end_dates[i],interval)
        savestring = savedir + str(planetdict.get(j)) +  "_" + str(i) +  \
            "_"+start_dates[i].split(':')[0] + "_to_" + end_dates[i].split(':')[0]+".csv"  #Set the file savestring, everything before colon.       
        if not os.path.exists(savestring): #Check if we have already downloaded the file. 
            print(savestring)
            ur.urlretrieve(downloadstring, savestring)
            time.sleep(3)  #Pause for a moment to try not to annoy the server, waiting 3 seconds, could make much longer if desired. 
    

#Now change the extension to .csv, only run this when needed. 
#files = os.listdir(savedir)
#for file in files:
#    if not os.path.exists(savedir+file + '.csv'): 
#        testss = savedir + file
#        os.rename(savedir+file, testss[:-4])
    

#First we create a duplicate set of files that just has the raw data, no headings etc. this maintains the original files, and enables easy combination
#Could be more memory efficient
csvfiles = find_csv_filenames(savedir) 
for j in planetdict.keys():
    planetfiles = [filename for filename in csvfiles if planetdict.get(j) in filename]
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

#Now we combine each of the .csv files in the new directory in a simple way BUT we need to monitor the ordering.
import os
import glob
import pandas as pd
csvfiles = find_csv_filenames(savedir2)  #Get all csv files in the new directory with the truncated files. 
for j in planetdict.keys():
    #if not os.path.exists(savedir2 + planetdict.get(j)+"_"+start_dates[i].split(':')[0] + \
    #                    "_to_" + end_dates[i].split(':')[0] + ".csv"):
    planetfiles = [filename for filename in csvfiles if planetdict.get(j) in filename]
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


"""
Use the below section for handling specific files, it is highly redundant with the above. 
"""

##Special section to handle specific files: substitute in the code and name in the planetdictspecial object and the run this block to download

planetdictspecial = {301:'Moon'}   #301 is the code for the moon in JPL Horizons.
planetdictspecial = {399:'Earth2'}
start_date = "1766-01-01 00:00"
end_date = "1999-12-31 23:00"
interval = "hours"
start_dates, end_dates = H.splitTime(start_date, end_date, interval)
#Go planet by planet, year range at a time, this failed a few times because the server kicked me, but if you wait a few minutes, then rerun it will keep giving you data. 
for j in planetdictspecial.keys():
    for i in range(len(start_dates)):
        downloadstring = H.assembleString(j,start_dates[i], end_dates[i],interval)
        savestring = savedir + str(planetdictspecial.get(j)) +  "_" + str(i) +  \
            "_"+start_dates[i].split(':')[0] + "_to_" + end_dates[i].split(':')[0]+".csv"  #Set the file savestring, everything before colon.       
        if not os.path.exists(savestring): #Check if we have already downloaded the file. 
            print(savestring)
            ur.urlretrieve(downloadstring, savestring)
            time.sleep(15)  #Pause for a moment to try not to annoy the server, waiting 10 seconds, could make much longer if desired. 
#Now strip the files. 
csvfiles = find_csv_filenames(savedir) 
for j in planetdictspecial.keys():
    planetfiles = [filename for filename in csvfiles if planetdictspecial.get(j) in filename]
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
import os
import glob
import pandas as pd
csvfiles = find_csv_filenames(savedir2)  #Get all csv files in the new directory with the truncated files. 
for j in planetdictspecial.keys():
    #if not os.path.exists(savedir2 + planetdict.get(j)+"_"+start_dates[i].split(':')[0] + \
    #                    "_to_" + end_dates[i].split(':')[0] + ".csv"):
    planetfiles = [filename for filename in csvfiles if planetdictspecial.get(j) in filename]
    planetfiles2= []
    for k in range(0,len(planetfiles)):
        filestring = planetdictspecial.get(j) + "_"+ str(k) + "_"
        kthfile = [filename for filename in planetfiles if filestring in filename] #Extract the correct file IN ORDER, don't trust the default ordering                        
        kthfile = kthfile[0]  #Extract the string
        planetfiles2.append(savedir2 + kthfile)        #Add the appropriate file with the full path
    combined_csv = pd.concat([pd.read_csv(f, header = None) for f in planetfiles2 ])  #Iterate through the properly sorted list of files.
    combined_csv.to_csv(savedir2 + planetdictspecial.get(j)+"_"+start_date.split(':')[0] + \
                        "_to_" + end_date.split(':')[0] + ".csv",index=False,header = False, encoding='utf-8-sig')  #Save this as one giant csv
    del combined_csv     
 
    
    
    
    
    
# -*- coding: utf-8 -*-
"""
Helper Functions for the automated download. 
"""

#planetdict = {1:'Mercury', 2:'Venus', 3:'Earth', 4:'Mars', 5: 'Jupiter', 6:'Saturn', \
#              7:'Uranus', 8:'Neptune', 10:'Sun'}

website = "https://ssd.jpl.nasa.gov/horizons_batch.cgi?batch=1&"
finalpart = "OUT_UNITS= %27AU-D%27& \
REF_PLANE= %27ECLIPTIC%27& \
REF_SYSTEM= %27J2000%27& \
VECT_CORR= %27NONE%27& \
VEC_LABELS= %27YES%27& \
VEC_DELTA_T= %27NO%27& \
CSV_FORMAT= %27YES%27& OBJ_DATA= %27YES%27& VEC_TABLE= %272%27"

def commandString(planet):
    try:
        val = int(planet)
        comSt = "COMMAND= %27" + str(planet) + "%27&CENTER= %27500@0%27&MAKE_EPHEM= %27YES%27& \
                        TABLE_TYPE= %27VECTORS%27&"
    except ValueError:
        print("That's not an int!")
    return comSt
def stepString(interval):
    if interval == "hours":
        s = "STEP_SIZE= %271 h%27&"
        return s 
    elif interval == "minutes":
        s= "STEP_SIZE= %271 m%27&"
        return s 
    elif interval == "days":
        s = "STEP_SIZE= %271 d%27&"
        return s 
    else:
        print("Unsupported interval!")
def dateString(start_time, end_time):
    """
    Assemble the date string. Coming in the form: #START_TIME= %271749-12-31 00:00%27&STOP_TIME= %271749-12-31 23:00%27&
    """
    ds = "START_TIME= %27" + start_time +"%27&" + "STOP_TIME= %27" + end_time + "%27&"
    return ds
def assembleString(planet, start_time, end_time, interval):
    """
    This method is called iteratively, the only variable parameters in a given call are the planet, and 
    the start and end time that we need trajectory data from. 
    """
    finals = website + commandString(planet) + dateString(start_time, end_time) + stepString(interval) + finalpart
    return finals

    
def splitTime(start_date, end_date, interval):  #Takes as format 2012-09-22 23:00 for the date time object. 
    """
    A function to take in two dates in 2012-09-22 23:00 format and output two lists, one with start dates in that format 
    and the second with end dates in that format. You then iterate through these two lists and get the different dates 
    for extraction from the web. 
    start_date = '1600-01-01 00:00'
    end_date = '2000-12-31 23:00'
    interval = 'hours', 'days', 'minutes' are the 3 options
    """
    from datetime import datetime, timedelta
    from dateutil import relativedelta
    dto1 = datetime.strptime(start_date, '%Y-%m-%d %H:%M')
    dto2 = datetime.strptime(end_date, '%Y-%m-%d %H:%M')
    start_dates = []
    end_dates = []
    increment = 85000  #Chosen to be a value smaller than the 90024 line max that the Horizon system enforces. 
    if interval == "hours":
        start_dates.append(start_date)
        dt0 = dto1
        while dt0 < dto2:
            dt0 = dto1 + timedelta(hours = 85000)
            dt00 = dt0.strftime("%Y-%m-%d %H:%M")
            end_dates.append(dt00)
            dto1 = dt0 + timedelta(hours = 1)
            dt01 =  dto1.strftime("%Y-%m-%d %H:%M")
            start_dates.append(dt01)
        del start_dates[-1]
        del end_dates[-1]
        end_dates.append(dto2.strftime("%Y-%m-%d %H:%M"))
    elif interval == "minutes":
        start_dates.append(start_date)
        dt0 = dto1
        while dt0 < dto2:
            dt0 = dto1 + timedelta(minutes = 85000)
            dt00 = dt0.strftime("%Y-%m-%d %H:%M")
            end_dates.append(dt00)
            dto1 = dt0 + timedelta(minutes = 1)
            dt01 =  dto1.strftime("%Y-%m-%d %H:%M")
            start_dates.append(dt01)
        del start_dates[-1]
        del end_dates[-1]
        end_dates.append(dto2.strftime("%Y-%m-%d %H:%M"))
    elif interval == "days":
        start_dates.append(start_date)
        dt0 = dto1
        while dt0 < dto2:
            dt0 = dto1 + timedelta(days = 85000)
            dt00 = dt0.strftime("%Y-%m-%d %H:%M")
            end_dates.append(dt00)
            dto1 = dt0 + timedelta(days = 1)
            dt01 =  dto1.strftime("%Y-%m-%d %H:%M")
            start_dates.append(dt01)
        del start_dates[-1]
        del end_dates[-1]
        end_dates.append(dto2.strftime("%Y-%m-%d %H:%M"))
    else:
        print("Unsupported time interval, please choose from days, hours, minutes.")
    return start_dates, end_dates

def find_csv_filenames( path_to_dir, suffix=".csv" ):
    import os as os
    filenames = os.listdir(path_to_dir)
    return [ filename for filename in filenames if filename.endswith( suffix ) ]


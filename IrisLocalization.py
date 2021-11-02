#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Oct 28 22:02:10 2021

@author: yiyang
"""


import cv2
import numpy as np
import math
import matplotlib.pyplot as plt


def IrisLocalization(images,c1,c2,h1,h2,threshold):
    centers=[] 
    #threshold = 63
    for img in images:
        img_grey = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
        img = img_grey.copy()
        img = cv2.bilateralFilter(img, 9,75,75)
        
        ret,img_binary = cv2.threshold(img,threshold,255,cv2.THRESH_BINARY)
        center_x = np.mean(img_binary,0).argmin()
        center_y = np.mean(img_binary,1).argmin()
        
        for i in range(2):
            img120 = img[center_y-60:center_y+60,center_x-60:center_x+60]
            ret,img120_binary = cv2.threshold(img120,threshold,255,cv2.THRESH_BINARY)
            center_x_120 = np.mean(img120_binary,0).argmin()
            center_y_120 = np.mean(img120_binary,1).argmin()
            center_x = center_x - 60 + center_x_120
            center_y = center_y - 60 + center_y_120
           
    
        edged = cv2.Canny(img120, c1, c2)
        circles = cv2.HoughCircles(edged, cv2.HOUGH_GRADIENT, h1, h2)
        
        
        k = []
        error = float("inf")
        for j in circles[0]:
            distance = math.sqrt((j[1] - center_x_120) ** 2 + (j[0] - center_y_120) ** 2)
            if distance <= error:
                error = distance
                k = j
        
        center_x_hough = center_x - 60 + int(k[0])
        center_y_hough = center_y - 60 + int(k[1])
        radius = int(k[2])
        
        
        #a=cv2.circle(img, (center_x_hough, center_y_hough), radius, (255, 0, 0), 1)
        #a=cv2.circle(img, (center_x, center_y), radius, (255, 0, 0), 1)

        #plt.imshow(a, cmap="gray")
        #plt.show()
        centers.append([center_x_hough,center_y_hough,radius])
    return centers

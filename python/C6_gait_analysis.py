'''
Calculation of 3-D knee orientation from IMU-data of upper- and lower-leg.

'''
# author: Thomas Haslwanter, date:   Jan-2018, Ver:    1.1

# Import standard packages
import numpy as np
import matplotlib.pyplot as plt
import os

# Import skinematics
from skinematics.sensors.xsens import XSens
from skinematics.quat import Quaternion

# Get the data
data_dir = r'D:\Users\thomas\Coding\Python\scikit-kinematics\skinematics\tests\data'
infile_ll = os.path.join(data_dir, 'walking_xsens_lowerLeg.txt')
infile_ul = os.path.join(data_dir, 'walking_xsens_upperLeg.txt')

# Provide the approximate initial orientation of the IMUs
initial_orientation = np.array([[0,0,-1], [1, 0, 0], [0,-1,0]]).T

sensor_ul = XSens(infile_ul, R_init=initial_orientation)
sensor_ll = XSens(infile_ll, R_init=initial_orientation)

# Convert the orientation to quaternions
q_upperLeg = Quaternion(sensor_ul.quat)
q_lowerLeg = Quaternion(sensor_ll.quat)

'''
Calculate the 3-D knee orientation, using "Quaternion" objects
Using the two rules for combined rotations
    * From right to left 
    * From the inside out
we get that the orientation of the 
    lower_leg = upper_leg * knee
Bringing the "upper_leg" to the other side, we have
    knee = inv(upper_leg) * lower_leg
'''
knee = q_upperLeg.inv() * q_lowerLeg


# Show the results
time = np.arange(len(knee)) / sensor_ul.rate
plt.plot(time, knee.values[:,1:])
plt.title('Thomas Walking')
plt.xlabel('Time [sec]')
plt.ylabel('Knee Orientation [quat]')
plt.legend(['x', 'y', 'z'])
plt.show()

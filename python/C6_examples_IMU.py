"""Example for working with data from an IMU """

# author: Thomas Haslwanter, date: Oct-2018

import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

from skinematics.sensors.xsens import XSens


# Read in the recorded data. Here a file from an XSens-system:
data_file = r'data_xsens.txt'

# The easiest way to specify the approximate orientation is by indicating
# the approximate direction the$(x,y,z)$axes of the IMU are pointing at:
x = [1, 0, 0]
y = [0, 0, 1]
z = [0,-1, 0]
initial_orientation = np.column_stack((x,y,z))

initial_position = np.r_[0,0,0]
orientation_calculation = 'analytical' # Method for orientation calculation

# Reading in the data, and initializing the ``Sensor'' object. In this step also
# the orientation is calculated.
# To read in data from a different sensor, the corresponding class has to be
# imported from skinematics.sensors.
my_imu = XSens(in_file=data_file, q_type=orientation_calculation,
               R_init=initial_orientation, pos_init=initial_position)

# Example 1: extract the raw gyroscope data

gyr = my_imu.omega
time = np.arange(my_imu.totalSamples)/my_imu.rate

# Set the graphics parameters
sns.set_context('poster')
sns.set_style('ticks')

# Plot it in the left figure
fig, axs = plt.subplots(1,2, figsize=[18,8])
lines = axs[0].plot(time, gyr)
axs[0].set(title='XSens-data',
           xlabel='Time [s]',
           ylabel = 'Angular Velocity [rad/s]')
axs[0].legend(lines, ('x', 'y', 'z'))

# Example 2: extract the vector from the orientation quaternion,
#            which was calculated using an analytical procedure

q_simple = my_imu.quat[:,1:]

# Plot it in the right figure
lines = axs[1].plot(time, q_simple, label='analytical_')
axs[1].set(title='3D orientation',
           xlabel='Time [s]',
           ylabel = 'Quaternions')

# Example 3: calculate the orientation, using an extended Kalman filter
# Note that the orientation is automatically re-calculated when the
# "q_type" of the Sensor object is changed!

my_imu.set_qtype('kalman')  # executes the Kalman-filter
q_Kalman = my_imu.quat[:,1:]

# Superpose the lines on the right figure
lines.extend(axs[1].plot(time, q_Kalman,'--',  label='kalman_'))

# Add the direction-info to each line label
dirs = ['x', 'y', 'z']
for ii, line in enumerate(lines):
    line.set_label(line.get_label() + dirs[ii%3])
    
plt.legend(loc='upper right')

# Save the figure
out_file = 'orientations.png'
plt.savefig(out_file, dpi=200)
print('Image saved to {0}'.format(out_file))

plt.show()

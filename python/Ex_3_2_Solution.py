""" Exercise 3.1: Calculate the trajectory of an observed particle, when
location and orientation of the observer are changing.
The velocities correspond to particle velocities in a central potential.

"""

# Author: Thomas Haslwanter, Date: Nov-2017

import os
from scipy import signal
import skinematics as skin
import numpy as np
import matplotlib.pyplot as plt

def rotate_and_shift(shift=[0,0,0], rotation=0):
    """Get data, and rotate and shift the camera location
    
    Parameters
    ----------
    shift : ndarray, shape (3,)
        Camera translation [Same units as position recordings]
    rotation : float
        Camera rotation [deg]
    """

    # Get the data
    inFile = 'planet_trajectory_2d.txt'
    data = np.loadtxt(inFile)
    
    # Calculate the 3D trajectory
    zData = -data[:,1]*np.tan(30*np.pi/180.)
    data3D = np.column_stack( (data,zData) )
    data3D[:,2] -= 200
    
    # Calculate and plot the 3-D velocity
    vel3D = signal.savgol_filter(data3D, window_length=61, polyorder=3, deriv=1, delta=0.1, axis=0)

    # Show the data
    plt.plot(vel3D[:,0], vel3D[:,1])
    plt.axis('equal')
    plt.title('x/y Velocity')
    plt.xlabel('x')
    plt.ylabel('y')
    plt.show()
    
    # Just to show how to elegantly create 3 subplots
    fig, axs = plt.subplots(3,1, sharex=True)
    for ii in range(3):
        axs[ii].plot(vel3D[:,ii])
        axs[ii].set_ylabel('axis_{0}'.format(ii))
    axs[ii].set_xlabel('Time [pts]')
    axs[0].set_title('Velocities')
    plt.show()
    
    # Shift the location of the camera, using the numpy feature of
    # "broadcasting" to subtract a 3-vector from an Nx3-matrix.
    data_shifted = data3D - np.array(shift)
    
    # Rotate the orientation of the camera
    data_shiftRot = (skin.rotmat.R(0, rotation) @ data_shifted.T).T
    
    # Plot the shifted and rotated trajectory
    outFile = 'shifted_rotated.png'

    plt.plot(data_shiftRot[:,0], data_shiftRot[:,1])
    plt.axhline(0, linestyle='dotted')
    plt.axvline(0, linestyle='dotted')
    plt.xlabel('x')
    plt.ylabel('y')
    plt.title('Shifted & Rotated')

    plt.savefig(outFile, dpi=200)
    print('Data saved to {0}'.format(outFile))
    plt.show()    
    
if __name__=='__main__':
    rotate_and_shift([0, 100, -50], 34)

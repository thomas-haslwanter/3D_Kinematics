"""Visualizing 3-D data. """
# author: Thomas Haslwanter, date: July-2017

# Import the required packages and functions
import numpy as np
import matplotlib.pyplot as plt
from skinematics import view, quat

# 2D Viewer -----------------
data = np.random.randn(100,3)
t = np.arange(0,2*np.pi,0.1)
x = np.sin(t)    

# Show the data
view.ts(data)

# Let the user select data from the local workspace
view.ts(locals())

# 3-D Viewer ----------------
# Set the parameters
omega = np.r_[0, 10, 10]     # [deg/s]
duration = 2
rate = 100
q0 = [1, 0, 0, 0]
out_file = 'demo_patch.mp4'
title_text = 'Rotation Demo'

## Calculate the orientation
dt = 1./rate
num_rep = duration*rate
omegas = np.tile(omega, [num_rep, 1])
q = quat.calc_quat(omegas, q0, rate, 'sf')
    
#orientation(q)
view.orientation(q, out_file, 'Well done!')

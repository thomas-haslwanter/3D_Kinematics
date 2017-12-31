"""Orientation of targeting device.

"""
# author: Thomas Haslwanter, date: Nov-2017

# Import the required packages
import numpy as np
import matplotlib.pyplot as plt
import skinematics as skin

# Generate an "infinity"-loop, in 10m distance
t = np.arange(0,20,0.1) # 20 sec, at a rate of 0.1 Hz
y = np.cos(t)
z = np.sin(2*t)
x = 10 * np.ones_like(y)
data = np.column_stack( (x,y,z) )

# Calculate the target-orientation, i.e. the quaternion that rotates
# the vector [1,0,0] such that it points towards the target
q_target = skin.vector.q_shortest_rotation([1,0,0], data)

# Plot the results
fig, axs = plt.subplots(2,1)
axs[0].plot(-y,z)
axs[0].set_title('Target on screen, distance=10')
axs[1].plot(q_target)
axs[1].set_xlabel('Time')
axs[1].set_ylabel('Quaternion')
axs[1].legend(['x', 'y', 'z'])
plt.show()

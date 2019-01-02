"""Working with angular velocities """

# author: Thomas Haslwanter, date: Sept-2017

# Import the required functions
import numpy as np
from skinematics import quat
import matplotlib.pyplot as plt

# Camera Looking 10 deg down, and rotating with 100 deg/s about an
# earth-vertical axis for 5 sec, sample-rate 100 Hz

# Experimental parameters
down = np.deg2rad(10)       # deg
duration = 10    # sec
rate = 100      # Hz

# Starting orientation of the camera
q_start = np.array([0, np.sin(down/2), 0])

# Movement of the platform
dt = 1./rate
t = np.arange(0, duration, dt)
omega = np.tile([0, 0, np.deg2rad(100)], (len(t), 1) )

# Orientation of the camera in space, during the rotation of the platform
# with a space-fixed ("sf") angular velocity "omega".
# Note that this one line does all the calculations required!
q_moving = quat.calc_quat(omega, q_start, rate, 'sf')

# Visualization
fig, axs = plt.subplots(1,2, figsize=(10,6))
axs[0].plot(t, quat.q_vector(q_moving))
axs[0].set(xlabel = 'Time [sec]',
       ylabel = 'Orientation [quat]',
       title = 'Rotation about g, with 100 deg/s')
axs[0].legend(['$q_1$', '$q_2$', '$q_3$'])
# Note that even for this simple arrangement, the camera-orientation 
# in space is difficult to visualize!!

# And back from orientation to velocity
omega_recalc = quat.calc_angvel(q_moving, rate=rate)
axs[1].plot(t, np.rad2deg(omega_recalc))
axs[1].set(xlabel = 'Time [sec]',
       ylabel = 'Angular Velocity [deg/s]',
       title = 'Back-transformation')
axs[1].legend(['$\omega_x$', '$\omega_y$', '$\omega_z$'])

# Save to file
out_file = 'C5_examples_vel.png'
plt.savefig(out_file, dpi=200)
print('Image from "C5_examples_vel.py" saved to {0}.'.format(out_file))
plt.show()

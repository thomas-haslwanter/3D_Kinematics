"""Exercise 1.3: Simulation of a "simple" pendulum. """

# Author: Thomas Haslwanter, Date: April-2017

# First, import the required packages
import numpy as np
import matplotlib.pyplot as plt
import numpy as np
from scipy import constants
import os

# Define constants
g = constants.g     # gravity, [m/s^2]

def calculate_trajectory(phi_0, length_pendulum=0.2, out_file='test.dat'):
    """Simulate a pendulum in 2-D
    The equation of motion is:
        \frac{d^2 \phi}{dt^2} = -\frac{g}{l} \sin(phi)
    Also, writes the data to an out-file.

    Parameters
    ----------
    phi_0 : float
        starting angle [deg].
    length_pendulum : float
        length of the pendulum [m]
        The default is 0.2 m
    out_file : string
        name of the out_file

    Returns
    -------
    time : ndarray
        Time samples [s]
    angle : ndarray
        Pendulum angle [deg]
    """

    tMax = 5      # duration of simulation [sec]
    rate = 1000  # sampling rate [Hz]

    dt = 1 / rate
    time = np.arange(0, tMax, dt)

    def acc_func(alpha):
        """ Differential equation of motion
        
        Parameters:
        -----------
        alpha : float
            Starting angle [deg]
        
        Returns:
        --------
        time : ndarray
            Time values for the movement of the pendulum.
        phi : ndarray
            Pendulum angle [deg]
        """
        acc = -g/length_pendulum * np.sin(alpha)
        return acc

    # Initial conditions
    phi = [np.deg2rad(phi_0)]  # rad
    omega = [0]  # rad/s

    # Numerical integration with the Euler-Cromer method, which is more stable
    for ii in range(len(time) - 1):
        phi.append(phi[-1] + omega[-1]*dt)
        omega.append(omega[-1] + acc_func(phi[-1])*dt)

    return time, np.rad2deg(phi)

if __name__ == '__main__':
    '''Main part'''

    pendulum = 0.20  # [m]
    'Call the function that calculates the trajectory, and generate a plot'
    
    # For multiple plots, I clearly prefer the object oriented plotting style
    # More info on that in the book "Introduction to Statistics with Python",
    # in Chapter 3
    fig, axs = plt.subplots(2,1)
    
    # Starting position: 5 deg
    time, angle = calculate_trajectory(5)
    axs[0].set_xlim([0, np.max(time)])
    axs[0].plot(time, angle)
    axs[0].set_ylabel('Angle [deg]')
    axs[0].set_title('Pendulum')
    
    # Starting position: 70 deg
    time, angle = calculate_trajectory(70)
    axs[1].plot(time, angle)
    axs[1].set_xlim([0, np.max(time)])
    axs[1].set_ylabel('Angle [deg]')
    axs[1].set_xlabel('Time [sec]')
    
    # Save the figure, and show the user the corresponding info
    outFile = 'pendulum.png'
    plt.savefig(outFile, dpi=200)
    print('out_dir: {0}'.format(os.path.abspath('.')))
    print('Image saved to {0}'.format(outFile))
    plt.show()    

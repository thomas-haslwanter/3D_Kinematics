"""Exercise 1.1: Solve equations of motion for sinusoidally moving accelerometer."""

# author: Thomas Haslwanter, date: Dec-2017

# Load the required packages
import numpy as np
import matplotlib.pyplot as plt

# Set up the parameters
duration, rate = 10, 50 # for the plot
freq, amp = 2, 5        # for the sine-wave
v0, p0 = 0, 15          # initial conditions

# Calculate derived values
omega = 2*np.pi*freq
dt = 1/rate
time = np.arange(0, duration, dt)
acc = amp * np.sin(omega*time)

# In the following, I put each task in a function, to facilitate readability

def analytical():
    """Analytical solution of a sinusoidal acceleration
    
    Returns
    -------
    axs : list
        Axes handles to the three plots.
    """
    
    # Analytical solution
    vel = amp/omega * (1-np.cos(omega*time)) + v0
    pos = -amp/omega**2 * np.sin(omega*time) + (amp/omega + v0)*time + p0

    # Plot the data
    fig, axs = plt.subplots(3,1,sharex=True)

    axs[0].plot(time, acc)
    axs[0].set_ylabel('Acceleration')
    axs[0].margins(0)
    
    axs[1].plot(time, vel)
    axs[1].set_ylabel('Velocity')
    axs[1].margins(0)
    
    axs[2].plot(time, pos, label='analytical')
    axs[2].set_ylabel('Position')
    axs[2].set_xlabel('Time [sec]')
    axs[2].margins(0)
    
    return axs

def simple_integration(axs):
    """Numerical integration of the movement equations
    
    Paramters:
    ----------
    axs : list
        Axes handles to the three plots produced by "analytical".
    """
    
    # Initial conditions
    vel, pos = [v0], [p0]
    
    # Numerical solution
    for ii in range(len(time)-1):
        vel.append(vel[-1] + acc[ii]*dt)
        pos.append(pos[-1] + vel[-1]*dt)    # Euler-Cromer method
    
    # Superpose the lines on the previous plots
    axs[1].plot(time, vel)
    axs[2].plot(time, pos, label='numerical')
    plt.legend()
    
    plt.show()
    
if __name__ == '__main__':
    axs_out = analytical()
    simple_integration(axs_out)

    input('Done')   # Without this line Python closes immedeatly after running
    
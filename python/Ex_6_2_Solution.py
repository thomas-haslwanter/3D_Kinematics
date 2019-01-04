"""Exercise 6.1: Simulation of a "simple" pendulum.
This is not as simple as it looks. The signs are a bugger (force vs
acceleration, up vs down, orientation of coordinate system). Also, I was
surprised how quickly one gets artefacts in the reconstruction:
already with a sample rate of 1 kHz, artefacts sneak in!

"""

# Author: Thomas Haslwanter, Date: Jan-2019

import numpy as np
import matplotlib.pyplot as plt
import numpy as np
from scipy import signal, constants, integrate
import pandas as pd

g = constants.g     # gravity, [m/s^2]


def generate_data(length_pendulum, out_file='test.dat'):
    """Simulate a pendulum in 2D, and write the data to an out-file.
    
    Parameters
    ----------
    length_pendulum : float
        Length of the pendulum [m]
    out_file : string
        Name of out-file
    
    Returns
    -------
    df : Pandas DataFrame
        Contains 'time', 'phi', 'omega', 'gifBHor', 'gifBVer'
    rate : float
        Sampling rate [Hz]
    
    Notes
    -----
    The equation of motion is
    
    \frac{d^2 \phi}{dt^2} = -\frac{g}{l} \sin(phi)
    """

    tMax = 2      # duration of simulation [sec]
    rate = 10000  # sampling rate [Hz]

    dt = 1 / rate
    time = np.arange(0, tMax, dt)

    def acc_func(alpha):
        """ differential equation of motion """
        acc = -g/length_pendulum * np.sin(alpha)
        return acc

    # Memory allocation
    omega = np.nan * np.ones(len(time))
    phi   = np.nan * np.ones(len(time))

    # Initial conditions
    phi[0] = 0.1  # rad
    omega[0] = 0  # rad/s
    tStatic = 0.1  # initial static setup [sec]

    # Numerical integration
    for ii in range(len(time) - 1):
        phi[ii + 1] = phi[ii] + omega[ii] * dt
        if time[ii] < tStatic:  # static initial condition
            omega[ii + 1] = 0
        else:
            # Euler-Cromer method, is more stable
            omega[ii + 1] = omega[ii] + acc_func(phi[ii + 1]) * dt

    # Find the position, velocity, and acceleration
    # The origin is at the center of the rotation
    pos = length_pendulum * np.column_stack( (np.sin(phi), -np.cos(phi)) )

    vel = signal.savgol_filter(pos, window_length=5, polyorder=3, deriv=1, delta=dt, axis=0)
    acc = signal.savgol_filter(pos, window_length=5, polyorder=3, deriv=2, delta=dt, axis=0)

    # Add gravity
    accGravity = np.r_[0, g]
    gifReSpace = accGravity + acc

    # Transfer into a body-fixed system
    gifReBody = np.array([rotate(gif, -angle) for (gif, angle) in zip(gifReSpace, phi)])

    # Quickest way to write the "measured" data to a file, with headers
    df = pd.DataFrame(np.column_stack((time, phi, omega, gifReBody)), columns=['time', 'phi', 'omega', 'gifBHor', 'gifBVer'])
    df.to_csv(out_file, sep='\t')
    print('Data written to {0}'.format(out_file))

    return df, rate


def show_data(data, phi, pos, length):
    """Plots of the simulation, and comparison with original data
    
    Parameters
    ----------
    data :  Pandas DataFrame
        Contains 'time', 'phi', 'omega', 'gifBHor', 'gifBVer'
    phi : ndarray, shape (N,)
        Angles of the reconstructed movement.
    pos : ndarray, shape (N,2)
        x/y-positions of the reconstructed movement.
    length : float
        Length of the pendulum.
    """

    fig, axs = plt.subplots(3, 1, figsize=(5,5))

    # Show Phi
    axs[0].plot(data['time'], phi)
    axs[0].xaxis.set_ticklabels([])
    axs[0].set_ylabel('Phi [rad]')

    # Show Omega
    axs[1].plot(data['time'], data['omega'])
    axs[1].xaxis.set_ticklabels([])
    axs[1].set_ylabel('Omega [rad/s]')

    # Show measured force
    axs[2].plot(data['time'], data[['gifBHor', 'gifBVer']])
    axs[2].set_xlabel('Time [sec]')
    axs[2].set_ylabel('GIF re Body [m/s^2]')
    axs[2].legend(('Hor', 'Ver'))
    plt.tight_layout()

    # x,y plot of the position
    fig2, axs2 = plt.subplots(1, 2)
    axs2[0].plot(pos[:, 0], pos[:, 1])
    axs2[0].set_title('Position: Y vs X')
    axs2[0].set_xlabel('X')
    axs2[0].set_ylabel('Y')

    axs2[1].plot(data['time'], pos[:, 0], label='X')

    # and just to check if the results match
    axs2[1].plot(data['time'], length * np.sin(phi), 'r', label='L*sin(Phi)')
    axs2[1].legend
    axs2[1].set_title('X(t)')
    axs2[1].legend()
    plt.show()


def rotate(data, phi):
    """Rotate 2d data in column form
    
    Parameters
    ----------
    data : ndarray, shape (2,)
        x/y-data to be rotated.
    phi : float
        Angle of 2-D rotation.
        
    Returns
    -------
    rotated : ndarray, shape (2,)
        Rotated data.
    """

    Rmat = np.array([[np.cos(phi), -np.sin(phi)],
                     [np.sin(phi),  np.cos(phi)]])
    rotated = (Rmat @ data.T).T

    return rotated


def reconstruct_movement(omega, gifMeasured, length, rate):
    """ From the measured data, reconstruct the movement
    
    Parameters
    ----------
    omega : ndarray, shape (N,)
        Angular velocity [rad/s]
    gifMeasured : ndarray, shape (N,2)
        Gravito-inertial force per unit mass [kg m/s^2]
    length : float
        Length of pendulum [m]
        
    Returns
    -------
    phi : ndarray, shape (N,)
        Angle of pendulum [rad]
    pos : ndarray, shape (N,2)
        x/y-position of pendulum [m]
    """

    dt = 1/rate

    # Initial orientation
    gif_t0 = gifMeasured[0]
    phi0 = np.arctan2(gif_t0[0], gif_t0[1])

    # Calculate phi, by integrating omega
    phi = integrate.cumtrapz(omega, dx=dt, initial=0) + phi0

    # From phi and the measured acceleration, get the movement acceleration
    accReSpace = np.array([rotate(gif, angle) - np.array([0, g]) for (gif, angle) in zip(gifMeasured, phi)])

    # Position and Velocity through integration
    vel = np.nan * np.ones(accReSpace.shape)
    pos = np.nan * np.ones(accReSpace.shape)

    init = length * np.array([np.sin(phi[0]), -np.cos(phi[0])])
    for ii in range(accReSpace.shape[1]):
        vel[:, ii] = integrate.cumtrapz(accReSpace[:, ii], dx=dt, initial=0)
        pos[:, ii] = integrate.cumtrapz(vel[:, ii], dx=dt, initial=0)
        pos[:, ii] += init[ii]  # initial condition

    return phi, pos


if __name__ == '__main__':
    '''Main part'''

    pendulum = 0.20  # [m]
    sim_data, sample_rate = generate_data(pendulum)

    # Get the data: this is just to show how such data can be read in again
    # data = pd.io.parsers.read_table(outFile, skipinitialspace=True)

    # From the measured data, reconstruct the movement:
    # First, find the sampling rate from the time
    phi_calc, pos_calc = reconstruct_movement(omega=sim_data['omega'].values,
                                              gifMeasured=sim_data[['gifBHor', 'gifBVer']].values,
                                              length=pendulum,
                                              rate=sample_rate)

    # Show the results - this should be a smooth oscillation
    show_data(sim_data, phi_calc, pos_calc, pendulum)

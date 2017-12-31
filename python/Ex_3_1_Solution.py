""" Exercise 3.1: Orientation of the elements of a modern CT scanner.

"""

# Author: Thomas Haslwanter, Date: Dec-2017
import numpy as np
import os

from skinematics.rotmat import R, R_s
from skinematics.vector import normalize
from collections import namedtuple

    
def find_CT_orientation():
    '''Find the angles to bring an "Axiom Artis dTC" into a desired
    orientation.'''

    # Calculate R_total
    R_total = R_s(2, 'alpha')*R_s(0, 'beta')*R_s(1, 'gamma')

    # Use pprint, which gives a nicer display for the matrix
    import pprint
    pprint.pprint(R_total)

    # Find the desired orientation of the CT-scanner
    bullet_1 = np.array([5,2,2])
    bullet_2 = np.array([5,-2,-4])
    n = np.cross(bullet_1, bullet_2)

    ct = np.nan * np.ones((3,3))
    ct[:,1] = normalize(bullet_1)
    ct[:,2] = normalize(n)
    ct[:,0] = np.cross(ct[:,1], ct[:,2])
    
    print('Desired Orientation (ct):')
    print(ct)

    # Calculate the angle of each CT-element
    beta =  np.arcsin( ct[2,1] )
    gamma = np.arcsin( -ct[2,0]/np.cos(beta) )

    # next I assume that -pi/2 < gamma < pi/2:
    if np.sign(ct[2,2]) < 0:
        gamma = np.pi - gamma
        
    # display output between +/- pi:
    if gamma > np.pi:
        gamma -= 2*np.pi
    
    alpha = np.arcsin( -ct[0,1]/np.cos(beta) )

    alpha_deg = np.rad2deg( alpha )
    beta_deg =  np.rad2deg( beta  )
    gamma_deg = np.rad2deg( gamma )
    
    # Check if the calculated orientation equals the desired orientation
    print('Calculated Orientation (R):')
    rot_mat = R(2, alpha_deg) @ R(0, beta_deg) @ R(1, gamma_deg)
    print(rot_mat)

    return (alpha_deg, beta_deg, gamma_deg)

if __name__=='__main__':

    (alpha, beta, gamma) = find_CT_orientation()
    print('alpha/beta/gamma = {0:5.1f} / {1:5.1f} / {2:5.1f} [deg]\n'.format(alpha, beta, gamma))

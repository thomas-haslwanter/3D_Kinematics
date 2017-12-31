"""Working with rotation matrices """

# author: Thomas Haslwanter, date: Dec-2017

# Import the required packages and functions
import numpy as np
from skinematics import rotmat
from pprint import pprint

# Since I use R and R_s repeatedly, I import them directly
from skinematics.rotmat import R, R_s

# Rotation about the x-axis, by 30 deg
Rx_30 = R(axis=0, angle=30)

print('Rotation matrix describing a rotation about the x-axis by 30 deg:')
print(Rx_30)

# Find the rotation matrix for the nautical sequence
# "pprint" is required for a nicer, matrix-shaped display
R_nautical = R_s(2, 'theta') * R_s(1, 'phi') * R_s(0, 'psi')

print('\nNautical sequence:')
pprint(R_nautical)


# Rotation matrix for Euler sequence, for given angles
alpha, beta, gamma = 45, 30, 20     # in [deg]
R = R(2, gamma) @ R(0, beta) @ R(2, alpha)

print('\nRotation matrix, for "Euler-angles" of {0}, {1}, {2} deg:'.format(alpha, beta, gamma))
print(R)

# Corresponding nautical sequence:
nautical = rotmat.sequence(R, to='nautical')

# ... and just to check
euler = rotmat.sequence(R, to='Euler')

print('\nNautical sequence: {0}'.format(nautical))
print('Euler sequence: {0}'.format(np.rad2deg(euler)))

'''
Output
------
Rotation matrix describing a rotation about the x-axis by 30 deg:
[[ 1.         0.         0.       ]
 [ 0.         0.8660254 -0.5      ]
 [ 0.         0.5        0.8660254]]

Nautical sequence:
Matrix([
[cos(phi)*cos(theta), sin(phi)*sin(psi)*cos(theta) - sin(theta)*cos(psi), sin(phi)*cos(psi)*cos(theta) + sin(psi)*sin(theta)],
[sin(theta)*cos(phi), sin(phi)*sin(psi)*sin(theta) + cos(psi)*cos(theta), sin(phi)*sin(theta)*cos(psi) - sin(psi)*cos(theta)],
[          -sin(phi),                                  sin(psi)*cos(phi),                                  cos(phi)*cos(psi)]])

Rotation matrix, for "Euler-angles" of 45, 30, 20 deg:
[[ 0.45501932 -0.87390673  0.17101007]
 [ 0.81728662  0.3335971  -0.46984631]
 [ 0.35355339  0.35355339  0.8660254 ]]

Nautical sequence: [ 1.06279023 -0.36136712  0.38759669]
Euler sequence: [ 45.  30.  20.]
'''

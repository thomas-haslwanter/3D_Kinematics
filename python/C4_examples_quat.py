"""Working with quaternions """

# author: Thomas Haslwanter, date: Dec-2017

# Import the required functions
import numpy as np
from skinematics import quat
from pprint import pprint
import matplotlib.pyplot as plt

# Just the magnitude
q_size = quat.deg2quat(10)
print('10 deg converted to quaternions is {0:5.3f}\n'.format(q_size))

# Input quaternion vector
alpha = [10, 20]
print('Input angles: {0}'.format(alpha))

alpha_rad = np.deg2rad(alpha)
q_vec = np.array([[0, np.sin(alpha_rad[0]/2), 0],
                   [0, 0, np.sin(alpha_rad[1]/2)]])
print('Input:')
pprint(q_vec)


# Unit quaternion
q_unit = quat.unit_q(q_vec)
print('\nUnit quaternions:')
pprint(q_unit)

# Also add a non-unit quaternion
q_non_unit = np.r_[1, 0, np.sin(alpha_rad[0]/2), 0]
q_data = np.vstack((q_unit, q_non_unit))
print('\nGeneral quaternions:')
pprint(q_data)

# Inversion
q_inverted = quat.q_inv(q_data)
print('\nInverted:')
pprint(q_inverted)

# Conjugation
q_conj = quat.q_conj(q_data)
print('\nConjugated:')
pprint(q_conj)

# Multiplication
q_multiplied = quat.q_mult(q_data, q_data)
print('\nMultiplied:')
pprint(q_multiplied)

# Scalar and vector part
q_scalar = quat.q_scalar(q_data)
q_vector = quat.q_vector(q_data)

print('\nScalar part:')
pprint(q_scalar)
print('Vector part:')
pprint(q_vector)

# Convert to axis angle
q_axisangle = quat.quat2deg(q_unit)
print('\nAxis angle:')
pprint(q_axisangle)

# Conversion to a rotation matrix
rotmats = quat.convert(q_unit)
print('\nFirst rotation matrix')
pprint(rotmats[0].reshape(3,3))


# Working with Quaternion objects
# -------------------------------
data  = np.array([ [0,0,0.1], [0, 0.2, 0  ] ])
data2 = np.array([ [0,0,0.1], [0, 0,   0.1] ])

eye = quat.Quaternion(data)
head = quat.Quaternion(data2)

# Quaternion multiplication, ...
gaze = head * eye

# ..., division, ...
head = gaze/eye
# or, equivalently
head = gaze * eye.inv()

# ..., slicing, ...
print(head[0])

# ... and access to the data
head_values = head.values
print(type(head.values))
'''
Output
------
10 deg converted to quaternions is 0.087

Input angles: [10, 20]
Input:
array([[ 0.        ,  0.08715574,  0.        ],
       [ 0.        ,  0.        ,  0.17364818]])

Unit quaternions:
array([[ 0.9961947 ,  0.        ,  0.08715574,  0.        ],
       [ 0.98480775,  0.        ,  0.        ,  0.17364818]])

General quaternions:
array([[ 0.9961947 ,  0.        ,  0.08715574,  0.        ],
       [ 0.98480775,  0.        ,  0.        ,  0.17364818],
       [ 1.        ,  0.        ,  0.08715574,  0.        ]])

Inverted:
array([[ 0.9961947 , -0.        , -0.08715574, -0.        ],
       [ 0.98480775, -0.        , -0.        , -0.17364818],
       [ 0.99246114, -0.        , -0.08649869, -0.        ]])

Conjugated:
array([[ 0.9961947 , -0.        , -0.08715574, -0.        ],
       [ 0.98480775, -0.        , -0.        , -0.17364818],
       [ 1.        , -0.        , -0.08715574, -0.        ]])

Multiplied:
array([[ 0.98480775,  0.        ,  0.17364818,  0.        ],
       [ 0.93969262,  0.        ,  0.        ,  0.34202014],
       [ 0.99240388,  0.        ,  0.17431149,  0.        ]])

Scalar part:
array([ 0.9961947 ,  0.98480775,  1.        ])
Vector part:
array([[ 0.        ,  0.08715574,  0.        ],
       [ 0.        ,  0.        ,  0.17364818],
       [ 0.        ,  0.08715574,  0.        ]])

Axis angle:
array([[  0.,  10.,   0.],
       [  0.,   0.,  20.]])

First rotation matrix
array([[ 0.98480775,  0.        ,  0.17364818],
       [ 0.        ,  1.        ,  0.        ],
       [-0.17364818,  0.        ,  0.98480775]])
       
Quaternion [[ 0.99498744  0.          0.          0.1       ]]       

<class 'numpy.ndarray'>
'''
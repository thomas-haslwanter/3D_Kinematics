"""Working with vectors.

For simplicity, the functions are applied to individual vectors. However, all
functions also work on rows of vectors.

"""
# author: Thomas Haslwanter, date: July-2017

# Import the required packages and functions
import numpy as np
from skinematics import vector

# Input data
v0 = [0, 0, 0]
v1 = [1, 0, 0]
v2 = [1, 1, 0]

# Length of a vector
length_v2 = np.linalg.norm(v2)
print('The length of v2 is {0:5.3f}\n'.format(length_v2))

# Angle between two vectors
angle = vector.angle(v1, v2)
print('The angle between v1 and v2 is {0:4.1f} degree\n'.format(np.rad2deg(angle)))

# Vector normalization
v2_normalized = vector.normalize(v2)
print('v2 normalized is {0}\n'.format(v2_normalized))

# Projection
projected = vector.project(v1, v2)
print('The projection of v1 onto v2 is {0}\n'.format(projected))

# Plane orientation
n = vector.plane_orientation(v0, v1, v2)
print('The plane spanned by v0, v1, and v2 is orthogonal to {0}\n'.format(n))

# Gram-Schmidt orthogonalization
gs = vector.GramSchmidt(v0, v1, v2)
print('The Gram-Schmidt orthogonalization of the points v0, v1, and v2 is {0}\n'.format(np.reshape(gs, (3,3))))

# Shortest rotation
q_shortest = vector.q_shortest_rotation(v1, v2)
print('The shortest rotation that brings v1 in alignment with v2 is described by the quaternion {0}\n'.format(q_shortest))

# Rotation of a  vector by a quaternion
q = [0, 0.1, 0]
rotated = vector.rotate_vector(v1, q)
print('v1 rotated by {0} is: {1}'.format(q, rotated))

print('Done')

'''
Output
------
The length of v2 is 1.414

The angle between v1 and v2 is 45.0 degree

v2 normalized is [ 0.70710678  0.70710678  0.        ]

The projection of v1 onto v2 is [ 0.5  0.5  0. ]

The plane spanned by p0, p1, and p2 is orthogonal to [ 0.  0.  1.]

The Gram-Schmidt orthogonalization of the points p0, p1, and p2 is [[ 1.  0.  0.]
 [ 0.  1.  0.]
 [ 0.  0.  1.]]

The shortest rotation that brings v1 in alignment with v2 is described by the quaternion [ 0.          0.          0.38268343]

v1 rotated by [0, 0.1, 0] is: [ 0.98        0.         -0.19899749]
'''

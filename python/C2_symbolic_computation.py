"""Demonstration of symbolic computations.

Here the package sympy 
http://www.sympy.org/en/index.html
is used to multiply symbolic rotation matrices, for rotations about different
inertial axes.
"""
# author: Thomas Haslwanter, date: Sept-2017

# Import the required packages
import sympy
import pprint

# Symbolic version of rotation matrices
def R1_s():
    ''' Symbolic rotation matrix about the 1-axis, by an angle psi '''
    psi = sympy.Symbol('psi')
    return sympy.Matrix([[1,0,0],
                         [0, sympy.cos(psi), -sympy.sin(psi)],
                         [0, sympy.sin(psi), sympy.cos(psi)]])

def R2_s():
    ''' Symbolic rotation matrix about the 2-axis, by an angle phi '''
    phi = sympy.Symbol('phi')
    return sympy.Matrix([[sympy.cos(phi),0, sympy.sin(phi)],
                         [0,1,0],
                         [-sympy.sin(phi), 0, sympy.cos(phi)]])

def R3_s():
    ''' Symbolic rotation matrix about the 3-axis, by an angle theta '''
    theta = sympy.Symbol('theta')
    return sympy.Matrix([[sympy.cos(theta), -sympy.sin(theta), 0],
                         [sympy.sin(theta), sympy.cos(theta), 0],
                         [0, 0, 1]])

# Find the rotation matrix for the aeronautic sequence
R_nautical = R3_s()*R2_s()*R1_s()

pprint.pprint(R_nautical)

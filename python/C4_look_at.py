""" Given the positions of a missile and a target, and the missile orientation,
calculate the gimbal orientation of a camera mounted on the missile, such
that the camera points at the target.
The optical axis of the camera is the x-axis.
"""

# author: ThH, date:   Dec-2017, ver:    1.0

# Import the required packages
import numpy as np
import skinematics as skin


def camera_orientation(missile_pos, missile_orient, target_pos):
    '''Find camera orientation re missile, to focus on target.
    
    Inputs
    ------
    missile_pos : ndarray (3,) or (N,3)
        Position of missile in space
    missile_orient : ndarray (3,) or (N,3)
        Orientation of missile, in Helmholtz angles [rad]
    target_pos : ndarray (3,) or (N,3)
        Position of target in space
        
    Returns
    -------
    camera_orientation : ndarray (3,) or (N,3)
        Camera orientation, in Helmholtz angles [deg]
    '''
    
    # Required camera direction in space is a vector from missile to target
    v_missile_target = target - missile
    
    # Camera direction re missile
    q = skin.rotmat.seq2quat(np.rad2deg(helm), seq='Helmholtz')
    tm_in_missile_CS = skin.vector.rotate_vector(v_missile_target, -q)
    
    # Required camera orientation on missile, to focus on the target
    camera_orientation = skin.vector.target2orient(tm_in_missile_CS,
            orient_type='Helmholtz')
    
    return camera_orientation


if __name__=='__main__':
    
    # Set up the system
    helm = [-1.2, -0.2, -1.1]  # Missile orientation, in Helmholtz angles [rad]
    target = np.r_[10, 1700, -2200]
    missile = np.r_[23, -560, -1800]
    
    # Find the camera orientation
    camera = camera_orientation(missile, helm, target)
    
    # Show the results
    print('Camera orientation on missile, in Helmholtz angles:\n' +
          'pitch={0:4.2f}, yaw={1:4.2f} [deg]'.format(*camera))

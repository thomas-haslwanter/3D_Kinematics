'''
Find the best estimate from two Gaussian inputs.

author: ThH
date:   Aug-2016
ver:    0.1
'''

# Import required packages
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.mlab as mlab
from scipy import stats
import seaborn as sns

sns.set(context="poster", style="ticks", font_scale=1.5)

# Generate the data
dt = 0.1
x = np.arange(150, 200, dt)
n1 = stats.norm(173, 4)
n2 = stats.norm(180,5)

m1 = n1.pdf(x)
m2 = n2.pdf(x)
combined = m1 * m2
combined /= np.sum(combined)*dt

# Make the plot
fig, ax = plt.subplots(1,1)

ax.plot(x, m1, label='$N_1$')
ax.plot(x, m2, label='$N_2$')
ax.plot(x, combined, '--', label='$N_1 * N_2$')
ax.set_xlabel('x')
ax.set_ylabel('PDF(x)')
plt.legend()

# Save the plot
outFile = 'combine_gaussians.png'
plt.savefig(outFile, dpi=300)
plt.show()
print('Plot saved to {0}'.format(outFile))


import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm

# Configuración de estilo y parámetros
plt.style.use('seaborn-v0_8-whitegrid' if 'seaborn-v0_8-whitegrid' in plt.style.available else 'default')
fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(10, 7), sharey=False)
fig.subplots_adjust(hspace=0.45)

params = [
    {'mu': 3,  'sigma': 0.8, 'color': '#d62728', 'label': r'$\mu_1=3, \sigma_1=0.8$'},
    {'mu': 7,  'sigma': 1.2, 'color': '#1f77b4', 'label': r'$\mu_2=7, \sigma_2=1.2$'},
    {'mu': 12, 'sigma': 1.8, 'color': '#ff7f0e', 'label': r'$\mu_3=12, \sigma_3=1.8$'}
]

# --- 1. Distribuciones Originales X ~ N(mu, sigma) ---
x1 = np.linspace(0, 18, 1000)
for p in params:
    mu, s, c = p['mu'], p['sigma'], p['color']
    y = norm.pdf(x1, mu, s)
    ax1.plot(x1, y, color=c, lw=2.2, label=p['label'])
    
    # Líneas de referencia: mu y mu +- sigma
    ax1.vlines(mu, 0, norm.pdf(mu, mu, s), color=c, ls='--', lw=1.2, alpha=0.8)
    ax1.vlines([mu - s, mu + s], 0, norm.pdf(mu + s, mu, s), color=c, ls=':', lw=1, alpha=0.7)
    
ax1.set_title(r'Distribuciones Originales: $X_i \sim \mathcal{N}(\mu_i, \sigma_i^2)$', fontsize=13, pad=10)
ax1.set_xlabel('$X$', fontsize=11)
ax1.set_ylabel('$f(X)$', fontsize=11)
ax1.set_xlim(0, 18)
ax1.legend(frameon=True, facecolor='white', framealpha=0.9)

# --- 2. Distribución Estandarizada Z ~ N(0, 1) ---
z = np.linspace(-4, 4, 1000)
y_std = norm.pdf(z, 0, 1)

# Superposición para ilustrar la convergencia idéntica
for p in params:
    ax2.plot(z, y_std, color=p['color'], lw=2, alpha=0.6, ls='-')

ax2.vlines(0, 0, norm.pdf(0, 0, 1), color='black', ls='--', lw=1.2)
ax2.vlines([-1, 1], 0, norm.pdf(1, 0, 1), color='gray', ls=':', lw=1)

ax2.set_title(r'Distribución Estandarizada: $Z \sim \mathcal{N}(0, 1)$', fontsize=13, pad=10)
ax2.set_xlabel(r'$Z = \frac{X - \mu}{\sigma}$', fontsize=12)
ax2.set_ylabel('$f(Z)$', fontsize=11)
ax2.set_xlim(-4, 4)
ax2.set_xticks([-3, -2, -1, 0, 1, 2, 3])

# --- Flechas de transformación y fórmula ---
for p in params:
    fig.add_artist(plt.matplotlib.patches.ConnectionPatch(
        xyA=(p['mu'], 0), coordsA=ax1.transData,
        xyB=(0, norm.pdf(0, 0, 1)), coordsB=ax2.transData,
        arrowstyle="-|>", lw=1.4, color=p['color'], alpha=0.5,
        connectionstyle="arc3,rad=-0.15"
    ))

fig.text(0.5, 0.49, r'$Z = \frac{X - \mu}{\sigma}$', 
         fontsize=14, ha='center', va='center',
         bbox=dict(boxstyle='round,pad=0.4', fc='white', ec='gray', alpha=0.9))

plt.savefig("normal_standardization.svg", bbox_inches='tight')
plt.show()
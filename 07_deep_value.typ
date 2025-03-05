#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm
#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "common.typ": *
#import "@preview/cetz:0.3.2"
#import "@preview/fletcher:0.5.5" as fletcher: diagram, node, edge
#import "@preview/pinit:0.2.2": *

#set math.vec(delim: "[")
#set math.mat(delim: "[")

#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Deep Value],
    subtitle: [CISC 7404 - Decision Making],
    author: [Steven Morad],
    institution: [University of Macau],
    logo: image("fig/common/bolt-logo.png", width: 4cm)
  ),
  header-right: none,
  header: self => utils.display-current-heading(level: 1)
)

#title-slide()

== Outline <touying:hidden>

#components.adaptive-columns(
    outline(title: none, indent: 1em, depth: 1)
)


= Admin

==
I noticed the last 1 hour of class everyone looks tired and sad 

Three hours is a long time to pay attention, especially at night

Would you prefer:
- To have a long break (30 mins) in the middle?
- No breaks, end lecture after 2 or 2.5 hours
- Keep as-is (approximately 3 hours + 10 min break)


==

*HW1 bug:*

There was a bug in the `update_Q_TD0` starter code, thanks He Zhe!

Before: 
```python
terminateds = jnp.concatenate([jnp.zeros(states.shape[0], dtype=bool), jnp.array([1], dtype=bool)])
```

After:
```python
terminateds = jnp.concatenate([jnp.zeros(states.shape[0] - 1, dtype=bool), jnp.array([1], dtype=bool)])
```

==
$ Q_(i+1)(s_0, a_0, theta_pi) = Q_(i)(s_0, a_0, theta_pi) - alpha dot eta $ #pause

#v(2em)

$ eta = #pin(1)Q_(i)(s_0, a_0, theta_pi)#pin(2) - #pin(3) (hat(bb(E))[cal(R)(s_1) | s_0, a_0] + #redm[$not d$] gamma max_(a in A) Q_i (s_1, a, theta_pi)) #pin(4) $ #pause


#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: top, height: 1.2em)[Predicted value] #pause

#pinit-highlight-equation-from((3,4), (3,4), fill: blue, pos: bottom, height: 1.2em)[Empirical value] #pause

#v(1em)

#text(fill: red)[小心!] If $s_1$ is a terminal state, future value is 0 ($not d="not terminated"$) #pause

Without the $not d$ term, takes longer to train!

==

I thought about coding deep Q networks in class today

But I realize if I do this, then you will not learn as much

Learning to debug is the \#1 skill to succeed in reinforcement learning

Instead, *you* will implement deep Q learning for your second homework

Homework 2:
- Deep Q learning
- Deep policy gradient

Will release after homework 1

==

Next quiz in 2-3 weeks

Focus on 
- Returns
- Value functions
- Q learning
- Deep Q learning
- Policy gradient

= Review

= Deep Learning Review
// Neural network is a function
// Neurons
// Layer sum equation 
// Deep neural networks are universal function approximators
// Optimal parameters exist, but how do we find them
// Loss functions and objectives, l2 error as distribution
// Stochastic gradient descent and Adam
// Dirty secret behind deep learning

==
We model neural networks as parameterized functions

$ f: X times Theta |-> Y $

Map an input $bold(x) in X$ and parameters $bold(theta) in Theta$ to output space $Y$

$ f(bold(x), bold(theta)) $

==
Neural networks consist of *artificial neurons* #pause

$ bold(x) in bb(R)^(d_x), bold(theta) in bb(R)^(d_x + 1) $ #pause

$ f(bold(x), bold(theta)) = sigma(bold(theta)^top overline(bold(x))) = sigma(theta_0 + sum_(i=1)^(d_x) theta_i dot x_i) $ #pause

#side-by-side[
  $sigma$ is a nonlinearity like sigmoid #pause
][
  $ sigma(x) = 1 / (1 + e^(-x)) $ #pause
]

#side-by-side[
  Or ReLU #pause
][
  $ sigma(x) = max(0, x) $
]

==
We combine individual neurons into a *layer* #pause

  $ f: bb(R)^(d_x) times Theta |-> bb(R) $  #pause
  
  $ Theta = bb(R)^(d_x + 1) $ #pause

  $d_y$ neurons (wide):

  $ f: bb(R)^(d_x) times Theta |-> bb(R)^(d_y) $ 
  
  $ Theta = bb(R)^((d_x + 1) times d_y) $

==
#side-by-side[For a single neuron #pause][
  $ f(vec(x_1, dots.v, x_(d_x)), vec(theta_0,  theta_1, dots.v, theta_(d_x)) ) = sigma(sum_(i=0)^(d_x) theta_i overline(x)_i) $ #pause

]

For a wide network #pause

$ f(vec(x_1, x_2, dots.v, x_(d_x)), mat(theta_(0,1), theta_(0,2), dots, theta_(0,d_y); theta_(1,1), theta_(1,2), dots, theta_(1, d_y); dots.v, dots.v, dots.down, dots.v; theta_(d_x, 1), theta_(d_x, 2), dots, theta_(d_x, d_y)) ) = vec(
  sigma(sum_(i=0)^(d_x) theta_(i,1) overline(x)_i ),
  sigma(sum_(i=0)^(d_x) theta_(i,2) overline(x)_i ),
  dots.v,
  sigma(sum_(i=0)^(d_x) theta_(i,d_y) overline(x)_i ),
)
  $  

==

We can combine layers to create a *deep* neural network #pause

  A wide network:

  $ f(bold(x), bold(theta)) = sigma(bold(theta)^top overline(bold(x))) $ #pause

  A deep network has many internal functions #pause

    $ f_1(bold(x), bold(phi)) = sigma(bold(phi)^top overline(bold(x))) quad #pause

    f_2(bold(x), bold(psi)) = sigma(bold(psi)^top overline(bold(x))) quad #pause

    dots quad #pause

    f_(ell)(bold(x), bold(xi)) = sigma(bold(xi)^top overline(bold(x))) $ #pause


  $ f(bold(x), bold(theta)) = f_(ell) (dots f_2(f_1(bold(x), bold(phi)), bold(psi)) dots bold(xi) ) $


==

  Written another way #pause

  $ bold(z)_1 = f_1(bold(x), bold(phi)) = sigma(bold(phi)^top overline(bold(x))) $ #pause
  $ bold(z)_2 = f_2(bold(z_1), bold(psi)) = sigma(bold(psi)^top overline(bold(z))_1) $ #pause
  $ dots.v $ #pause
  $ bold(y) = f_(ell)(bold(x), bold(xi)) = sigma(bold(xi)^top overline(bold(z))_(ell - 1)) $ #pause

  We call each function a *layer* #pause

  A deep neural network is made of many layers

==
We can create different models for different tasks #pause

Standard tasks: #pause Multi-layer perceptron (MLP) #pause

Image tasks: #pause Convolutional neural network (CNN) #pause

Temporal tasks: #pause Recurrent neural network (RNN) #pause

Image, temporal tasks: Transformer

==
  What functions can we represent using deep neural networks? #pause

  A deep neural network is a *universal function approximator* #pause

  It can approximate *any* continuous function $g(x)$ to precision $eta$ #pause

  $ | g(bold(x)) - f(bold(x), bold(theta)) | < eta $ #pause

  Making the network deeper or wider decreases $eta$ #pause

  #align(center)[#underline[Very powerful finding! The basis of deep learning.]] #pause

  Although such $bold(theta)$ exists, it can be hard to find
==

Finding $bold(theta)$ is an optimization problem #pause

In particular, we optimize a *loss function* #pause

$ cal(L): X times Y times Theta |-> bb(R) $ #pause

$ argmin_(bold(theta)) cal(L)(bold(x), bold(y), bold(theta)) $ #pause

Loss function measures the error between $f(bold(x), bold(theta))$ and desired $g(bold(x)) = bold(y)$ #pause

In this class, we will build loss functions from two error functions

==

*Square error:* The squared distance over a dataset of size $n$ #pause

$ sum_(i=1)^n sum_(j=1)^d_y (f(bold(x)_([i]), bold(theta))_j - g(bold(x))_j)^2 = sum_(i=1)^n sum_(j=1)^d_y (f(bold(x)_([i]), bold(theta))_j - y_([i], j))^2 $ #pause

*Cross entropy error:* The probabilistic error over a dataset of size $n$ #pause

#text(size: 23pt)[
$ - sum_(i=1)^n sum_(j=1)^(d_y) P(g(bold(x)_([i]))_j | bold(x)_[i]) log f(bold(x)_[i], bold(theta))_j 
 = - sum_(i=1)^n sum_(j=1)^(d_y) P(y_([i], j) | bold(x)_[i]) log f(bold(x)_[i], bold(theta))_j  $
]
==
#side-by-side[*Square error:*][
  $ sum_(i=1)^n sum_(j=1)^d_y (f(bold(x)_([i]), bold(theta))_j - y_([i], j))^2 $ #pause
] 

#side-by-side[*Cross entropy error:*][
$ - sum_(i=1)^n sum_(j=1)^(d_y) P(y_([i], j) | bold(x)_[i]) log f(bold(x)_[i], bold(theta))_j  $

]

*Question:* Which one will we use for Q learning?

*Answer:* Predict a scalar (expected return), so square error (regression)

==
We can use these errors in a loss function

$ cal(L)(bold(X), bold(Y), bold(theta)) = sum_(i=1)^n sum_(j=1)^d_y (f(bold(x)_([i]), bold(theta))_j - y_([i], j))^2 $ #pause

$ cal(L)(bold(X), bold(Y), bold(theta)) = - sum_(i=1)^n sum_(j=1)^(d_y) P(y_([i], j) | bold(x)_[i]) log f(bold(x)_[i], bold(theta))_j  $

==

When we train, we search for neural network parameters $theta$ #pause

$ argmin_bold(theta) cal(L)(bold(X), bold(Y), bold(theta)) = argmin_bold(theta) sum_(i=1)^n sum_(j=1)^d_y (f(bold(x)_([i]), bold(theta))_j - y_([i], j))^2 $ #pause

$ argmin_bold(theta) cal(L)(bold(X), bold(Y), bold(theta)) = argmin_bold(theta) - sum_(i=1)^n sum_(j=1)^(d_y) P(y_([i], j) | bold(x)_[i]) log f(bold(x)_[i], bold(theta))_j  $

==

*Question:* Which search method do we use? #pause

*Answer:* Gradient-based methods (gradient descent, Adam, etc) #pause


#cimage("fig/07/hiking_slope.jpg", height: 70%)


==
#algorithm({
import algorithmic: *

Function("Gradient Descent", args: ($bold(X)$, $bold(Y)$, $cal(L)$, $t$, $alpha$), {

  Cmt[Randomly initialize parameters]
  Assign[$bold(theta)$][$"Glorot"()$] 

  For(cond: $i in 1 dots t$, {
    Cmt[Compute the gradient of the loss]        
    Assign[$bold(J)$][$gradient_bold(theta) cal(L)(bold(X), bold(Y), bold(theta))$]
    Cmt[Update the parameters using the negative gradient]
    Assign[$bold(theta)$][$bold(theta) - alpha dot bold(J)$]
  })

Return[$bold(theta)$]
})
}) #pause

Gradient descent computes $gradient cal(L)$ over all $bold(X)$

==
We can put it all together in jax and equinox

```python
from jax import random
from equinox import nn

seed = random.key(0)
key, *net_keys= random.split(seed, 4)
net = nn.Sequential([
  nn.Linear(d_x, d_h, key=net_keys[0]), 
  nn.Lambda(jax.nn.leaky_relu),
  nn.Linear(d_h, d_h, key=net_keys[1]), 
  nn.Lambda(jax.nn.leaky_relu),
  nn.Linear(d_h, d_y, key=net_keys[2]), 
])
```

==
We can extract parameters using `eqx.partition`
```python
import equinox as eqx
# Get all arrays (parameters) in the network
theta, model = eqx.partition(net, eqx.is_array)
# Add one to every parameter
theta = jax.tree.map(theta, lambda x: x + 1)
# Put the new parameters back into network
net = eqx.combine(theta, model)
```

==
We can define loss functions

```python
import equinox as eqx

def L_square(net, x, y):
  # vmap applies network to batch of data
  prediction = eqx.filter_vmap(net)(x)
  return ((prediction - y) ** 2).mean()

def L_cross_entropy(net, x, y):
  # Net outputs probabilities 
  # And y is one-hot, e.g. [0, 0, 1, 0]
  prediction = eqx.filter_vmap(model)(x)
  return -(y * jnp.log(prediction)).sum(-1).mean()
```

==
```python
import optax
import equinox as eqx
opt = optimizer.adam(learning_rate=3e-4)
# Adam needs to track momentum and variance
opt_state = opt.init(eqx.filter(net, eqx.is_array))
# Gradient of loss function is a function
grad_L = eqx.filter_grad(L_square) 
# Evaluate grad_L at x, y, theta to find J
J = grad_L(net, x, y)
# Compute parameter update using J (adam)
updates, opt_state = opt.update(
    grads, opt_state, params=eqx.filter(net, eqx.is_array)
)
net = eqx.apply_updates(net, updates) # Update params
```

==
```python
def train_one_batch(net, dataset):
  x, y = batch
  grads = eqx.filter_grad(L_square)(net, x, y)
  updates, opt_state = opt.update(
    grads, opt_state, params=eqx.filter(net, eqx.is_array)
  )
  net = eqx.apply_updates(net, updates) # Update params
  return net, opt_state

for epoch in range(num_epochs):
  for batch in dataset:
    # Can use eqx.filter_jit(f) for speedup
    net, opt_state = train_one_batch(net, batch, opt_state)
```

==
*Dirty secret of deep learning:* #pause We do not understand deep learning 

Biological inspiration, theoretical bounds and mathematical guarantees #pause

For complex neural networks, deep learning is a *science* not *math* #pause

No accepted theory for why deep neural networks are so effective #pause

In modern deep learning, we progress using trial and error #pause

Today we experiment, and maybe tomorrow we discover the theory 












= Deep Q Learning
==
After the homework and last lecture, you are experts in Q learning #pause

You quickly trained a Q function to solve a task #pause

Why introduce deep learning to Q learning? #pause

Consider an example problem

==
*Example:* Learn a policy to pick up trash and put it in the bin #pause

#cimage("fig/07/binrobot.png", height: 70%)

==
*Question:* What is $S$? #pause

- Camera image $bb(R)^(256 times 256 times 3)$ #pause
- Lidar scan $bb(R)_+^(4096)$ #pause
- Arm position $[0, 1]^3$ #pause
- Map position $[0, 1]^2$ #pause
- Trash position $[0, 1]^(2k)$ #pause

In the assignment, we store Q value for each state in a matrix #pause

*Question:* What is the size of the matrix? #pause

$ S times A $ 

==
Let us consider a simplification, only have the map position #pause

$ S in [0, 1]^2 $ #pause

*Question:* What is the size of our Q matrix? #pause

*Answer:* There are infinitely many numbers between 0 and 1 

$ 0.01, 0.001, 0 dots 1 $ #pause

The state space is infinite, our Q value matrix is infinitely big #pause

*Question:* What can we do (besides neural networks)? #pause

*Answer:* Discretize the space

==

$ S in [0, 1]^2 $ #pause

Discretize to $128 times 128$ grid squares #pause

$ S in {1, dots, 128}^2 $ #pause

*Question:* What is the size of the Q matrix? #pause

$ 16384 times A $ #pause

Very large but not infinite

==
#let graph = tiling(size: (2cm, 2cm))[
  #place(line(start: (0%, 0%), end: (0%, 100%)))
  #place(line(start: (0%, 0%), end: (100%, 0%)))
]

#rect(fill: graph, width: 100%, height: 50%) #pause

We must update Q for each $s, a$ separately #pause

With TD updates, updating one cell means we must update all cells

==
With TD updates, updating one cell means we must update all cells #pause

Convergence takes at least this many samples

$ ( |S| |A| ) / ((1 - gamma)^5 dot epsilon^2) $ #pause

Assume $gamma = 0.99, epsilon = 0.1$ #pause

$ (16348 | A |) / ((0.01)^5 dot 0.1^2) approx 1.6 times 10^16 $ #pause

This is the *minimum* number of samples to learn Q


==
Simple Q learning works very well when the state space is small #pause

We need a solution for infinite/continuous/large state spaces #pause

We need a Q function that generalizes to new states #pause

#let graph = tiling(size: (2cm, 2cm))[
  #place(line(start: (0%, 0%), end: (0%, 100%)))
  #place(line(start: (0%, 0%), end: (100%, 0%)))
]

#rect(fill: graph, width: 100%, height: 50%)

==

We know that deep learning generalizes well #pause

Can approximate any function with a deep neural network #pause

Represent the Q function using a deep neural network #pause

Just because parameters exist, does not mean we can find them #pause

There is *no guarantee* we will find parameters for the Q function #pause

But we will try!


==
// Proof of simple convergence
  // Contraction mapping
  // Nonlinear, we no longer have guarantees
  // Similar to DL course, now we are in magic land
  // Deadly triad


==
First, define the Q function as a deep neural network #pause

$ Q: S times A times Theta_pi times Theta_Q |-> bb(R) $ #pause

#v(2em)

$ Q(s, a, theta_pi, theta_Q) $ #pause

The Q function estimates the policy-conditioned discounted return 

==

#v(2em)

$ #pin(1)Q#pin(2) (#pin(3) s_0, a_0#pin(4), theta_pi, #pin(7)theta_Q#pin(8)) = #pin(5)bb(E)[cal(G)(bold(tau)) | s_0, a_0; theta_pi]#pin(6)
$ #pause

#v(2em)

Make this an optimization objective, so we can train a network #pause

But this is different than what we usually see #pause

$ f(bold(x), bold(theta)) = bold(y) $ #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: top, height: 1.2em)[$f$] #pause

#pinit-highlight-equation-from((3,4), (3,4), fill: blue, pos: bottom)[$bold(x)$] #pause

#pinit-highlight-equation-from((7,8), (7,8), fill: orange, pos: bottom)[$bold(theta)$] #pause

#pinit-highlight-equation-from((5,6), (5,6), fill: green, pos: bottom)[$bold(y)$] 


==

$ Q (#pin(3)s_0, a_0#pin(4), theta_pi, #pin(7)theta_Q#pin(8)) = #pin(5)bb(E)[cal(G)(bold(tau)) | s_0, a_0; theta_pi]#pin(6)
$ #pause

Move everything to left #pause

$ Q(s_0, a_0, theta_pi, theta_Q) - bb(E)[cal(G)(bold(tau)) | s_0, a_0; theta_pi] = 0 
$ #pause

Use a distance measure so we can minimize, choose square error #pause

$ (Q(s_0, a_0, theta_pi, theta_Q) - bb(E)[cal(G)(bold(tau)) | s_0, a_0; theta_pi])^2 = 0 
$ 

==
$ (Q(s_0, a_0, theta_pi, theta_Q) - bb(E)[cal(G)(bold(tau)) | s_0, a_0; theta_pi])^2 = 0 $ #pause

Minimize over neural network parameters #pause

$ argmin_(theta_Q) [(Q(s_0, a_0, theta_pi, theta_Q) - bb(E)[cal(G)(bold(tau)) | s_0, a_0; theta_pi])^2 ] $ #pause

*Question:* Missing anything? #pause Hint: Other loss functions have sums? #pause

Minimize over all states and actions #pause

$ argmin_(theta_Q) [ sum_(s_0 in S) sum_(a_0 in A) (Q(s_0, a_0, theta_pi, theta_Q) - bb(E)[cal(G)(bold(tau)) | s_0, a_0; theta_pi])^2 ] $

==
$ argmin_(theta_Q) [ sum_(s_0 in S) sum_(a_0 in A) (Q(s_0, a_0, theta_pi, theta_Q) - bb(E)[cal(G)(bold(tau)) | s_0, a_0; theta_pi])^2 ] $ #pause

Need to replace $bb(E)[cal(G)(bold(tau)) | s_0, a_0; theta_pi]$ #pause

*Question:* What are the two methods to compute $bb(E)[cal(G)(bold(tau)) | s_0, a_0; theta_pi]$? #pause

*Answer:* Monte Carlo and Temporal Difference


==

*Monte Carlo Objective:*
$ argmin_(theta_Q) [ sum_(s_0 in S) sum_(a_0 in A) (Q(s_0, a_0, theta_pi, theta_Q) -  sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0; theta_pi] )^2 ]  $

*Temporal Difference Objective:* 
$ &argmin_(theta_Q) [ sum_(s_0 in S) sum_(a_0 in A) \ &(Q(s_0, a_0, theta_pi, theta_Q) - ( bb(E)[cal(R)(s_1) | s_0, a_0] + not d gamma max_(a in A) Q(s_1, a, theta_pi, theta_Q)))^2 ] $

==
#only("1-3")[
$ argmin_(theta_Q) [ sum_(s_0 in S) sum_(a_0 in A) (Q(s_0, a_0, theta_pi, theta_Q) -  sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0; theta_pi] )^2 ]  $

$ &argmin_(theta_Q) [ sum_(s_0 in S) sum_(a_0 in A) \ &(Q(s_0, a_0, theta_pi, theta_Q) - ( bb(E)[cal(R)(s_1) | s_0, a_0] + not d gamma max_(a in A) Q(s_1, a, theta_pi, theta_Q)))^2 ] $ 
]
#only(4)[
$ argmin_(theta_Q) [ sum_(s_0 in S) sum_(a_0 in A) (Q(s_0, a_0, theta_pi, theta_Q) -  sum_(t=0)^oo gamma^t #redm[$hat(bb(E))$] [cal(R)(s_(t+1)) | s_0, a_0; theta_pi] )^2 ]  $

$ &argmin_(theta_Q) [ sum_(s_0 in S) sum_(a_0 in A) \ &(Q(s_0, a_0, theta_pi, theta_Q) - ( #redm[$hat(bb(E))$] [cal(R)(s_1) | s_0, a_0] + not d gamma max_(a in A) Q(s_1, a, theta_pi, theta_Q)))^2 ] $ 
]

#only((2,3,4))[Still have expectations, which we do not know]

#only((3,4))[*Question:* What can we do?]

==

$ argmin_(theta_Q) [ sum_(s_0 in S) sum_(a_0 in A) (Q(s_0, a_0, theta_pi, theta_Q) -  sum_(t=0)^oo gamma^t hat(bb(E)) [cal(R)(s_(t+1)) | s_0, a_0; theta_pi] )^2 ]  $

$ &argmin_(theta_Q) [ sum_(s_0 in S) sum_(a_0 in A) \ 
&(#pin(1)Q(s_0, a_0, theta_pi, theta_Q)#pin(2) - ( hat(bb(E)) [cal(R)(s_1) | s_0, a_0] + not d gamma #pin(3)max_(a in A) Q(s_1, a, theta_pi, theta_Q)#pin(4)))^2 ] $ #pause

*Question:* Which is harder to optimize? #pause

*Answer:* Temporal difference #pause

#pinit-highlight(1, 2)
#pinit-highlight(3, 4)

==

Rewrite as loss functions to help with implementation #pause

The Monte Carlo loss uses an episode of states, actions, and rewards #pause

$ argmin_(bold(theta)_Q) cal(L)(bold(x), bold(theta)_Q) = argmin_(theta_Q) [ sum_(s_i, a_i, r_i in bold(x)) (Q(s_i, a_i, theta_pi, theta_Q) -  sum_(t=i)^oo gamma^t r_t )^2 ] $ #pause

Can train over batch or dataset containing many episodes #pause

$ argmin_(bold(theta)_Q) cal(L)(bold(X), bold(theta)_Q) =  argmin_(theta_Q) [ sum_(bold(x) in bold(X)) sum_(s_i, a_i, r_i  in bold(x)) (Q(s_i, a_i, theta_pi, theta_Q) -  sum_(t=i)^oo gamma^t r_t )^2 ]  $

==
Now write TD loss function #pause

$ argmin_(bold(theta)_Q) cal(L)(bold(x), bold(theta)_Q) = argmin_(theta_Q) \  sum_(s_i, a_i, r_i, s_(i+1) \ in bold(x)) (Q(s_i, a_i, theta_pi, theta_Q) - ( r_t + not d gamma argmax_(a in A) Q(s_i, a, theta_pi, theta_Q) ))^2  $ #pause

$ argmin_(bold(theta)_Q) cal(L)(bold(X), bold(theta)_Q) = argmin_(theta_Q) \ sum_(bold(x) in bold(X)) sum_(s_i, a_i, r_i, s_(i+1) \ in bold(x)) (Q(s_i, a_i, theta_pi, theta_Q) - ( r_t + not d gamma argmax_(a in A) Q(s_i, a, theta_pi, theta_Q) ))^2  $

==

To summarize, our two loss functions: #pause

$ argmin_(bold(theta)_Q) cal(L)(bold(X), bold(theta)_Q) =  argmin_(theta_Q) [ sum_(bold(x) in bold(X)) sum_(s_i, a_i, r_i  in bold(x)) (Q(s_i, a_i, theta_pi, theta_Q) -  sum_(t=i)^oo gamma^t r_t )^2 ] $ #pause

$ argmin_(bold(theta)_Q) cal(L)(bold(X), bold(theta)_Q) = argmin_(theta_Q) \ sum_(bold(x) in bold(X)) sum_(s_i, a_i, r_i, s_(i+1) \ in bold(x)) (Q(s_i, a_i, theta_pi, theta_Q) - ( r_t + not d gamma argmax_(a in A) Q(s_i, a, theta_pi, theta_Q) ))^2  $

==

Can optimize both loss functions using gradient descent #pause

RL optimization is more difficult than supervised learning #pause

#side-by-side[
  *Supervised Learning:*
  - Static inputs
  - Static labels
  - Limited dataset
    - Human can clean
    - Bad to overfit
][
  *Reinforcement Learning:*
  - Inputs change as $theta_pi$ changes
    - Visit new/different states
  - Labels change as $theta_pi$ changes 
    - $bb(E)[cal(G)(bold(tau)) | theta_pi]$
  - Infinite dataset
    - Can always collect from env
    - Bad $theta_pi$ means bad dataset
    - Overfitting no problem
]

= Experience Replay
==
Optimization is difficult in RL #pause

Most RL papers train for 10M-10B environment steps #pause

It takes a long time to train a deep Q function #pause

Let us see if we can improve training speed

==
```python
for epoch in range(num_epochs):
  terminated = False
  s = env.reset()
  episode = []
  # Step between 1 and infinity times to get one episode
  while not terminated:
    a = policy(s, theta_Q)
    next_s, r, d = env.step(action)
    episode.append([s, a, r, d, next_s])
  # Compute gradient over episode
  J = grad(L)(theta_Q, episode)
  theta_Q = update(theta_Q, grad)
``` #pause

*Question:* Which part is slowest? #pause *Answer:* Collecting episodes

==
```python
for epoch in range(num_epochs):
  terminated = False
  s = env.reset()
  episode = []
  # Step between 1 and infinity times to get one episode
  while not terminated:
    a = policy(s, theta_Q)
    next_s, r, d = env.step(action)
    episode.append([s, a, r, d, next_s])
  # Compute gradient over episode
  J = grad(L)(theta_Q, episode)
  theta_Q = update(theta_Q, grad)
``` #pause

Collect episode, train, throw away episode, start again

==
What if we reuse episodes? #pause
 
```python
episodes = []
for epoch in range(num_epochs):
  terminated = False
  s = env.reset()
  episode = []
  while not terminated:
    a = policy(s, theta_Q)
    next_s, r, d = env.step(action)
    episode.append([s, a, r, d, next_s])
  episodes.append(episode)
  J = grad(L)(theta_Q, episodes) # Train over ALL episodes
  theta_Q = update(theta_Q, grad)
``` 

==
When we reuse episodes, we call it *experience replay* #pause

#side-by-side[
  Store episodes in a *replay buffer* (list) #pause
][
$ bold(B)_t = mat(
  bold(s)_1, bold(a)_1, bold(r)_1, bold(d)_1;
  dots.v, dots.v, dots.v, dots.v;
  bold(s)_t, bold(a)_t, bold(r)_t, bold(d)_t
) 
$
] #pause


#side-by-side[
  Create a dataset from the buffer #pause
][
$ bold(X)_t = mat(
  bold(s)_31, bold(a)_31, bold(r)_31, bold(d)_31;
  dots.v, dots.v, dots.v, dots.v;
  bold(s)_4, bold(a)_4, bold(r)_4, bold(d)_4
)  $ 
] #pause

#side-by-side[
  Train on the dataset #pause
][
  $ argmin_(bold(theta)_Q) cal(L)(bold(X)_t, bold(theta)_Q) $
] #pause

Humans do experience replay when they dream!


==
*On-policy* algorithms must throw away episodes after training #pause

Must collect data using the current policy, cannot use experience replay #pause

*Off-policy* algorithms can reuse old episodes and use experience replay #pause

In fact, for off policy algorithms, data can come from anywhere #pause
- Previous policy #pause
- Previous training run #pause
- Human policy #pause

*Question:* Which is Q learning? #pause 

Let us find out!

==
Start with the Monte Carlo return #pause

$ argmin_(theta_Q) [ sum_(s_0 in S) sum_(a_0 in A) (Q(s_0, a_0, theta_pi, theta_Q) -  sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0; #pin(1)theta_pi#pin(2)] )^2 ] $ #pause

*Question:* On-policy or off-policy? #pause *Answer:* On-policy. Why? #pause

#pinit-highlight(1, 2)

Our return is conditioned on the policy #pause

If the policy changes, the return $r_0 + gamma r_1 + gamma^2 r_2 + dots $ is not valid! #pause

Old episode gives us $bb(E)[cal(R)(s_(t+1)) | s_0, a_0; theta_("old")]$  #pause

We need $bb(E)[cal(R)(s_(t+1)) | s_0, a_0; theta_pi]$

==
What about TD return? #pause

$ &argmin_(theta_Q) [ sum_(s_0 in S) sum_(a_0 in A) \ &(Q(s_0, a_0, theta_pi, theta_Q) - ( bb(E)[cal(R)(s_1) | s_0, a_0] + not d gamma max_(a in A) Q(s_1, a, #pin(1)theta_pi#pin(2), theta_Q)))^2 ] $ #pause

*Question:* On-policy or off-policy? #pause *Answer:* Off-policy. Why? #pause

#pinit-highlight(1, 2) #pause

Q function depends on $theta_pi$, but reward does not!

Do we know $argmax_(a in A) Q(s_1, a, #pin(1)theta_pi#pin(2), theta_Q)$? #pause Yes! Just plug in $s_1$

==

To summarize: #pause

Monte Carlo Q learning is on-policy #pause

Cannot reuse data, takes a long time to train #pause

Temporal Difference Q learning is special! #pause

It is off-policy, can reuse data and train faster #pause

TD is not always better than MC #pause

MC needs more training data, but TD has harder optimization

= Target Networks
==
If you train a deep Q network using TD, you will find

$ Q(s_0, a_0, theta_pi, theta_Q) = oo $ #pause

$ (Q(s_0, a_0, theta_pi, theta_Q) - ( bb(E)[cal(R)(s_1) | s_0, a_0] + not d gamma max_(a in A) Q(s_1, a, #pin(1)theta_pi#pin(2), theta_Q)))^2 $ #pause

*Question:* Can you see why? #pause Hint: What if $s_0 approx s_1$? #pause

$ Q(s_0, a_0, theta_pi, theta_Q) = r_0 + max_(a in A) Q(s_0, a_0, theta_pi, theta_Q) $ #pause

*Question:* If $r_0 = 1$, what happens? #pause

$ Q_(i+1) = 1 + Q_i #pause quad quad lim_(i -> oo) ? $

==
It is difficult to train deep neural networks recursively #pause

The label depends on the function we train! #pause

$ (Q(s_0, a_0, theta_pi, theta_Q) - ( bb(E)[cal(R)(s_1) | s_0, a_0] + not d gamma max_(a in A) Q(s_1, a, #pin(1)theta_pi#pin(2), theta_Q)))^2 $ #pause

We use *target networks* to break this dependence #pause

$ (Q(s_0, a_0, theta_pi, theta_Q) - ( bb(E)[cal(R)(s_1) | s_0, a_0] + not d gamma max_(a in A) Q(s_1, a, #pin(1)theta_pi#pin(2), theta_#redm[$T$])))^2 $ 

==
Usually, the target parameters are older parameters

```python
theta_Q = ... # Initialize parameters
theta_T = theta_Q.copy()

for epoch in range(num_epochs):
  grad = grad(L)(theta_Q, theta_T, X)
  theta_Q = optimizer.update(theta_Q, grad)
  if epoch % 200 == 0:
    # Update target parameters
    theta_T = theta_Q.copy()
```






// Objective function
// Difference between off and on policy
// MC return is on-policy
  // As policy changes, old rewards become stale
  // TD0 return only considers next reward, (do example)
  // Why choose MC over TD0?
    // Deadly triad 
// Eligibility trace

= Deep Q Networks
// Discuss paper
// Tricks to make deep TD work
// Value overestimation
// Target networks
// Action output dim
// Architectures
// Replay buffer
// CPU/compute

==
Deep reinforcement learning was first discovered in the 1980s #pause

However, it did not work very well and could only solve simple tasks #pause

Deep Q Networks (DQN) was the first big achievement of deep RL #footnote[Human-level control through deep reinforcement learning. _Nature._ 2014.] #pause

They achieved human performance on many Atari games #pause

The paper introduced many tricks to make deep Q learning work #pause

Today, we will review these tricks

==
- Compute #pause
- Model architecture #pause
- Replay buffer #pause
- Target networks

= DQN: Compute
==
Perhaps the most important part of DQN is compute #pause

In 2014, GPUs were not popular for deep learning #pause

They used multiple GPUs to train in the DQN paper #pause

We see this very often in deep learning #pause

Add more compute, and find interesting results #pause

http://www.incompleteideas.net/IncIdeas/BitterLesson.html #pause

We will see that many decisions in DQN focus on efficiency

= DQN: Architecture
// CNN + MLP
// Is markov? 
// Frame stacking

==
We must understand the problem before the model architecture #pause

The authors design the architecture to solve the problem #pause

The Atari video game system has 57 games #pause

Each game has a resolution of $160 times 192$ pixels and up to 18 actions #pause

$ S = bb(Z)_(0: 255)^(160 times 192 times 3), A = {"left", "up left", dots}, quad |A| = 18 $

*Question:* How many possible states? #pause $256 times 160 times 192 times 3 approx 23M $

*Question:* Size of Q matrix? #pause  $23M times 18 approx 500M $

Too big for a Q value matrix! Use deep neural network instead

==
*Question:* What neural network should we use for images? #pause

*Answer:* Convolutional network! #pause

#cimage("fig/07/cnn.png")

==
We are moving too quickly! #pause *Question:* Is the state space Markov? #pause

#cimage("fig/07/framestack-0.png", height: 85%)

==

*Question:* Which way is the ball moving?

#cimage("fig/07/framestack-0.png", height: 85%)

==

*Question:* Which way is the ball moving?

#cimage("fig/07/framestack.png", height: 85%)

==
#cimage("fig/07/framestack.png", height: 85%)

Not Markov, velocity! $Tr(s_(t+1) | s_t, a_t) != Tr(s_(t+1) | s_t, a_t, s_(t-1), a_(t-1))$

==
State must contain velocity for Markov property! #pause

The authors use last four images as the state #pause

$ S = bb(Z)_(0: 255)^(4 times 160 times 192 times 3) $ #pause

Neural network can infer velocity from multiple images


==
Normally, the Q function takes action as input #pause

$ Q: S times A times Theta_pi times Theta_Q |-> bb(R) $ #pause

//$ Q(s, a, theta_pi, theta_Q) $ #pause

Then, we run $Q$ for all actions #pause

$ a = argmax_i vec(
  Q(s, a=1, theta_pi, theta_Q),
  Q(s, a=2, theta_pi, theta_Q),
  dots.v,
  Q(s, a=i, theta_pi, theta_Q),
 ) $ #pause

For each action, we must execute $Q$ network $|A|$ times. Not efficient!

==

$ Q: S times A times Theta_pi times Theta_Q |-> bb(R) $ #pause

In DQN, the authors estimate all $Q$ at once #pause

$ Q: S times Theta_pi times Theta_Q |-> bb(R)^(|A|) $ #pause

The neural network outputs $|A|$ values -- one for each action #pause

$ a = argmax_i Q(s, theta_pi, theta_Q)_i $ #pause

This is $|A|$ times faster!

==

#cimage("fig/07/dqn-arch.jpg")


= DQN: Experience Replay
==
// Sample efficiency
// Can forget other trajectories
// On policy and off policy
// Future return relies on theta for MC
// Not the case for TD next reward only relies on taken action

The joint state action space is very large #pause

Need hundreds of billions of samples to learn #pause

Atari is slow and collecting this many samples is impossible #pause



= DQN: Target Networks




= Modern Deep Q Learning
// Exploration vs exploitation
  // Boltzmann policy
// PER?
// Polyak updates
// Regularization
// Distributional Q learning
// PQN
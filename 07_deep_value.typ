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
Neural networks consist of *artificial neurons*

$ bold(x) in bb(R)^(d_x), bold(theta) in bb(R)^(d_x + 1) $

$ f(bold(x), bold(theta)) = sigma(bold(theta)^top overline(bold(x))) = sigma(theta_0 + sum_(i=1)^(d_x) theta_i dot x_i) $ #pause

#side-by-side[
  $sigma$ is a nonlinearity like sigmoid
][
  $ sigma(x) = 1 / (1 + e^(-x)) $
]

#side-by-side[
  Or ReLU
][
  $ sigma(x) = max(0, x) $
]

==
We combine individual neurons into a *layer*

  $ f: bb(R)^(d_x) times Theta |-> bb(R) $ 
  
  $ Theta in bb(R)^(d_x + 1) $ #pause

  $d_y$ neurons (wide):

  $ f: bb(R)^(d_x) times Theta |-> bb(R)^(d_y) $ 
  
  $ Theta in bb(R)^((d_x + 1) times d_y) $

==
#side-by-side[For a single neuron][
  $ f(vec(x_1, dots.v, x_(d_x)), vec(theta_0,  theta_1, dots.v, theta_(d_x)) ) = sigma(sum_(i=0)^(d_x) theta_i overline(x)_i) $ 

]

For a wide network

$ f(vec(x_1, x_2, dots.v, x_(d_x)), mat(theta_(0,1), theta_(0,2), dots, theta_(0,d_y); theta_(1,1), theta_(1,2), dots, theta_(1, d_y); dots.v, dots.v, dots.down, dots.v; theta_(d_x, 1), theta_(d_x, 2), dots, theta_(d_x, d_y)) ) = vec(
  sigma(sum_(i=0)^(d_x) theta_(i,1) overline(x)_i ),
  sigma(sum_(i=0)^(d_x) theta_(i,2) overline(x)_i ),
  dots.v,
  sigma(sum_(i=0)^(d_x) theta_(i,d_y) overline(x)_i ),
)
  $  

==

We can combine layers to create a *deep* neural network

  A wide network:

  $ f(bold(x), bold(theta)) = sigma(bold(theta)^top overline(bold(x))) $ 

  A deep network has many internal functions

    $ f_1(bold(x), bold(phi)) = sigma(bold(phi)^top overline(bold(x))) quad

    f_2(bold(x), bold(psi)) = sigma(bold(psi)^top overline(bold(x))) quad

    dots quad

    f_(ell)(bold(x), bold(xi)) = sigma(bold(xi)^top overline(bold(x))) $ 


  $ f(bold(x), bold(theta)) = f_(ell) (dots f_2(f_1(bold(x), bold(phi)), bold(psi)) dots bold(xi) ) $


==

  Written another way

  $ bold(z)_1 = f_1(bold(x), bold(phi)) = sigma(bold(phi)^top overline(bold(x))) $ 
  $ bold(z)_2 = f_2(bold(z_1), bold(psi)) = sigma(bold(psi)^top overline(bold(z))_1) $
  $ dots.v $ 
  $ bold(y) = f_(ell)(bold(x), bold(xi)) = sigma(bold(xi)^top overline(bold(z))_(ell - 1)) $ 

  We call each function a *layer* #pause

  A deep neural network is made of many layers

==
  What functions can we represent using a deep neural network? #pause

  A deep neural network is a *universal function approximator* #pause

  It can approximate *any* continuous function $g(x)$ to precision $eta$ #pause

  $ | g(bold(x)) - f(bold(x), bold(theta)) | < eta $ #pause

  Making the network deeper or wider decreases $eta$ #pause

  #align(center)[#underline[Very powerful finding! The basis of deep learning.]] 








= Deep Return Approximation
==
After the homework and last lecture, you are experts in Q learning

You quickly trained a Q function to solve a task

Why introduce deep learning to Q learning?

Consider an example problem

==
*Example:* Learn a policy to pick up trash and put it in the bin

#cimage("fig/07/binrobot.png", height: 70%)

==
*Question:* What is $S$?

- Camera image $bb(R)^(256 times 256 times 3)$
- Lidar scan $bb(R)_+^(4096)$
- Arm position $[0, 1]^3$
- Map position $[0, 1]^2$
- Trash position $[0, 1]^(2k)$

In the assignment, we store Q value for each state in a matrix

*Question:* What is the size of the matrix?

$ S times A $ #pause 

==
Let us consider a simplification, only have the map position

$ S in [0, 1]^2 $

*Question:* What is the size of our Q matrix?

*Answer:* There are infinitely many numbers between 0 and 1

$ 0.01, 0.001, 0 dots 1 $

The state space is infinite, our Q value matrix is inifinitely big

*Question:* What can we do?

*Answer:* Discretize the space

==

$ S in [0, 1]^2 $

Discretize to $128 times 128$ grid squares

$ S in {1, dots, 128}^2 $

*Question:* What is the size of the Q matrix?

$ 16384 times A $

Very large but not infinite

==
#let graph = tiling(size: (2cm, 2cm))[
  #place(line(start: (0%, 0%), end: (0%, 100%)))
  #place(line(start: (0%, 0%), end: (100%, 0%)))
]

#rect(fill: graph, width: 100%, height: 50%)

We must update each element separately

With TD updates, updating one cell means we must update all cells

==
With TD updates, updating one cell means we must update all cells

Convergence takes at least this many samples

$ ( |S| |A| ) / ((1 - gamma)^5 dot epsilon^2) $

Assume $gamma = 0.99, epsilon = 0.1$

$ (16348 | A |) / ((0.01)^5 dot 0.1^2) approx 1.6 times 10^16 $

This is the *minimum* number of samples required


==
Simple Q learning works very well when the state space is small

We need a solution for infinite/continuous/large state spaces

We need a Q function that generalizes to new states

#let graph = tiling(size: (2cm, 2cm))[
  #place(line(start: (0%, 0%), end: (0%, 100%)))
  #place(line(start: (0%, 0%), end: (100%, 0%)))
]

#rect(fill: graph, width: 100%, height: 50%)

==

Prior work shows deep learning can generalize well TODO CITE

Can approximate any function with a deep neural network

So we can model the Q function using a deep neural network

Just because parameters exist, does not mean we can find them

There is *no guarantee* we will find parameters for the Q function

But we will try!


==
// Proof of simple convergence
  // Contraction mapping
  // Nonlinear, we no longer have guarantees
  // Similar to DL course, now we are in magic land
  // Deadly triad


==
First, define the Q function as a deep neural network

$ Q: S times A times Theta_pi times Theta_Q |-> bb(R) $

#v(2em)

$ Q(s, a, #pin(1)theta_pi#pin(2), #pin(3)theta_Q#pin(4)) $

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: top, height: 1.2em)[Policy parameters] 

#pinit-highlight-equation-from((3,4), (3,4), fill: blue, pos: bottom)[Neural network parameters] 

==
The Q function estimates the policy-conditioned discounted return

$ Q(s_0, a_0, theta_pi, theta_Q) = bb(E)[cal(G)(bold(tau)) | s_0, a_0; theta_pi] 
$

Turn this into optimization objective

Move everything to left

$ Q(s_0, a_0, theta_pi, theta_Q) - bb(E)[cal(G)(bold(tau)) | s_0, a_0; theta_pi] = 0 
$

Use a distance measure so we can minimize, choose square error 
$ (Q(s_0, a_0, theta_pi, theta_Q) - bb(E)[cal(G)(bold(tau)) | s_0, a_0; theta_pi])^2 = 0 
$

==
$ (Q(s_0, a_0, theta_pi, theta_Q) - bb(E)[cal(G)(bold(tau)) | s_0, a_0; theta_pi])^2 = 0 $

Minimize over neural network parameters

$ argmin_(theta_Q) [(Q(s_0, a_0, theta_pi, theta_Q) - bb(E)[cal(G)(bold(tau)) | s_0, a_0; theta_pi])^2 ] $

*Question:* Missing anything? Hint: what is the dataset?

Minimize over all states and actions

$ argmin_(theta_Q) [ sum_(s_0 in S) sum_(a_0 in A) (Q(s_0, a_0, theta_pi, theta_Q) - bb(E)[cal(G)(bold(tau)) | s_0, a_0; theta_pi])^2 ] $


==
*Question:* What are the two methods to compute $bb(E)[cal(G)(bold(tau)) | s_0, a_0; theta_pi]$?

*Answer:* Monte Carlo and Temporal Difference

==

*Monte Carlo Objective:*
$ argmin_(theta_Q) [ sum_(s_0 in S) sum_(a_0 in A) (Q(s_0, a_0, theta_pi, theta_Q) -  sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0; theta_pi] )^2 ]  $

*Temporal Difference Objective:* 
$ &argmin_(theta_Q) [ sum_(s_0 in S) sum_(a_0 in A) \ &(Q(s_0, a_0, theta_pi, theta_Q) - ( bb(E)[cal(R)(s_1) | s_0, a_0; theta_pi] + gamma max_(a in A) Q(s_1, a, theta_pi, theta_Q)))^2 ] $

==

$ argmin_(theta_Q) [ sum_(s_0 in S) sum_(a_0 in A) (Q(s_0, a_0, theta_pi, theta_Q) -  sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0; theta_pi] )^2 ]  $

$ &argmin_(theta_Q) [ sum_(s_0 in S) sum_(a_0 in A) \ 
&(#pin(1)Q(s_0, a_0, theta_pi, theta_Q)#pin(2) - ( bb(E)[cal(R)(s_1) | s_0, a_0; theta_pi] + gamma #pin(3)max_(a in A) Q(s_1, a, theta_pi, theta_Q)#pin(4)))^2 ] $

*Question:* Which is harder to optimize?

*Answer:* Temporal difference

#pinit-highlight(1, 2)
#pinit-highlight(3, 4)

==
RL optimization is more difficult than supervised learning

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
    - $pi_theta$ collects dataset
    - Can always collect from env
    - Overfitting no problem
]



// Objective function
// Difference between off and on policy
// MC return is on-policy
  // As policy changes, old rewards become stale
  // TD0 return only considers next reward, (do example)
  // Why choose MC over TD0?
    // Deadly triad 
// Eligibility trace

= Deep Q Learning
// Discuss paper
// Tricks to make deep TD work
// Value overestimation
// Target networks
// Action output dim
// Architectures
// Replay buffer
// CPU/compute

==
Deep reinforcement learning was first discovered in the 1980s

However, it did not work very well and could only solve simple tasks

Deep Q learning was the first big feat of deep RL #footnote[Human-level control through deep reinforcement learning. _Nature._]

They achieved superhuman performance on many Atari games

The paper introduced many tricks to make deep Q learning work

Today, we will review these tricks

==
- Compute
- Model architecture
- Replay buffer
- Target networks



= Modern Deep Q Learning
// Exploration vs exploitation
  // Boltzmann policy
// PER?
// Polyak updates
// Regularization
// Distributional Q learning
// PQN
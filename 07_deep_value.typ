#import "@preview/algorithmic:1.0.6"
#import algorithmic: style-algorithm, algorithm-figure, algorithm
#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "common.typ": *
#import "@preview/cetz:0.3.2"
#import "@preview/fletcher:0.5.5" as fletcher: diagram, node, edge
#import "@preview/pinit:0.2.2": *

#set math.vec(delim: "[")
#set math.mat(delim: "[")

// TODO: In equations, introduce Q - y, where y is label instead of single equation
    // Draws parallels to supervised learning

// TODO 2026: Add formal definition slide for MC and TD DQN

// TODO 2026: Remove square indices

#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Deep Q Learning],
    subtitle: [CISC 7404 - Decision Making],
    author: [Steven Morad],
    institution: [University of Macau],
    logo: image("fig/common/bolt-logo.png", width: 4cm)
  ),
  //config-common(handout: true),
  header-right: none,
  header: self => utils.display-current-heading(level: 1)
)

#let sgd =  algorithm(
  line-numbers: false,
  {
    import algorithmic: *
    Procedure(
      "Gradient Descent",
      ($bold(X)$, $bold(Y)$, $cal(L)$, $t$, $alpha$),
      {
        Assign[$bold(theta)$][Random()]
        For(
          $i in {1 dots t}$,
          {
            Comment[Compute the gradient of the loss]        
            Assign[$bold(J)$][$(gradient_bold(theta) cal(L))(bold(X), bold(Y), bold(theta))$]
            Comment[Update the parameters using the negative gradient]
            Assign[$bold(theta)$][$bold(theta) - alpha dot bold(J)$]
          },
        )
        Return[$bold(theta)$]
      },
    )
  }
)

#title-slide()

== Outline <touying:hidden>

#components.adaptive-columns(
    outline(title: none, indent: 1em, depth: 1)
)


= Admin
== 
Final project group choice due next week (15 March) #pause
- Find a group of 3-5 people #pause
  - Cannot be more, cannot be less #pause
- Submit your group on Moodle
==
Homework for this course is different from the Deep Learning course #pause
- All 3 homeworks based on 3 consecutive lectures #pause
- Last lecture
- This lecture
- Next lecture #pause

All RL is based on two algorithms: #pause
- Q learning (last lecture, this lecture) #pause
- Policy gradient (next lecture) #pause

If you understand Q learning and policy gradient, learning other algorithms is very easy 

==

Difficult to choose good due dates #pause
- Both assignments due 04.19 #pause
- Finishing assignments early will help you with all future lectures #pause
- Assignments are more difficult than deep learning #pause
  - Takes longer to train #pause
  - May need hyperparameter tuning #pause
  - If you start on the last day, you cannot finish both assignments


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
We model neural networks as parameterized functions #pause

$ f: X times Theta |-> Y $ #pause

Map an input $bold(x) in X$ and parameters $bold(theta) in Theta$ to output space $Y$ #pause
 
$ f(bold(x), bold(theta)) $

==
Neural networks consist of *artificial neurons* #pause

$ bold(x) in bb(R)^(d_x), bold(theta) in bb(R)^(d_x + 1) $ #pause

$ overline(bold(x)) = mat(1, x_1, x_2, dots, x_(d_x))^top in bb(R)^(d_x + 1) $ #pause

$ f(bold(x), bold(theta)) = sigma(bold(theta)^top overline(bold(x))) = sigma(sum_(i=0)^(d_x) theta_i dot x_i) $ #pause

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

  Layer of $d_y$ neurons: #pause

  $ f: bb(R)^(d_x) times Theta |-> bb(R)^(d_y) $ #pause
  
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
  $ bold(y) = f_(ell)(bold(z)_(ell - 1), bold(xi)) = sigma(bold(xi)^top overline(bold(z))_(ell - 1)) $ #pause

  We call each function a *layer* #pause

  A deep neural network is made of many layers

==
We can create different models for different tasks #pause
- Standard tasks: #pause Multi-layer perceptron (MLP) #pause
- Image tasks: #pause Convolutional neural network (CNN) #pause
- Temporal tasks: #pause Recurrent neural network (RNN) #pause
- Image, temporal tasks: Transformer

==
  What functions can we represent using deep neural networks? #pause
    - Any continuous function in a closed interval #pause

  It can approximate any continuous function $g(x)$ to precision $eta$ #pause

  $ | g(bold(x)) - f(bold(x), bold(theta)) | < eta $ #pause

  Making the network deeper or wider decreases $eta$ #pause

  #align(center)[#underline[Very powerful finding! The basis of deep learning.]] #pause

  Although such $bold(theta)$ exists, it can be hard to find
==

Finding $bold(theta)$ is an optimization problem #pause
- We optimize (minimize) a *loss function* #pause

$ cal(L): X times Y times Theta |-> bb(R) $ #pause

$ argmin_(bold(theta)) cal(L)(bold(x), bold(y), bold(theta)) $ #pause

Loss function measures the error between $f(bold(x), bold(theta))$ and desired $g(bold(x)) = bold(y)$ #pause
- In this class, we build loss functions from two error functions

==

*Square error:* The squared distance over a dataset of size $n$ #pause

$ sum_(i=1)^n sum_(j=1)^d_y (f(bold(x)_(i), bold(theta))_j - g(bold(x))_j)^2 = sum_(i=1)^n sum_(j=1)^d_y (f(bold(x)_(i), bold(theta))_j - y_(i, j))^2 $ #pause

*Cross entropy error:* The categorical error over a dataset of size $n$ #pause

#text(size: 23pt)[
$ - sum_(i=1)^n sum_(j=1)^(d_y) P(g(bold(x)_(i))_j | bold(x)_i) log f(bold(x)_i, bold(theta))_j 
 = - sum_(i=1)^n sum_(j=1)^(d_y) P(y_(i, j) | bold(x)_i) log f(bold(x)_i, bold(theta))_j  $
]
==
#side-by-side(align: horizon)[*Square error:*][
  $ sum_(i=1)^n sum_(j=1)^d_y (f(bold(x)_(i), bold(theta))_j - y_(i, j))^2 $ #pause
] 

#side-by-side(align: horizon)[*Cross entropy error:*][
$ - sum_(i=1)^n sum_(j=1)^(d_y) P(y_(i, j) | bold(x)_i) log f(bold(x)_i, bold(theta))_j  $

] #pause

*Question:* Which one will we use for deep Q learning? #pause

*Answer:* Predict a scalar (expected return), so square error (regression)

==
We can use both errors in a loss function #pause

$ cal(L)(bold(X), bold(Y), bold(theta)) = sum_(i=1)^n sum_(j=1)^d_y (f(bold(x)_(i), bold(theta))_j - y_(i, j))^2 $ #pause

$ cal(L)(bold(X), bold(Y), bold(theta)) = - sum_(i=1)^n sum_(j=1)^(d_y) P(y_(i, j) | bold(x)_i) log f(bold(x)_i, bold(theta))_j  $

==

When we train a neural network, we search $Theta$ for $bold(theta)$ that minimize $cal(L)$ #pause

$ argmin_bold(theta) cal(L)(bold(X), bold(Y), bold(theta)) = argmin_bold(theta) sum_(i=1)^n sum_(j=1)^d_y (f(bold(x)_(i), bold(theta))_j - y_(i, j))^2 $ #pause

$ argmin_bold(theta) cal(L)(bold(X), bold(Y), bold(theta)) = argmin_bold(theta) - sum_(i=1)^n sum_(j=1)^(d_y) P(y_(i, j) | bold(x)_[i]) log f(bold(x)_i, bold(theta))_j  $

==

*Question:* Which search method do we typically use? #pause

*Answer:* Gradient-based methods (gradient descent, Adam, etc) #pause

This is an iterative process #pause
- Evaluate the loss at some point $bold(X), bold(Y), bold(theta)$ #pause
- Update $bold(theta)$ by some small learning rate $alpha$ #pause

$ bold(theta)_(t+1) = bold(theta)_t - alpha dot (nabla_bold(theta)_t cal(L)) (bold(X), bold(Y), bold(theta)_t) $

==


#side-by-side[
   #cimage("fig/07/parameter_space.png", height: 70%) #pause
][
  #cimage("fig/07/hiking_slope.jpg", height: 70%)

]


==
#sgd

/*
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
})
*/

==
We can put it all together in jax and equinox

```python
from jax import random
from equinox import nn

seed = random.key(0)
key, *net_keys= random.split(seed, 4)
net = nn.Sequential([
  nn.Linear(d_x, d_h, key=net_keys[0]), 
  nn.Lambda(jax.nn.relu),
  nn.Linear(d_h, d_h, key=net_keys[1]), 
  nn.Lambda(jax.nn.relu),
  nn.Linear(d_h, d_y, key=net_keys[2]), 
])
```

==
We can extract parameters using `eqx.partition` #pause
- This is for RL, we do not use it in deep learning #pause

```python
import equinox as eqx
# Get all arrays (parameters) in the network
theta, f = eqx.partition(net, eqx.is_array)
# Add one to every parameter
theta = jax.tree.map(theta, lambda x: x + 1)
# Put the new parameters back into network
net = eqx.combine(theta, f)

```

==
```python
import jax.numpy as jnp
import equinox as eqx

def L_square(net, x, y):
  # vmap applies network to batch of data
  prediction = eqx.filter_vmap(net)(x)
  return ((prediction - y) ** 2).mean()

def L_cross_entropy(net, x, y):
  # Net outputs probabilities 
  # And y is one-hot, e.g. [0, 0, 1, 0]
  prediction = eqx.filter_vmap(net)(x)
  return -(y * jnp.log(prediction)).sum(-1).mean()
```

==
```python
import optax
import equinox as eqx
opt = optax.adam(learning_rate=3e-4)
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
def train_one_batch(net, batch, opt_state):
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
*Dirty secret of deep learning:* #pause We do not understand deep learning #pause
- For complex neural networks, deep learning is a *science* not *math* #pause
- No accepted theory for why deep neural networks are so effective #pause

This applies even more to *deep reinforcement learning* #pause
- Something that should work does not work #pause
- Something that works should not work #pause
- We have no idea why (need more research!)

= Motivation 
==
After the last lecture, you understand Q learning #pause

*Question:* Why introduce deep learning to Q learning? #pause

It is easier to learn $Q$ without a neural network #pause
- Easy to debug, simpler algorithms, strong convergence guarantees #pause

It is a problem of *scale* #pause
- Deep RL can solve much bigger problems than normal RL #pause

Let me demonstrate this with an example problem

==
*Example:* Learn a policy to collect trash on UM campus #pause

#cimage("fig/07/binrobot.png", height: 70%)

==
*Question:* What is $S$? #pause

- Camera image $[0, 1]^(256 times 256 times 3)$ #pause
- Lidar scan $bb(R)_+^(4096)$ #pause
- Arm position $[0, 1]^3$ #pause
- Map position $[0, 1]^2$ #pause
- Trash position $[0, 1]^(2 times k)$ #pause

$ S = [0, 1]^(256 times 256 times 3) times bb(R)_+^(4096) times [0, 1]^3 times [0, 1]^2 times [0, 1]^(2 times k) $ #pause

*Question:* What is the size of the $Q$ matrix in assignment 1? #pause

#side-by-side[*Answer:* $S times A$ #pause][This would be a large matrix!]

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

Large but not infinite, we can learn this

==
#let graph = tiling(size: (2cm, 2cm))[
  #place(line(start: (0%, 0%), end: (0%, 100%)))
  #place(line(start: (0%, 0%), end: (100%, 0%)))
]

$ A $
#grid(columns: (10%, 80%), align: horizon, 
  $S$, rect(fill: graph, width: 96%, height: 44%)
)

We must update Q for each $s, a$ separately #pause
- With TD, we update once cell per datapoint #pause
- It can take many states and actions for Q converge

==
There is a lower sample complexity bound on convergence #footnote[Li, Gen, et al. "Is Q-Learning Minimax Optimal? A Tight Sample Complexity Analysis." Oper. Res. (2024).]#pause

$ ( |S| |A| ) / ((1 - gamma)^5 dot eta^2) $  #pause

Assume $gamma = 0.99, eta = 0.1$ #pause

$ (16348 | A |) / ((0.01)^5 dot 0.1^2) approx 1.6 times 10^16 times A $ #pause

$64 times A$ petabytes of rewards to learn $Q$

==
Simple Q learning works very well when the state space is small #pause
- We need a solution for infinite/continuous/large state spaces #pause
  - $Q$ must generalize to new/unseen states #pause

#let graph = tiling(size: (2cm, 2cm))[
  #place(line(start: (0%, 0%), end: (0%, 100%)))
  #place(line(start: (0%, 0%), end: (100%, 0%)))
]

$ A $
#grid(columns: (10%, 80%), align: horizon, 
  $S$, rect(fill: graph, width: 96%, height: 44%)
)

= Deep Q Learning
==

We know that deep learning generalizes well #pause
- Learns an accurate continuous function given limited datapoints #pause

Represent the Q function using a deep neural network #pause
- We call this *Deep Q Learning* #pause

Just because parameters exist, does not mean we can find them #pause
- *No guarantee* we will find good parameters for a deep Q function #pause

In general, deep RL has no convergence guarantees #pause
- Deep supervised learning also has weak guarantees, but it works well #pause
- We can say the same for deep RL: weak guarantees but it works well #pause

Let us learn the Q function using a deep neural network 
==
Recall that we define the TD form of $Q$ as 

$ Q(s_0, a_0, pi) &= bb(E)[cal(G)(bold(tau)) | s_0, a_0; pi] \
 &= bb(E)[cal(R)(s_1) | s_0, a_0] + gamma bb(E)[Q(s_1, a, pi) | s_0, a_0; pi] $ #pause

If we use the greedy policy, we can make $pi$ implicit

$ pi (a_t | s_t) = cases(
  1 "if" a_t = argmax_(a in A) Q(s_t, a),
  0 "otherwise"
) $ #pause

$ Q(s_0, a_0) &= max_(pi) bb(E)[cal(G)(bold(tau)) | s_0, a_0; pi] \
&= bb(E)[cal(R)(s_1) | s_0, a_0] + gamma bb(E)[max_(a in A) Q(s_1, a) | s_0, a_0] $

==

Now, let us make $Q$ a neural network with parameters $bold(theta)$ #pause

$ Q(s_0, a_0, bold(theta)) $ #pause

We must be careful, as our greedy policy now relies on $bold(theta)$ #pause

$ pi (a_t | s_t; bold(theta)) = cases(
  1 "if" a_t = argmax_(a in A) Q(s_t, a, bold(theta)),
  0 "otherwise"
) $ #pause

As does the expected return

$ Q(s_0, a_0, bold(theta)) = bb(E)[cal(G)(bold(tau)) | s_0, a_0; bold(theta)] $ 

/*
==
Deep Q learning uses the Temporal Difference objective #pause
- Recall we can drop $pi$ if using the implicit greedy/$argmax$ policy #pause

$ Q(s, a, pi) -> Q(s, a) $ #pause

$ pi (a_t | s_t) = cases(
  1 "if" a_t = argmax_(a in A) Q(s_t, a),
  0 "otherwise"
) $ #pause

Now, let us represent $Q$ as a neural network

==

First, define the Q function as a deep neural network with params $bold(theta)$ #pause

#side-by-side[Before:][
  $ Q: S times A |-> bb(R) $ #pause
]

#side-by-side[
  After:
][
  $ Q: S times A times Theta |-> bb(R) $ #pause
] 

Now, $pi$ explicitly depends on $bold(theta)$ #pause

$ pi (a_t | s_t; bold(theta)) = cases(
    1 "if" a_t = argmax_(a in A) Q(s_t, a, bold(theta)),
    0 "otherwise"
) $ 

==
Before, we wrote the policy-conditioned discounted return as

$ Q(s_0, a_0, pi) = bb(E)[cal(G)(bold(tau)) | s_0, a_0; pi]
$ #pause

Now, $Q$ is a deep neural network with parameters $bold(theta)$

$ Q(s_0, a_0, pi, bold(theta)) = bb(E)[cal(G)(bold(tau)) | s_0, a_0; pi, bold(theta)] $ #pause

$bold(theta)$ fully determines the greedy policy #pause

$ pi (a_t | s_t; bold(theta)) = cases(
    1 "if" a_t = argmax_(a in A) Q(s_t, a, pi, bold(theta)),
    0 "otherwise"
) $ #pause

//We will condition only on the neural network parameters $bold(theta)$ #pause

$ Q(s_0, a_0, pi, bold(theta)) = bb(E)[cal(G)(bold(tau)) | s_0, a_0; pi, bold(theta)] $ 
*/
==
#v(1.2em)
$ #pin(1)Q#pin(2)\(#pin(3)s_0, a_0#pin(4), #pin(7)bold(theta)#pin(8)) = #pin(5)bb(E)[cal(G)(bold(tau)) | s_0, a_0; bold(theta)]#pin(6)
$ #pause

#v(2em)

We want to learn the parameters $bold(theta)$ through gradient descent #pause
- Must make this look like a machine learning objective #pause

$ f(bold(x), bold(theta)) = bold(y) $ #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: top, height: 1.2em)[$f$] #pause

#pinit-highlight-equation-from((3,4), (3,4), fill: blue, pos: bottom)[$bold(x)$] #pause

#pinit-highlight-equation-from((7,8), (7,8), fill: orange, pos: bottom)[$bold(theta)$] #pause

#pinit-highlight-equation-from((5,6), (5,6), fill: green, pos: bottom)[$bold(y)$] 

==

Let us find the optimization objective for deep Q learning #pause

$ Q (s_0, a_0, bold(theta)) = #pin(5)bb(E)[cal(G)(bold(tau)) | s_0, a_0; bold(theta)]#pin(6)
$ #pause

Move everything to left #pause

$ Q(s_0, a_0, bold(theta)) - bb(E)[cal(G)(bold(tau)) | s_0, a_0; bold(theta)] = 0 
$ #pause

Use a distance measure we can minimize, choose square error #pause

$ (Q(s_0, a_0, bold(theta)) - bb(E)[cal(G)(bold(tau)) | s_0, a_0; bold(theta)])^2 = 0 
$ 

==
$ (Q(s_0, a_0, bold(theta)) - bb(E)[cal(G)(bold(tau)) | s_0, a_0; bold(theta)])^2 = 0 $ #pause

Evaluate expectation using TD and empirical samples #pause

$ (Q(s_0, a_0, bold(theta)) - (r_0 + not d_0 gamma max_(a in A) Q(s_1, a, bold(theta))))^2 = 0 $ #pause

Remember, we can treat any timestep as $s_0$ due to Markov property #pause

$ (Q(s_t, a_t, bold(theta)) - (r_t + not d_t gamma max_(a in A) Q(s_(t+1), a, bold(theta))))^2 = 0 $ 


==
$ (Q(s_t, a_t, bold(theta)) - (r_t + not d_t gamma max_(a in A) Q(s_(t+1), a, bold(theta))))^2 = 0 $ 

Now it is a loss function we can minimize #pause

$ cal(L)(bold(x), bold(theta)) = (Q(s_t, a_t, bold(theta)) - underbrace((r_t + not d_t gamma max_(a in A) Q(s_(t+1), a, bold(theta))), y))^2 $ #pause

*Question:* What is $bold(x)$? #pause

#side-by-side[
  A transition
][
  $ bold(x) = mat(s_t, a_t, r_t, d_t, s_(t+1)) $
]

==
$ cal(L)(bold(x), bold(theta)) = (Q(s_t, a_t, bold(theta)) - (r_t + not d_t gamma max_(a in A) Q(s_(t+1), a, bold(theta))))^2 $ 

$ bold(x) = mat(s_t, a_t, r_t, d_t, s_(t+1)) $ #pause

Finally, we should compute the loss over a batch of transitions #pause

$ bold(X) = vec(bold(x)_0, dots.v, bold(x)_n) $ #pause

$ cal(L)(bold(X), bold(theta)) = sum_(s_t, a_t, r_t, d_t, s_(t+1) in bold(X)) (Q(s_t, a_t, bold(theta)) - (r_t + not d_t gamma max_(a in A) Q(s_(t+1), a, bold(theta))))^2 $ 

==
$ cal(L)(bold(X), bold(theta)) = sum_(s_t, a_t, r_t, d_t, s_(t+1) in bold(X)) (Q(s_t, a_t, bold(theta)) - (r_t + not d_t gamma max_(a in A) Q(s_(t+1), a, bold(theta))))^2 $ #pause

We can use gradient descent to search for optimal $bold(theta)$ #pause

$ bold(theta)_(t+1) = bold(theta)_t + alpha dot (nabla_bold(theta)_t cal(L)) (bold(X), bold(theta)_t) $


= Target Networks
==
$ cal(L)(bold(X), bold(theta)) = sum_(s_t, a_t, r_t, d_t, s_(t+1) in bold(X)) (Q(s_t, a_t, bold(theta)) - (r_t + not d_t gamma max_(a in A) Q(s_(t+1), a, bold(theta))))^2 $ #pause

If you perform gradient descent on this objective, you will find

$ Q(s_0, a_0, bold(theta)) = oo $ #pause

*Question:* Can you see why? #pause Hint: What if $s_0 = s_1$? #pause

$ Q(s_0, a_0, bold(theta)) = r_0 + max_(a in A) Q(s_0, a_0, bold(theta)) $ #pause

#side-by-side[
  *Question:* What if $r_0 = 1$? #pause
][
  $ Q(s_0, bold(theta)_(t+1)) = 1 + Q(s_0, bold(theta)_(t+1)) $
]


==
$ nabla_bold(theta) sum_(bold(X)) (#redm[$Q(s_t, a_t, bold(theta))$] - underbrace((r_t + not d_t gamma max_(a in A) #redm[$Q(s_(t+1), a, bold(theta))$]), "Label"))^2 $ #pause 

The label depends on the function we are learning #pause
- Cannot use gradient descent here, requires residual gradient descent #pause
- Gradient descent is faster, use *target networks* to solve this #pause

$ nabla_#redm[$bold(theta)$] sum_(bold(X)) (Q(s_t, a_t, #redm[$bold(theta)$]) - (r_t + not d_t gamma max_(a in A) Q(s_(t+1), a, #bluem[$bold(theta)_(T)$])))^2 $ #pause

Label $Q$ is constant (semi-gradient), optimize with gradient descent 

==
We let $bold(theta)_T$ be an old version of $bold(theta)$
```python
theta = ... # Initialize parameters
theta_T = theta.copy()

for epoch in range(num_epochs):
  grad = grad(L)(theta, theta_T, X)
  theta = optimizer.update(theta, grad)
  if epoch % 200 == 0:
    # Update target parameters
    theta_T = theta.copy()
```

==
RL optimization is more difficult than supervised learning #pause

#side-by-side(align: top)[
  *Supervised Learning:* #pause
  - Fixed inputs #pause
  - Fixed labels #pause
  - Finite dataset #pause
    - Human can clean #pause
    - Bad to overfit #pause
][
  *Reinforcement Learning:* #pause
  - Inputs $bold(x)$ change as $pi"/"theta$ changes #pause
    - Visit new/different states #pause
  - Labels $bold(y)$ change as $pi"/"theta$ changes #pause
    - $bb(E)[cal(G)(bold(tau)) | pi"/"theta]$ #pause
  - Infinite dataset #pause
    - Bad $pi"/"theta$ means bad dataset #pause
    - Overfitting no problem
]

= Experience Replay
==
Optimization is difficult in RL #pause
- It takes a long time to train a deep Q function #pause
- Most RL papers train for 10M-10B environment steps #pause

Let us see if we can improve training speed

==
```python
for epoch in range(num_epochs):
  d = False # terminated
  s = env.reset()
  episode = []
  # Step between 1 and infinity times to get one episode
  while not d:
    a = policy(s, theta)
    next_s, r, d = env.step(action)
    episode.append([s, a, r, d, next_s])
  # Compute gradient over episode
  J = grad(L)(theta, episode)
  theta = update(theta, grad)
``` #pause

*Question:* Which part is slowest? #pause *Answer:* Collecting episodes

==
```python
for epoch in range(num_epochs):
  d = False # terminated
  s = env.reset()
  episode = []
  # Step between 1 and infinity times to get one episode
  while not d:
    a = policy(s, theta)
    next_s, r, d = env.step(action)
    episode.append([s, a, r, d, next_s])
  # Compute gradient over episode
  J = grad(L)(theta, episode)
  theta = update(theta, grad)
``` #pause

Collect episode, train, throw away episode, start again

==
What if we reuse episodes? #pause
 
```python
episodes = []
for epoch in range(num_epochs):
  d = False # terminated
  s = env.reset()
  episode = []
  while not d:
    a = policy(s, theta)
    next_s, r, d = env.step(action)
    episode.append([s, a, r, d, next_s])
  episodes.append(episode)
  J = grad(L)(theta, episodes) # Train over ALL episodes
  theta = update(theta, grad)
``` 

==
*Experience Replay* stores transitions for reuse #pause

#side-by-side(align: horizon)[
  Append to a *replay buffer* (list) #pause
][
$ bold(D) = mat(
  bold(s)_1, bold(a)_1, bold(r)_1, bold(d)_1;
  dots.v, dots.v, dots.v, dots.v;
  bold(s)_t, bold(a)_t, bold(r)_t, bold(d)_t
) 
$
] #pause


#side-by-side(align: horizon)[
  Sample a batch from the buffer #pause
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
  $ bold(theta)_(t+1) = bold(theta)_t - alpha dot nabla_bold(theta)_t cal(L)(bold(X)_t, bold(theta)_t) $
] #pause

==
*Question:* Humans do experience replay. What do we call it? #pause

*Answer:* Dreaming! #footnote[Liu, Yunzhe, et al. "Experience replay is associated with efficient nonlocal learning." Science 372.6544 (2021): eabf1357.] #pause

+ Collect information by interaction with the world (wake) #pause
+ Stop interacting with the world (sleep) #pause
+ Replay memories and learn from them (dream)



==
*On-policy* algorithms must throw away episodes after training #pause
- Must collect data using the current $pi$, cannot use experience replay #pause

*Off-policy* algorithms can reuse old episodes and use experience replay #pause
- In fact, for off policy algorithms, data can come from anywhere #pause
  - Previous policy #pause
  - Previous training run #pause
  - Human policy #pause

*Question:* Which is Deep Q learning? 

==
Let us look at the TD objective #pause

$ Q(s_0, a_0, pi) &= bb(E)[cal(G)(bold(tau)) | s_0, a_0; pi] \
 &= bb(E)[#greenm[$cal(R)(s_1)$] | #redm[$s_0$], #bluem[$a_0$]] + gamma bb(E)[Q(s_1, a, pi) | s_0, a_0; pi] $ #pause

Training data $#redm[$s_0$], #bluem[$a_0$], #greenm[$r_0$], s_1$ does *not* rely on $pi$ #pause
- It is defined for any $s_0, a_0$ given to $Q$ #pause
- $bb(E)[Q(s_1, a, pi) | s_0, a_0; pi]$: Here, $s_1$ comes from $a_0$ not $pi$ #pause
  - What about $r_2, r_3, dots$ that $Q(s_1, a, pi)$ represents? $a_1, a_2 tilde pi$ #pause
    - We approximate them with $Q$, $pi$ on RHS is same as $pi$ on LHS

Deep Q learning (TD objective) is off-policy #pause
- We can reuse old data!

==
Let us look at the TD objective #pause

$ Q(s_0, a_0, pi) &= bb(E)[cal(G)(bold(tau)) | s_0, a_0; pi] \
 &= bb(E)[#greenm[$cal(R)(s_1)$] | #redm[$s_0$], #bluem[$a_0$]] + gamma bb(E)[Q(s_1, a_1, pi) | s_0, a_0; pi] $ #pause

Training data $#redm[$s_0$], #bluem[$a_0$], #greenm[$r_0$], s_1$ does *not* rely on $pi$! #pause
- It is defined by transition dynamics for whichever $s_0, a_0$ we query #pause
- In $bb(E)[Q(s_1, a_1, pi) | s_0, a_0; pi]$, state $s_1$ comes from $#bluem[$a_0$]$, not $pi$ #pause

*Question:* What about the future rewards $r_1, r_2, dots$ hidden inside $Q(s_1, a_1, pi)$? 
Don't those require taking future actions $a_1, a_2 tilde pi$? #pause

*Answer:* Yes, but we don't use real data for the future! 

==
$ Q(s_0, a_0, #redm[$pi$]) &= bb(E)[cal(G)(bold(tau)) | s_0, a_0; #redm[$pi$]] \
 &= bb(E)[cal(R)(s_1) | s_0, a_0] + gamma bb(E)[Q(s_1, a_1, #redm[$pi$]) | s_0, a_0; #redm[$pi$]] $ #pause

We approximate the future using our network $Q$ #pause
- The policy $pi$ on the RHS is the same policy $pi$ on the LHS! #pause
  - If we update the policy on the LHS, the RHS also updates #pause
- This process is known as *bootstrapping*

==
Let us look at a Monte Carlo objective #pause

$ Q(s_0, a_0, pi) &= bb(E)[cal(G)(bold(tau)) | s_0, a_0; pi] \
 &= sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0; pi] #pause \
 &= bb(E)[#redm[$cal(R)(s_(1))$] | s_0, a_0]
 + gamma bb(E)[#bluem[$cal(R)(s_(2))$] | s_0, a_0 ; pi] + dots \
 &approx #redm[$r_0$] + gamma #bluem[$r_1$] + dots
 $ #pause

Training data $#redm[$r_0$]$ comes from $a_0, s_0$ #pause
- Where does $#bluem[$r_1$]$ come from?
  - $a_1 tilde pi_beta$, where $pi_beta$ collected the data #pause

Monte Carlo objectives are on-policy, cannot reuse old data!

==

To summarize: #pause

Monte Carlo Q learning is on-policy #pause
- Cannot reuse data, takes a long time to train #pause

Temporal Difference Q learning is special! #pause
- It is off-policy, can reuse data and train faster #pause

TD is not always better than MC #pause
- MC needs more training data, but TD is harder to optimize #pause
- Fast environment with guaranteed termination, choose MC


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
- However, it did not work very well and could only solve simple tasks #pause
- We discovered deep learning, experience replay, and target networks #pause

Deep Q Networks (DQN) combined them to beat humans on Atari #footnote[Human-level control through deep reinforcement learning. _Nature._ 2014.] #pause
- After this paper, people realized that RL can work for hard tasks #pause
- You have all the tools you need to implement DQN, except for one

/*
==
One important part of DQN is compute #pause

In 2014, GPUs were not popular for deep learning #pause

They used multiple GPUs to train in the DQN paper #pause

We see this very often in deep learning #pause

Add more compute, and find interesting results #pause

http://www.incompleteideas.net/IncIdeas/BitterLesson.html #pause

Next, let us understand the neural network architecture

// CNN + MLP
// Is markov? 
// Frame stacking
==
We must understand the problem before the model architecture #pause

The authors design the architecture to solve the problem #pause

The Atari video game system has 57 games #pause

Each game has a resolution of $160 times 192$ pixels and up to 18 actions #pause

$ S = bb(Z)_(0: 255)^(160 times 192 times 3) #pause , A = {"left", "up left", dots}, quad |A| = 18 $ #pause

*Question:* How many possible states? #pause $256 times 160 times 192 times 3 approx 23M $

*Question:* Size of Q matrix? #pause  $23M times 18 approx 500M $

Too big for a Q value matrix! Use deep Q function instead

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
*/

==
Normally, the greedy Q function takes action as input #pause

$ Q: S times A times Theta |-> bb(R) $ #pause


Then, we run $Q$ for all actions #pause

$ a = argmax_i vec(
  Q(s, a=1, bold(theta)),
  Q(s, a=2, bold(theta)),
  dots.v,
  Q(s, a=i, bold(theta)),
 ) $ #pause

For each action, we must execute $Q$ network $|A|$ times. Not efficient!

==

$ Q: S times A times Theta |-> bb(R) $ #pause

In DQN, the authors estimate all $Q$ at once #pause

$ Q: S times Theta |-> bb(R)^(|A|) $ #pause

The neural network outputs $|A|$ values -- one for each action #pause

$ a = argmax_i Q(s, bold(theta))_i $ #pause

This is $|A|$ times faster!

==

#cimage("fig/07/dqn-arch.jpg")

==
```python
Q = nn.Sequential([...])
theta_T = partition(Q, is_array)[0]
replay_buffer = deque(maxsize=50_000) 
for epoch in range(num_epochs):
  while not terminated:
    a = random_action if epoch < k else epsilon_greedy(Q)
    s, r, d, next_s = env.step(a)
    replay_buffer.insert((s, a, r, d, next_s))
    X = random.sample(replay_buffer, batch_size)
    theta, model = eqx.partition(Q, is_array) 
    theta = td_update(theta, theta_T, Q, X)
    theta_T = copy(theta) if epoch % j == 0 else theta_T
    Q = eqx.combine(theta, model)
```

==
Finally, let us look at some successes of deep Q learning #pause
- https://huggingface.co/learn/deep-rl-course/en/unit3/hands-on #pause
- Mario Kart: https://www.youtube.com/watch?v=lnnHmVNO07Q #pause
- Super Smash Bros: https://www.youtube.com/watch?v=7rDfIcdszxQ

= Homework
==
You have everything you need to start homework 2 

https://colab.research.google.com/drive/1qKXsaOpT27paCmPA-Hbh_-PtbQnrrkla
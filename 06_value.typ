#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm
#import "@preview/touying:0.6.0": *
#import themes.university: *
#import "common.typ": *
#import "@preview/cetz:0.3.2"
#import "@preview/fletcher:0.5.5" as fletcher: diagram, node, edge
#import "@preview/pinit:0.2.2": *

#set math.vec(delim: "[")
#set math.mat(delim: "[")

#let traj_opt_tree = diagram({
  node((0mm, 0mm), $s_a$, stroke: 0.1em, shape: "circle", name: "root")

  node((-75mm, -25mm), $a_a$, stroke: 0.1em, shape: "circle", name: "0ai")
  node((75mm, -25mm), $a_b$, stroke: 0.1em, shape: "circle", name: "0aj")

  node((-100mm, -50mm), $s_a$, stroke: 0.1em, shape: "circle", name: "0aisi")
  node((-50mm, -50mm), $s_b$, stroke: 0.1em, shape: "circle", name: "0aisj")

  node((50mm, -50mm), $s_a$, stroke: 0.1em, shape: "circle", name: "0ajsi")
  node((100mm, -50mm), $s_b$, stroke: 0.1em, shape: "circle", name: "0ajsj")

  node((-75mm, -75mm), $a_a$, stroke: 0.1em, shape: "circle", name: "0aisjai")
  node((-25mm, -75mm), $a_b$, stroke: 0.1em, shape: "circle", name: "0aisjaj")

  node((75mm, -75mm), $a_a$, stroke: 0.1em, shape: "circle", name: "0ajsjai")
  node((125mm, -75mm), $a_b$, stroke: 0.1em, shape: "circle", name: "0ajsjaj")

  node((-100mm, -75mm), $dots$)
  node((25mm, -75mm), $dots$)

  node((-125mm, 0mm), $t=0$)
  node((-125mm, -50mm), $t=1$)
  node((-125mm, -100mm), $t=2$)
  node((-125mm, -125mm), $dots.v$)


  edge(label("root"), label("0ai"), "->")
  edge(label("root"), label("0aj"), "->")

  edge(label("0ai"), label("0aisi"), "->", label: $Tr(s_a | s_a, a_a)$, )
  edge(label("0ai"), label("0aisj"), "->", label: $Tr(s_b | s_a, a_a)$, )

  edge(label("0aj"), label("0ajsi"), "->", label: $Tr(s_a | s_a, a_b)$)
  edge(label("0aj"), label("0ajsj"), "->", label: $Tr(s_b | s_a, a_b)$)

  edge(label("0aisj"), label("0aisjaj"), "->")
  edge(label("0aisj"), label("0aisjai"), "->")

  edge(label("0ajsj"), label("0ajsjaj"), "->")
  edge(label("0ajsj"), label("0ajsjai"), "->")
})

#let traj_opt_tree_pruned = diagram({
  node((0mm, 0mm), $s_a$, stroke: 0.1em, shape: "circle", name: "root")

  node((75mm, -25mm), $a_b$, stroke: 0.1em, shape: "circle", name: "0aj")


  node((50mm, -50mm), $s_a$, stroke: 0.1em, shape: "circle", name: "0ajsi")
  node((100mm, -50mm), $s_b$, stroke: 0.1em, shape: "circle", name: "0ajsj")

  node((125mm, -75mm), $a_b$, stroke: 0.1em, shape: "circle", name: "0ajsjaj")

  node((-100mm, -75mm), $dots$)
  node((25mm, -75mm), $dots$)

  node((-125mm, 0mm), $t=0$)
  node((-125mm, -50mm), $t=1$)
  node((-125mm, -100mm), $t=2$)
  node((-125mm, -125mm), $dots.v$)


  edge(label("root"), label("0aj"), "->")


  edge(label("0aj"), label("0ajsi"), "->", label: $Tr(s_a | s_a, a_b)$)
  edge(label("0aj"), label("0ajsj"), "->", label: $Tr(s_b | s_a, a_b)$)


  edge(label("0ajsj"), label("0ajsjaj"), "->")
})


#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Value],
    subtitle: [CISC 7404 - Decision Making],
    author: [Steven Morad],
    institution: [University of Macau],
    logo: image("fig/common/bolt-logo.png", width: 4cm)
  ),
  header-right: none,
  header: self => utils.display-current-heading(level: 1)
)

= Review

// Problems with MPC, cannot do infinite
// What if I told you we could build an infinitely deep tree?
// Start with original E[G]
// Introduce a policy into E[G], write out big equation
// MCTS
// Introduce value function
// Call this a value function
// Value of a state
// Examples of valuable states
    // Studying no reward, but valuable because of return
// Value functions
// Value iteration (still needs model)
// Value function objectives (MC)
// Infinite step hard to determine
// Derive TD
// Value iteration with TD
// What if we don't know the model?
// Introduce TD learning
// Introduce SARSA 
// Introduce Q learning
// Q learning exercise (frozenlake)
// Training loop

#title-slide()

== Outline <touying:hidden>

#components.adaptive-columns(
    outline(title: none, indent: 1em, depth: 1)
)

= Policy-Conditioned Returns



==
Trajectory optimization theory is useful

Guaranteed to find an optimal policy, given infinite compute 

We must make approximations to implement trajectory optimization 

These approximations break optimality guarantees 

Today, we will see other methods that can reason over infinitely long futures

==

First, let us recall the objective from last time

$ bb(E) [cal(G)(bold(tau)) | s_0, a_0, a_1, dots] = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0, dots, a_t] $

This is dependent on a sequence of actions 

Actions can come from anywhere (I pick, randomly, etc)

Also, recall the policy 
$ pi: S times Theta |-> Delta A $

==

$ bb(E) [cal(G)(bold(tau)) | s_0, a_0, a_1, dots] = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0, dots, a_t] $

We can depend on a policy instead of specific actions 

$ a_0 tilde pi (dot | s_0), a_1 tilde pi (dot | s_1), dots $

Take the expectation over a *distribution* of actions coming from $pi$, rather than distinct actions 

$ bb(E) [cal(G)(bold(tau)) | s_0; theta_pi] = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, a_0, dots, a_t] $

==

The next state becomes a function of the policy

$ Pr (s_(t+1) | s_t; theta_pi) = sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi)  $

Consider concrete examples

$ Pr (s_1 | s_0; theta_pi) &= sum_(a_0 in A) Tr(s_1 | s_0, a_0) dot pi (a_0 | s_0; theta_pi) \

Pr (s_2 | s_0; theta_pi) &= sum_(s_1 in S) sum_(a_1 in A) Tr(s_2 | s_1, a_1) dot pi (a_1 | s_1; theta_pi) \ 
& quad quad dot sum_(a_0 in A) Tr(s_1 | s_0, a_0) dot pi (a_0 | s_0; theta_pi)
$

==

$ Pr (s_1 | s_0; theta_pi) &= sum_(a_0 in A) Tr(s_1 | s_0, a_0) dot pi (a_0 | s_0; theta_pi) \

Pr (s_2 | s_0; theta_pi) &= sum_(s_1 in S) sum_(a_1 in A) Tr(s_2 | s_1, a_1) dot pi (a_1 | s_1; theta_pi) \ 
& quad quad dot sum_(a_0 in A) Tr(s_1 | s_0, a_0) dot pi (a_0 | s_0; theta_pi)
$

Derive a general form for $Pr (s_(n+1) | s_0; theta_pi)$

$ Pr (s_(n+1) | s_0; theta_pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta) ) $

==

$ Pr (s_(n+1) | s_0; theta_pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta) ) $

*Question:* What is the expected reward for $s_(n+1)$?

*Answer:*

$ sum_(s_(n+1) in S) cal(R)(s_(n+1)) dot Pr (s_(n+1) | s_0; theta_pi) $

==
$ sum_(s_(n+1) in S) cal(R)(s_(n+1)) dot Pr (s_(n+1) | s_0; theta_pi) $

Discounted return is discounted sum of rewards
$ bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] =& sum_(s_1 in S) cal(R)(s_1) dot Pr (s_1 | s_0; theta_pi) \ 
+ gamma & sum_(s_2 in S) cal(R)(s_2) dot Pr (s_2 | s_0; theta_pi) \
+ gamma^2 & sum_(s_3 in S) cal(R)(s_3) dot Pr (s_3 | s_0; theta_pi)  \
dots $

==
General form of policy-conditioned discounted return 

$ 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr(s_(n + 1) | s_n, a_n)
$

Where the state distribution is

$ Pr (s_(n+1) | s_0; theta_pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta) ) $

= Monte Carlo Tree Search
==
Previously built a large tree to compute 

$ bb(E)[cal(G)(bold(tau)) | s_0, a_0, a_1, dots] $

Optimal case was intractable with $O(|S| dot |A|)^n$ complexity

==


#text(size: 20pt)[#traj_opt_tree]

==
Previously built a large tree to compute 

$ bb(E)[cal(G)(bold(tau)) | s_0, a_0, a_1, dots] $

Optimal case was intractable with $O(|S| dot |A|)^n$ complexity

*Question:* Does depending on policy make it better? How?

$ bb(E)[cal(G)(bold(tau)) | s_0, theta_pi] $

*Answer:* Only consider actions with nonzero support under the policy

If policy has action with probability one, then $O(|S| dot 1)^n$

*Question:* Can we think of any policies like this?

==
$ pi (a_t | s_t; theta_pi) =  cases( 
  1 "if" a_t = argmax_(a_t in A) bb(E)[cal(G)(bold(tau)) | s_0, theta_pi], 
  0 "otherwise"
) $

==

#traj_opt_tree_pruned

==
$ pi (a_t | s_t; theta_pi) =  cases( 
  1 "if" a_t = argmax_(a_t in A) bb(E)[cal(G)(bold(tau)) | s_0, theta_pi], 
  0 "otherwise"
) $

*Intution:* Limiting the support of the policy distribution can create much smaller decision trees

Not all distributions have limited support

Human policy can be random, nonzero support everywhere

Policy is a distribution

We can sample actions from it

Given full support, approaches the true decision tree in the limit

==

Call this approach *Monte-Carlo tree search* (MCTS)

It's like gambling to approximate 

AlphaGo uses 

Reasoning LLMs (ChatGPT-o1) rumored to use MCTS

Only expands likely actions

https://vgarciasc.github.io/mcts-viz/

= Value Functions



/*
==
$ Pr (s_(n+1) | s_0; theta_pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta) ) $

$ 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr(s_(n + 1) | s_n, a_n)
$

//product_(t=0)^n [ sum_(s_(t+1) in S) sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) pi (a_t | s_t; theta)] $

This is a process:
+ Given the state, compute the action distribution $pi (a_t | s_t; theta)$
+ Given the action distribution, compute the next state distribution $Tr(s_(t+1) | s_t, a_t)$
+ Given the next state distribution, compute the reward distribution $R(s_(t+1))$
*/
==

$ Pr (s_(n+1) | s_0; theta_pi) &= sum_(a_0, dots, a_n in A) sum_(s_1, dots, s_n in S) product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) \
 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] &= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; theta_pi)
$

These two equations form the basis of all reinforcement learning

Always want to find the $theta_pi$ (policy) to maximize the expected return

==

*Note:* In the course, we will write the $V$ many different ways

But they will *always* approximate
$ 
V(s_0, theta_pi) = bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(t=0)^oo gamma^t sum_(s_(t + 1) in S) cal(R)(s_(t+1)) dot Pr (s_(t + 1) | s_0; theta_pi)
$

For example

$ V(s_0, theta_pi) = sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0, theta_pi] $
==

$ Pr (s_(n+1) | s_0; theta_pi) &= sum_(a_0, dots, a_n in A) sum_(s_1, dots, s_n in S) product_(t=0)^n Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) \
 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] &= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; theta_pi)
$

We call the policy-conditioned return the *value function*

$ 
V(s_0, theta_pi) = bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; theta_pi)
$

The value function tells us how valuable a state $s_0$ is for the policy

==

TODO messy vs clean policy value function

==

= Value Objectives

==
$ 
V(s_0, theta_pi) = bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(t=0)^oo gamma^t sum_(s_(t + 1) in S) cal(R)(s_(t+1)) dot Pr (s_(t + 1) | s_0; theta_pi)
$

*Idea:* Instead of computing the tree, can we learn to approximate it?


$ V(s_0, theta_pi, theta_V) = bb(E)[cal(G)(bold(tau)) | s_0; theta_pi]; quad bold(tau) in (S times A)^n $

*Question:* How can we learn $Theta_V$ such that it becomes the true $V$ function?

*Answer:* Mean square error

$ V(s_0, theta_pi, theta_V) - bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = 0 $

==

TODO: Expectation, so we can learn from samples

$ V(s_0, theta_pi, theta_V) - bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = 0 $

$ (V(s_0, theta_pi, theta_V) - bb(E)[cal(G)(bold(tau)) | s_0; theta_pi])^2 = 0 $

$ argmin_(theta_V) (V(s_0, theta_pi, theta_V) - bb(E)[cal(G)(bold(tau)) | s_0; theta_pi])^2 $

$ argmin_(theta_V) sum_(s_0 in S) (V(s_0, theta_pi, theta_V) - bb(E)[cal(G)(bold(tau)) | s_0; theta_pi])^2 $

We do not know $bb(E)[cal(G)(bold(tau)) | s_0; theta_pi]$?

*Question:* What can we do when we do not know an expectation? (Hint: Bandits)

*Answer:* Approximate the expectation by playing!

$ argmin_(theta_V) sum_(s_0 in S) (V(s_0, theta_pi, theta_V) - hat(bb(E))[cal(G)(bold(tau)) | s_0; theta_pi])^2 $


+ Run our policy in the environment
+ Collect a trajectory $bold(tau)$
// + Create subtrajectories $bold(tau)_(0:), bold(tau)_(1:), dots $
+ Compute the return of the trajectory $cal(G)(bold(tau))$
+ Now we have $hat(bb(E))_1[cal(G)(bold(tau)) | s_0, theta_pi]$
+ Repeat to improve estimate! $hat(bb(E))_k [cal(G)(bold(tau)) | s_0, theta_pi]$

==

$ argmin_(theta_V) sum_(s_0 in S) (V(s_0, theta_pi, theta_V) - hat(bb(E))[cal(G)(bold(tau)) | s_0; theta_pi])^2 $


+ Run our policy in the environment
+ Collect a trajectory $bold(tau)$
// + Create subtrajectories $bold(tau)_(0:), bold(tau)_(1:), dots $
+ Compute the return of the trajectory $cal(G)(bold(tau))$
+ Now we have $hat(bb(E))_1[cal(G)(bold(tau)) | s_0, theta_pi]$
+ Repeat to improve estimate! $hat(bb(E))_k [cal(G)(bold(tau)) | s_0, theta_pi]$

TODO: All $s_0$ in $tau$

We call this the *Monte Carlo objective*

We approximate the return using monte carlo trajectories

Note that we *do not* know $Tr$!

==

1. Execute policy in environment and collect trajectory

```python
terminated = False
state = env.reset()
trajectory, rewards = [], []
while not terminated:
    action_distribution = policy(s, theta_pi)
    action = sample(action_distribution)
    next_state, reward, terminated = env.step(action)
    trajectory.append((state, action))
    rewards.append(reward)
    state = next_state
return trajectory, rewards
```

==
2. Compute the return of the trajectory
```python
def G(rewards, gamma):
    return sum(r * gamma ** t for t in range(len(rewards)))

# Approximate E_1[G] empirically
# Compute the return for s_0 in trajectory
E_1g = G(rewards, gamma)
# Inefficient! We can treat each s in trajectory as s_0
# n datapoints for each trajectory length n
E_ng = []
for i in range(len(rewards)):
    E_ng.append(G(rewards[i:]))
```
==

3. Train! Learn the value of a policy 
```python
theta_V = jnp.zeros(len(S))
def V(state, theta_pi, theta_V):
    return theta_V[state]

def update_V(states, returns, theta_pi, theta_V, alpha=0.01):
    for s, g in zip(states, returns):
        theta_V[s] +=  alpha * (g - V(s, theta_pi, theta_V))
    return theta_V

# Update_V using trajectories and returns
```

==

TODO: Implementation example with linear

Hint at nonlinear


= Temporal Difference
==

$ V(s_0, theta_pi) = bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(t=0)^oo gamma^t sum_(s_(t + 1) in S) cal(R)(s_(t+1)) dot Pr (s_(t + 1) | s_0; theta_pi) $

Approximating this requries an infiinite sequence (or one that terminates)

Requires lots of data to approximate the expectation

What if I told you we could train this from a single data point?

==

$ V(s_0, theta_pi) = sum_(t=0)^oo gamma^t sum_(s_(t + 1) in S) cal(R)(s_(t+1)) dot Pr (s_(t + 1) | s_0; theta_pi) $

Factor out one timestep

$ V(s_0, theta_pi) = gamma^0 sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; theta_pi) \ + sum_(t=1)^oo gamma^t sum_(s_(t + 1) in S) cal(R)(s_(t+1)) dot Pr (s_(t + 1) | s_0; theta_pi) $

$ V(s_0, theta_pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; theta_pi) \ + sum_(t=1)^oo gamma^t sum_(s_(t + 1) in S) cal(R)(s_(t+1)) dot Pr (s_(t + 1) | s_0; theta_pi) $

Rewrite sum starting from $t=0$

$ V(s_0, theta_pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; theta_pi) \ + sum_(t=0)^oo gamma^(t+1) sum_(s_(t + 2) in S) cal(R)(s_(t+2)) dot Pr (s_(t + 2) | s_0; theta_pi) $

Factor out $gamma$

$ V(s_0, theta_pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; theta_pi) \ + gamma sum_(t=0)^oo gamma^(t) sum_(s_(t + 2) in S) cal(R)(s_(t+2)) dot Pr (s_(t + 2) | s_0; theta_pi) $

Split $Pr$ using Markov property

$ V(s_0, theta_pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; theta_pi) \ + gamma sum_(t=0)^oo gamma^(t) sum_(s_(t + 2) in S) cal(R)(s_(t+2)) sum_(s_1) Pr (s_(t + 2) | s_(t+1); theta_pi) Pr (s_(1) | s_0; theta_pi) $

Move sum and $Pr$ outside

$ V(s_0, theta_pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; theta_pi) \ + sum_(s_1) Pr (s_(1) | s_0; theta_pi) gamma sum_(t=0)^oo gamma^(t) sum_(s_(t + 2) in S) cal(R)(s_(t+2))  Pr (s_(t + 2) | s_(t+1); theta_pi) $

==
$ V(s_0, theta_pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; theta_pi) \ + sum_(s_1) Pr (s_(1) | s_0; theta_pi) gamma #pin(1)sum_(t=0)^oo gamma^(t) sum_(s_(t + 2) in S) cal(R)(s_(t+2))  Pr (s_(t + 2) | s_(t+1); theta_pi)#pin(2) $

*Question:* What is this term? #pinit-highlight(1,2)

$ V(s_0, theta_pi) = bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(t=0)^oo gamma^t sum_(s_(t + 1) in S) cal(R)(s_(t+1)) dot Pr (s_(t + 1) | s_0; theta_pi) $

$ V(s_1, theta_pi) = bb(E)[cal(G)(bold(tau)) | s_1; theta_pi] = sum_(t=0)^oo gamma^t sum_(s_(t + 2) in S) cal(R)(s_(t+2)) dot Pr (s_(t + 2) | s_1; theta_pi) $

==

$ V(s_0, theta_pi) = sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; theta_pi) \ + sum_(s_1) Pr (s_(1) | s_0; theta_pi) gamma sum_(t=0)^oo gamma^(t) sum_(s_(t + 2) in S) cal(R)(s_(t+2))  Pr (s_(t + 2) | s_(t+1); theta_pi) $

$ V(s_0, theta_pi) = (sum_(s_ 1 in S) cal(R)(s_(1)) dot Pr (s_( 1) | s_0; theta_pi)) + gamma V(s_1, theta_pi) $

$ V(s_0, theta_pi) = bb(E)[cal(R)(s_1) | s_0, theta_pi] + gamma V(s_1, theta_pi) $

This is a huge finding!

==

$ V(s_0, theta_pi) = bb(E)[cal(R)(s_1) | s_0, theta_pi] + gamma V(s_1, theta_pi) $

Value function has a recursive definition

Represent policy-conditioned discounted return without an infinite sum

We call this the *one-step return*

Compute the return with a single transition $s_0 -> s_1$





= Q Functions

==

We saw two equations for the value function (one-step and $n$-step return)

The value function relies on a policy

But it does not tell us the policy

How can we use the value function to find an optimal policy?


= SARSA

= Q Learning
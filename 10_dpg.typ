#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm
#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "common.typ": *
#import "@preview/cetz:0.3.4": canvas
#import "@preview/cetz-plot:0.1.1": plot
#import "@preview/fletcher:0.5.5" as fletcher: diagram, node, edge
#import "@preview/pinit:0.2.2": *

#set math.vec(delim: "[")
#set math.mat(delim: "[")

#let low_ent = { 
    set text(size: 25pt)
    canvas(length: 1cm, 
    {
        plot.plot(
            size: (6, 4),
            name: "plot",
            x-tick-step: 2,
            y-tick-step: none,
            y-ticks: (0, 1),
            y-min: 0,
            y-max: 4,
            x-label: $ a $,
            y-label: $ Pr (a | s) $,
            {
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: red)),
                label: $ pi (a | s; theta_(pi)) $,
                x => normal_fn(0, 0.2, x),
            ) 

            })
    }
)}

#let high_ent = { 
    set text(size: 25pt)
    canvas(length: 1cm, 
    {
        plot.plot(
            size: (6, 4),
            name: "plot",
            x-tick-step: 2,
            y-tick-step: none,
            y-ticks: (0, 1),
            y-min: 0,
            y-max: 4,
            x-label: $ a $,
            y-label: $ Pr (a | s) $,
            {
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: red)),
                label: $ pi (a | s; theta_(pi)) $,
                x => normal_fn(0, 0.8, x),
            ) 

            })
    }
)}


#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Actor Critic II],
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

= Quiz

= Review

= Actor Critic
// Two ways to do actor critic
    // Last time, actor critic was focused on policy gradient
    // We utilize the value function to get around MC returns
    // Today, we will look at the other approach to actor critic
    // In this case, we focus more on learning Q functions
    // The actor is a way to get around limitations of Q functions
// Talk about robot example again
// Cannot argmax over infinite action space
// Can we approximate argmax?
// How? Neural network
// In this case, we will learn a neural network that approximates the argmax policy
==

= Deterministic Policy Gradient
// Introduce learned argmax policy as function
// Derive policy gradient again, but starting with Q function instead of return
// Go into DDPG

// Could instead try and start from making Q learning continuous
// Factorize policy into mu and pi (pi used for exploration)
==
$ Q(s_0, a_0, theta_pi, theta_Q) = bb(R)[cal(R)(s_(t+1)) | s_0, a_0] + gamma Q(s_1, a, theta_pi, theta_Q) $

When $theta_pi$ represents the greedy policy, we have

$ Q(s_0, a_0, theta_pi, theta_Q) = bb(R)[cal(R)(s_(t+1)) | s_0, a_0] + gamma max_(a in A) Q(s_1, a, theta_pi, theta_Q) $

If $A$ is infinite we cannot take argmax, cannot use greedy policy


Introduce a deterministic policy $mu: S times Theta |-> A$

Instead of distribution, outputs just an action

How does the expected return changes when we have a single action?

==

With a stochastic policy, we have

$ 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; theta_pi)
$ 

$ Pr (s_(n+1) | s_0; theta_pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ) $ 

With a deterministic policy

$ Pr (s_(n+1) | s_0; theta_pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, theta_pi)) $ 

==
$ 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; theta_pi)
$ 
$ Pr (s_(n+1) | s_0; theta_pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, theta_pi)) $ 

Combine

$
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot sum_(s_1, dots, s_n in S) product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, theta_pi)) 
$

==
$
nabla_theta_pi [bb(E)[cal(G)(bold(tau))] | s_0; theta_pi] \ = nabla_theta_pi [ sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot sum_(s_1, dots, s_n in S) product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, theta_pi)) ]
$

Move the gradient inside

$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot sum_(s_1, dots, s_n in S) nabla_theta_pi [ product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, theta_pi)) ]
$

==

$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot sum_(s_1, dots, s_n in S) nabla_theta_pi [ product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, theta_pi)) ]
$

Apply the log trick

$ nabla_x f(x)  = f(x) nabla_x log f(x) $ 

$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot sum_(s_1, dots, s_n in S) \ product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, theta_pi)) nabla_theta_pi [ log(product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, theta_pi))) ]
$

== 
#text(size: 24pt)[
$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot sum_(s_1, dots, s_n in S) \ product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, theta_pi)) nabla_theta_pi [ log(product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, theta_pi))) ]
$

Log of products is sum of logs

$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot sum_(s_1, dots, s_n in S) \ product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, theta_pi)) nabla_theta_pi [ sum_(t=0)^n log Tr(s_(t+1) | s_t, mu(s_t, theta_pi)) ]
$
]

==

$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot sum_(s_1, dots, s_n in S) \ product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, theta_pi)) nabla_theta_pi [ sum_(t=0)^n log Tr(s_(t+1) | s_t, mu(s_t, theta_pi)) ]
$

Move gradient inside sum

$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot sum_(s_1, dots, s_n in S) \ product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, theta_pi))  sum_(t=0)^n nabla_theta_pi log Tr(s_(t+1) | s_t, mu(s_t, theta_pi)) 
$

==

$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot sum_(s_1, dots, s_n in S) \ product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, theta_pi))  sum_(t=0)^n nabla_theta_pi log Tr(s_(t+1) | s_t, mu(s_t, theta_pi)) 
$

$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot sum_(s_1, dots, s_n in S) product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, theta_pi)) \ sum_(t=0)^n nabla_(a_t) log Tr(s_(t+1) | s_t, a_t) bar.v_(a_t = mu(s_t, theta_pi)) dot nabla_theta_pi mu(s_t, theta_pi)
$

==
$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot sum_(s_1, dots, s_n in S) product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, theta_pi)) \ sum_(t=0)^n nabla_(a_t) log Tr(s_(t+1) | s_t, a_t) bar.v_(a_t = mu(s_t, theta_pi)) dot nabla_theta_pi mu(s_t, theta_pi)
$

It seems like we must know $Tr$ to find the deterministic policy gradient

We were very lucky with stochastic policy gradient -- $Tr$ vanishes!

With stochastic policy, we multiply $Tr$ by $pi$ (product rule)

With deterministic, $pi$ inside $Tr$ means chain rule


==
$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot sum_(s_1, dots, s_n in S) product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, theta_pi)) \ sum_(t=0)^n nabla_(a_t) log Tr(s_(t+1) | s_t, a_t) bar.v_(a_t = mu(s_t, theta_pi)) dot nabla_theta_pi mu(s_t, theta_pi)
$

It turns out that $nabla_(a_t) Q(s_t, a_t) $ looks very similar to this

==
What if we try something new?

TODO: Maybe maximize $V$ first then convert to $Q$

==
$ 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; theta_pi)
$ 

Instead of taking the gradient to maximize $bb(E)[cal(G)(bold(tau)) | s_0; theta_pi]$ we try and maximize the Q function instead?

$ Q(s_0, a_0, theta_pi) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma Q(s_1, mu(s_1, theta_pi), theta_pi)$

Take the gradient of both sides

$ nabla_theta_pi Q(s_0, a_0, theta_pi) = nabla_theta_pi [bb(E)[cal(R)(s_1) | s_0, a_0] + gamma Q(s_1, mu(s_1, theta_pi), theta_pi)] $

==
$ nabla_theta_pi Q(s_0, a_0, theta_pi) = nabla_theta_pi [bb(E)[cal(R)(s_1) | s_0, a_0] + gamma Q(s_1, mu(s_1, theta_pi), theta_pi)] $

Initial reward only depends on action, not $theta_pi$ -- gradient is zero 

$ nabla_theta_pi Q(s_0, a_0, theta_pi) = nabla_theta_pi [gamma Q(s_1, mu(s_1, theta_pi), theta_pi)] $

Pull out $gamma$

$ nabla_theta_pi Q(s_0, a_0, theta_pi) = gamma nabla_theta_pi Q(s_1, mu(s_1, theta_pi), theta_pi) $

Use chain rule

$ nabla_theta_pi Q(s_0, a_0, theta_pi) = gamma nabla_a_1 [ Q(s_1, a_1, theta_pi) bar.v_(a_1 = mu(s_1, theta_pi)) ] dot nabla_theta_pi mu(s_1, theta_pi) $

==

$ nabla_theta_pi Q(s_0, a_0, theta_pi) = gamma nabla_a_1 [ Q(s_1, a_1, theta_pi) bar.v_(a_1 = mu(s_1, theta_pi)) ] dot nabla_theta_pi mu(s_1, theta_pi) $

What is the gradient of $Q(s_1, a_1, theta_pi)$?

$ nabla_theta_pi Q(s_1, a_1, theta_pi) = gamma nabla_a_2 [ Q(s_2, a_2, theta_pi) bar.v_(a_2 = mu(s_2, theta_pi)) ] dot nabla_theta_pi mu(s_2, theta_pi) $

$ nabla_theta_pi Q(s_2, a_2, theta_pi) = gamma nabla_a_3 [ Q(s_3, a_3, theta_pi) bar.v_(a_3 = mu(s_3, theta_pi)) ] dot nabla_theta_pi mu(s_3, theta_pi) $

We can see this is heading towards an intractable infinite product...

We will not find a nice analytic solution to $nabla_theta_pi Q(s_0, a_0, theta_pi)$

*Question:* Do we need an analytic solution for $nabla_theta_pi Q(s_0, a_0, theta_pi)$?

==

$ nabla_theta_pi Q(s_0, a_0, theta_pi) = gamma nabla_a_1 [ Q(s_1, a_1, theta_pi) bar.v_(a_1 = mu(s_1, theta_pi)) ] dot nabla_theta_pi mu(s_1, theta_pi) $

Let us consider a neural network $Q$ function

$ nabla_theta_pi Q(s_0, a_0, theta_pi, theta_Q) = gamma nabla_a_1 [ Q(s_1, a_1, theta_pi, theta_Q) bar.v_(a_1 = mu(s_1, theta_pi, theta_Q)) ] dot nabla_theta_pi mu(s_1, theta_pi) $

If $Q$ is a neural network, it predicts the return without unrolling

*Question:* Do we need the analytical gradient of $Q$?

*Answer:* No, we can compute the gradient of a neural network $Q$

This relies on having an accurate $Q$!

==
$ theta_(pi, i+1) = theta_(pi, i) + alpha dot nabla_theta_pi Q(s_0, a_0, theta_(pi, i), theta_Q) $

$ nabla_theta_pi Q(s_0, a_0, theta_pi, theta_Q) = gamma nabla_a_1 [ Q(s_1, a_1, theta_pi, theta_Q) bar.v_(a_1 = mu(s_1, theta_pi, theta_Q)) ] dot nabla_theta_pi mu(s_1, theta_pi) $


We want to learn the parameters $theta_pi$ that maximize $Q$

In other words, $theta_pi$ will select actions that maximize $Q$

It is a max $Q$ policy over an infinite action space!

Use gradient ascent to find $theta_pi$ that provides $ argmax_(a in A) Q(s, a)$

We effectively do gradient ascent on the action space

We cannot take the max over an infinite action space

But we can do gradient ascent 


==

*Definition:* Deep Deterministic Policy Gradient (DDPG) jointly learns a $Q$ function for deterministic policy $mu$, and the policy $mu$

*Step 1:* Learn a $Q$ function for $mu$

$ theta_(Q, i+1) = argmin_(theta_(Q, i)) \ (Q(s_0, a_0, theta_(pi, i), theta_(Q, i)) - (hat(bb(E))[cal(R)(s_1) | s_0, a_0] + gamma Q(s_1, mu(s_1, theta_(pi, i)), theta_(pi, i), theta_(Q, i)))) $

*Step 2:* Learn a $mu$ that maximizes $Q$

$ theta_(pi, i+1) = \ theta_(pi, i) + alpha Q(s_0, mu(s_0, theta_pi) ) $

==
$ theta_(pi, i+1) = theta_(pi, i) + alpha dot Q(s_0, mu(s_0, theta_pi) ) $

$ theta_(Q, i+1) = argmin_(theta_(Q, i)) \ (Q(s_0, a_0, theta_(pi, i), theta_(Q, i)) - (hat(bb(E))[cal(R)(s_1) | s_0, a_0] + gamma Q(s_1, mu(s_1, theta_(pi, i)), theta_(pi, i), theta_(Q, i)))) $



*Question:* Is DDPG on-policy or off-policy?

*Answer:* Off-policy

Almost all off-policy actor critic methods are based on DDPG

==
TODO: Exploration

==
```python
mu = Sequential([
    Linear(state_size, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, action_dims),
])
def bound_action(action, upper, lower): 
    return (upper + lower / 2) 
        * tanh(action - (upper - lower) / 2)
def sample_action(mu, state, A_bounds, noise):
    action = mu(state)
    noisy_action = action + noise # Explore
    return bound_action(noisy_action, *A_bounds)

```

==
```python
Q = Sequential([
    # Different from DQN network
    # Input action and state, output one value
    Lambda(lambda s, a: concatenate(s, a)),
    Linear(state_size + action_dims, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, 1),
])
```

==
```python
while not terminated:
    # Exploration: make sure actions within action space!
    action = sample_action(mu, state, bounds, noise)
    transition = env.step(action)
    replay_buffer.append(transition)
    data = replay_buffer.sample()
    # Theta_pi params are in mu neural network
    # Argnums tells us differentiation variable
    J_Q = Q_TD_loss(theta_Q, theta_T, mu, data)
    J_mu = mu_loss(mu, theta_Q, data)
    theta_Q, mu = apply_updates(J_Q, J_mu, ...)
    # Target network usually necessary
    if step % 200 == 0:
        theta_T = theta_Q
```

==
```python
def Q_TD_loss(theta_Q, theta_T, theta_pi, data):
    Qnet = combine(Q, theta_Q)
    Tnet = combine(Q, theta_T) # Target network
    # Predict Q values for action we took
    prediction = vmap(Qnet)(data.state, data.action)
    # Now compute labels
    next_action = vmap(mu)(data.next_state)
    # NOTE: No argmax! Mu approximates argmax
    next_Q = vmap(Tnet)(data.next_state, next_action)
    label = reward + gamma * data.done * next_Q
    return (prediction - label) ** 2


```
==
```python
def mu_loss(mu, theta_Q, data):
    # Find the action that maximizes the Q function
    Qnet = combine(Q, theta_Q)
    # Instead of multiply, chain rule -- plug action into Q
    action = vmap(mu)(data.state)
    q_value = vmap(Qnet)(data.state, action)
    # Update the policy parameters to maximize the Q value
    # Gradient ascent but we min loss, use negative
    return -q_value
```


= Max Entropy RL
// SAC is arguably the best algorithm we have today
// DDPG can learn good policies, but exploration is not so good 
// Random policies lead to better behavior than deterministic + noise
// Can we make DDPG stochastic?
// Introduce max ent objective
// Use reparameterization trick from VAE
    // Do not sum over all possible actions
    // Instead, backprop through reparam node
// SAC

==
Entropy of a policy tells us how random it is 

$ H(pi (a | s; theta_pi)) $

#side-by-side[
    #high_ent
][
    #low_ent
]

*Question:* Which policy has higher entropy?

Left policy, more random

==
In maximum entropy RL, we change the objective

$ argmax_(theta_pi) bb(E)[ cal(G)(bold(tau)) | s_0; theta_pi] = argmax_(theta_pi) sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; theta_pi] $

$ argmax_(theta_pi) bb(E)[ cal(H)(bold(tau)) | s_0; theta_pi] = \ argmax_(theta_pi) sum_(t=0)^oo gamma^t (bb(E)[cal(R)(s_(t+1)) | s_0; theta_pi] + H(pi (dot | s_t; theta_pi))) $

We want a policy that is both random and maximizes the return

==
$ argmax_(theta_pi) bb(E)[ cal(H)(bold(tau)) | s_0; theta_pi] = \ argmax_(theta_pi) sum_(t=0)^oo gamma^t (bb(E)[cal(R)(s_(t+1)) | s_0; theta_pi] + H(pi (dot | s_t; theta_pi))) $

*Question:* Why do want policy entropy? Less optimal returns?

*Answer:* No theoretical reason, helpful in practice
- Better exploration during training
- More robust in uncertain environments (robotics)
    - If one approach fails, can try another
- More stable optimization (explain further in offline RL)

==
DDPG based on deterministic policy, how can we use a random policy?

Reparameterization trick (used in VAE) 

Policy is deterministic, given inputs
$ a = f(theta_pi, s, sigma, eta) = mu(s, theta_pi) + sigma * eta; quad eta tilde N(0, 1) $

Abuse notation, write as 

$ a tilde pi (a | s; theta_pi) $

But really, $pi$ is deterministic if we know $eta$
$ a = mu(s, theta_pi, eta) $

Just cannot control one input...

==

*Definition:* Soft Actor Critic (SAC) is DDPG + max entropy objective 

*Step 1:* Learn a $Q$ function for $mu$

#text(size: 23pt)[
$ theta_(Q, i+1) = argmin_(theta_(Q, i)) \ (Q(s_0, a_0, theta_(pi, i), theta_(Q, i)) - (hat(bb(E))[cal(R)(s_1) | s_0, a_0] + H(pi(a | s_0)) + gamma Q(s_1, a_1, theta_(pi, i), theta_(Q, i))))^2 $
]

*Step 2:* Learn a $pi$ that maximizes $Q$

$ theta_(pi, i+1) = theta_(pi, i) + alpha dot Q(s_0, mu(s_0, theta_pi, eta) ) $

Where $eta tilde N(0, 1); quad a_1 tilde pi (dot | s_1; theta_pi)$

==
Like PPO, there are many variants of SAC
    - Double Q function
    - Lagrangian entropy adjustment
    - Reduced variance gradients

Like PPO, SAC is also very complicated

It also introduces a number of necessary "implementation tricks"

I will not show code, because I don't remember all the tricks

CleanRL describes many necessary tricks

https://docs.cleanrl.dev/rl-algorithms/sac/#implementation-details_1

==
#side-by-side[
    DDPG $=>$ A2C
][
    SAC $=>$ PPO
]

SAC tends to perform better in papers

I suggest you try DDPG before SAC
- DDPG is much easier to implement
- Fewer hyperparameters/tricks
- Tuned DDPG can likely outperform untuned SAC



/*
==
```python
model = Sequential([
    Linear(state_size, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, 2 * action_dims),
    Lambda(lambda x: split(x, 2)) # mean and log std
])
```
==
```python
def bound_action(action, upper, lower): 
    return (upper + lower / 2) 
        * tanh(action - (upper - lower) / 2)
        
def sample_action(model, state, A_bounds, noise):
    mean, log_std = model(state)
    noisy_action = normal(mean, exp(log_std))
    return bound_action(noisy_action, *A_bounds)

```

==
```python
Q = Sequential([
    # Different from DQN network
    # Input action and state, output one value
    Lambda(lambda s, a: concatenate(s, a)),
    Linear(state_size + action_dims, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, 1),
])
```

==
```python
while not terminated:
    # Exploration: make sure actions within action space!
    action = sample_action(mu, state, bounds, noise)
    transition = env.step(action)
    replay_buffer.append(transition)
    data = replay_buffer.sample()
    # Theta_pi params are in mu neural network
    # Argnums tells us differentiation variable
    J_Q = Q_TD_loss(theta_Q, theta_T, mu, data)
    J_mu = mu_loss(mu, theta_Q, data)
    theta_Q, mu = apply_updates(J_Q, J_mu, ...)
    # Target network usually necessary
    if step % 200 == 0:
        theta_T = theta_Q
```

==
```python
def Q_TD_loss(theta_Q, theta_T, theta_pi, data):
    Qnet = combine(Q, theta_Q)
    Tnet = combine(Q, theta_T) # Target network
    # Predict Q values for action we took
    prediction = vmap(Qnet)(data.state, data.action)
    # Now compute labels
    next_action = vmap(mu)(data.next_state)
    # NOTE: No argmax! Mu approximates argmax
    next_Q = vmap(Tnet)(data.next_state, next_action)
    entropy = -log(std)
    label = reward + gamma * data.done * next_Q
    return (prediction - label) ** 2


```
==
```python
def mu_loss(mu, theta_Q, data):
    # Find the action that maximizes the Q function
    Qnet = combine(Q, theta_Q)
    # Instead of multiply, chain rule -- plug action into Q
    action = vmap(mu)(data.state)
    q_value = vmap(Qnet)(data.state, action)
    # Update the policy parameters to maximize the Q value
    # Gradient ascent but we min loss, use negative
    return -q_value
```
*/
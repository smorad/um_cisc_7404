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

#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Imitation Learning],
    subtitle: [CISC 7404 - Decision Making],
    author: [Steven Morad],
    institution: [University of Macau],
    logo: image("fig/common/bolt-logo.png", width: 4cm)
  ),
  //config-common(handout: true),
  header-right: none,
  header: self => utils.display-current-heading(level: 1)
)

#title-slide()

== Outline <touying:hidden>

#components.adaptive-columns(
    outline(title: none, indent: 1em, depth: 1)
)

= Getting Over It 
==
Project plans turned in

I want to highlight the most creative project plan

#side-by-side[
    _Getting Over It by Bennet Foddy_
][
    Group: Getting Over It
]

I asked for projects that can improve the world

No human should ever have to play _Getting Over It_

Training an agent to play instead can improve many human lives


https://youtu.be/8qGCleYV4cw?si=ynB0Idg5-TdAiAh9&t=74

==

Dr. Bennet Foddy teaches at NYU

His research focus is on addiction and reward/punishment 

==

#text(size: 23pt)[
    #quote(block: true)[
        This chapter compares the epidemiological and neuroscientific data on different addictions and addiction-like syndromes, from drug addiction to binge-eating disorders, gambling, and videogame addiction. It considers the various neurological and behavioral differences that can seem to differentiate these different behavioral syndromes, and it argues that these differences are not essential to the underlying behavioral condition that unifies various "addictive" behaviors. Based on these data, it is argued that *there is a hazard inherent in any rewarding operant behavior, no matter how apparently benign: that we may become genuinely "addicted" to any behavior that provides operant reward*. With this in mind, addiction is rightly seen as a possibility for any human being, not a product of the particular pharmacological or technological properties of any one particular substance or behavior.
    ]
]

==

We become addicted (gambling, drugs, etc) because of reward!

Our brain's reward function can be hacked

Drugs/gambling/etc reward is so powerful it overwhelms the rewards of normal life 

$ "study" + gamma "nice dinner" + gamma^2 "pain" + dots = 10 $

$ "no money" + gamma "angry family" + gamma^2 "pain" + dots + underbrace(gamma^n "addiction pleasure", "Too powerful") = 100 $

==
$ "study" + gamma "nice dinner" + gamma^2 "pain" + dots = 10 $

$ "no money" + gamma "angry family" + gamma^2 "pain" + dots + underbrace(gamma^n "addiction pleasure", "Too powerful") = 100 $

If you have no addiction, then you are not following an optimal policy

Optimal policy in humans *will* lead to bad behavior
- Addict behavior policy maximizes the return!

==

Bennet Foddy creates a game to demonstrate this 

$ "fall" + gamma "anger" + dots + gamma^n "win game" > "study" + gamma "exercise" + dots $

It is always interesting to consider our own reward functions

Humans are born with reward functions and cannot choose them

We can select good reward functions for artificial agents

LLMs are patient, intelligent, helpful because of reward function

= Finish DPG

= Imitation Learning
// Example problem
// Markov process with hidden rewards
    // Motivate why rewards are hidden
// Two types of IL, similar to policy gradient and Q learning
// IL is often much easier than RL in practice
// Does NOT require exploration, just fixed dataset
// But limited to copying behavior from humans
// Humans are not perfect or even good at many tasks
// Move 42? of AlphaGo is not a human move
// Imitation learning is great if you want an average policy
// If you want an optimal policy, you should consider RL

// Markov Control Process
// MDP but without reward (or hidden instead?)

==

#side-by-side[
#cimage("fig/11/flip.jpg")
][
*Example:* We want to learn a policy that does a backflip

What reward function should we use?

$cal(R)(s) =$ 
]

==

Policy will maximize the return, but not exhibit desired behavior

Writing reward functions can be difficult

Humans are generally bad at writing reward functions

Rewards are particularly difficult when interacting with humans
- Be friendly
- Be polite
- Do not scare the humans
    - Do not do strange movements

==
In many cases, humans do not know the correct objective

It is often easier to demonstrate good behavior than create objectives

$ pi(a | s_0, theta_"brain"), pi(a | s_1, theta_"brain"), dots $

Demonstrate good behavior in enough states, model can generalize

I want to introduce a formalism to model the problem

==
*Definition:* A Hidden-Reward MDP (HRMDP) consists of:
- MDP with a hidden reward function
- Dataset $bold(D)$ from following an optimal policy $pi (a | s; theta_beta)$

$ (S, A, cal(R), Tr, gamma, bold(D)) $

$ s_(t+1) tilde Tr(dot | s_t, a_t) $

$ cal(R)(s_(t+1)) = ? $

$ bold(D) = mat(bold(tau)_1, bold(tau)_2, dots) = mat(
    vec((s_0, a_0), (s_1, a_1), dots.v),
    vec((s_0, a_0), (s_1, a_1), dots.v),
    dots
)
$

==
https://www.youtube.com/watch?v=4N4czAm61Fc



= Behavior Cloning
// Hard to code good rewards for many tasks
// Humans have some policy
// Collect a dataset of a human policy
// Can we infer the human policy?

// Cross entropy objective
// Is just KL minimization

// Quadratic error
// Out of distribution error

==
#side-by-side[
    Optimal policy $pi (a | s; theta_beta)$
][
    *Question:* What is our objective?
]


$ pi (a | s; theta_beta) = pi (a | s; theta_pi) $

$ argmin_(theta_pi) (pi (a | s; theta_beta) - pi (a | s; theta_pi))^2 $

*Question:* Does this work?

*Answer:* No, $pi(a | s)$ is a distribution not a scalar

*Question:* How can we measure the difference of two distributions?

*Answer:* KL measures difference in distributions

==
$ KL(Pr(X), Pr(Y)) = P(X) log P(X) / P(Y) $

Minimize difference between $pi (a | s; theta_beta)$ and $pi (a | s; theta_pi)$

$ argmin_(theta_pi) KL(pi (a | s; theta_beta), pi (a | s; theta_pi)) $

$ argmin_(theta_pi) pi (a | s; theta_beta) log (pi (a | s; theta_beta)) / (pi (a | s; theta_pi)) $

==

$ argmin_(theta_pi) pi (a | s; theta_beta) log (pi (a | s; theta_beta)) / (pi (a | s; theta_pi)) $

Log of divisors is difference of logs

$ argmin_(theta_pi) pi (a | s; theta_beta) [ log(pi (a | s; theta_beta)) - log (pi (a | s; theta_pi)) ] $

Distribute

$ argmin_(theta_pi) pi (a | s; theta_beta)  log pi (a | s; theta_beta) - pi (a | s; theta_beta) log pi (a | s; theta_pi)  $

==

$ argmin_(theta_pi) pi (a | s; theta_beta)  log pi (a | s; theta_beta) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $

First term is constant with respect to $theta_pi$ (only depends on $theta_beta$)

Can ignore for optimization

$ argmin_(theta_pi) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $

This is the *cross-entropy* objective

*Question:* Have we seen this objective in deep learning?

*Answer:* Classification loss

==
$ argmin_(theta_pi) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $

*Question:* Which $a, s$ do we compute $argmin$ over?

$ argmin_(theta_pi) sum_(s, a in bold(D)) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $

==

*Definition:* Behavior cloning uses *supervised learning* for decision making. We minimize the cross-entropy loss between our dataset policy $theta_beta$ and our learned policy $theta_pi$

$ argmin_(theta_pi) sum_(s, a in bold(D)) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $

TODO formally define D

==

TODO Downsides of BC

= Coding

==
Similar to policy gradient

The policies and methods change depending on action space

Discrete actions use a categorical distribution

Continuous actions usually use normal distribution
- Can use other distributions (beta, etc)

==
```python
policy = Sequential([
    Linear(state_size, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, hidden_size),
    Lambda(leaky_relu),
    # Output log probabilities
    Linear(hidden_size, action_size),
])
```

==
The `sample_action` method is exactly the same a policy gradient
```python
def sample_action(model, state, key):
    z = model(state)
    # BE VERY CAREFUL, always read documentation
    # Sometimes takes UNNORMALIZED logits, sometimes probs
    action_probs = softmax(model, state)
    a = categorical(key, action_probs)
    a = categorical(key, z) # Does not even use pi
    return a
```

==
```python
    def bc_loss(policy, states, actions):

```

==

*Question:* 

==

TODO Derive cross entropy from KL

Can use cross entropy loss instead

$ argmin_(theta_pi) -pi (a | s; theta_beta) log pi (a | s; theta_pi) $


$ sum_(s, a in bold(D)) pi (a | s; theta_beta) $

= Inverse RL
// One method is policy gradient
// One is value based
// But how can we learn a value function without a reward function?
// Instead of learning policy, learn reward function
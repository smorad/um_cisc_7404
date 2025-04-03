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

= Admin

==
TAs currently grading homework 1: #pause
    - Grades will be released over the next week on Moodle #pause
    - All grades should be released by Wednesday #pause

Homework 2 should be graded by the following Wednesday (April 16) #pause

==

I am currently grading quiz 2, 50% done, score released soon #pause
- I want scoring to be consistent for all students #pause
    - I grade exams myself (not TA), so grading is slow #pause

Highly multimodal distribution #pause
- Modes at 20%, 45%, and 80% #pause 
    - I drop lowest quiz score, if you did poorly study more next time #pause
- Some students received perfect scores, good job! #pause
    - He Enhao
    - Leonard Hangqin Zhuang
    - Qiao Yulin
    - Fu Zexin

= Getting Over It 
==
Project plans turned in #pause

Most plans look good, I will email 1-2 groups about their plans #pause

I want to highlight the most creative project plan (in my opinion) #pause

#side-by-side[
    _Getting Over It by Bennet Foddy_
][
    Group: Getting Over It
] #pause

I asked for projects that can improve the world #pause

No human should ever have to play _Getting Over It_ #pause

Training an agent to play instead can improve many human lives #pause

At university, my friend skipped school for a week to win this game #pause

https://youtu.be/8qGCleYV4cw?si=ynB0Idg5-TdAiAh9&t=74

==

Dr. Bennet Foddy (game author) teaches at NYU #pause

His research focus is on addiction and reward/punishment #pause 


#text(size: 24pt)[
    #quote(block: true)[
        This chapter compares ... data on different addictions ... from drug addiction to binge-eating disorders, gambling, and videogame addiction. ... Based on these data, it is argued that *there is a hazard inherent in any rewarding operant behavior, no matter how apparently benign: that we may become genuinely "addicted" to any behavior that provides operant reward*. With this in mind, addiction is rightly seen as a possibility for any human being, not a product of the particular pharmacological or technological properties of any one particular substance or behavior.
    ]
]

==

We become addicted (gambling, drugs, etc) because of reward! #pause

Drugs/gambling/etc reward is so powerful it overwhelms the rewards of normal life #pause

$ "study" + gamma "exercise" + gamma^2 "sleep" + dots = 10 $ #pause

$ "no money" + gamma "no sleep" + gamma^2 "pain" + dots + underbrace(gamma^n "addiction pleasure", "Too powerful") = 100 $ #pause

If you have no addiction, then you are not following an optimal policy #pause

Optimal policy in humans *will* lead to bad behavior #pause
- Addict behavior policy maximizes the return!

==

_Getting Over It_ represents this addiction #pause

$ "fall" + gamma "anger" + dots + gamma^n "win game" > "study" + gamma "exercise" + dots $ #pause

It is always interesting to consider our own reward functions #pause

Humans are born with reward functions and cannot choose them #pause

We can select good reward functions for artificial agents #pause

LLMs are patient, intelligent, helpful because of the reward function

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
#cimage("fig/11/flip.jpg") #pause
][
*Example:* You are a scientist at Boston Dynamics/Tencent Robotics/etc #pause

You need to release demos to impress the public #pause

You want to learn a backflip policy using RL #pause

*Question:* What reward function should you use? #pause
]

$cal(R)(s) =$ 

==

Policy will maximize the return, but not exhibit desired behavior #pause

Writing reward functions can be difficult #pause

Rewards are particularly difficult when interacting with humans #pause

We want our robot to: #pause
- Be friendly #pause
- Be polite #pause
- Not scare humans #pause

It is very hard to write a reward function for these behaviors

==
It is often easier to demonstrate good behavior than create rewards #pause

How would a human do a backflip? #pause

#v(1.5em)

$ pi(#pin(1)a_0#pin(2) | s_0, theta_"human"), pi(#pin(3)a_1#pin(4) | s_1, theta_"human"), pi(#pin(5)a_2#pin(6) | s_2, theta_"human") dots $ #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: top, height: 1.2em)[Jump] 

#pinit-highlight-equation-from((3,4), (3,4), fill: red, pos: bottom, height: 1.2em)[Tuck legs] 

#pinit-highlight-equation-from((5,6), (5,6), fill: red, pos: top, height: 1.2em)[Backward rotation] #pause

#v(1.5em)

In *imitation learning* we learn to imitate an expert policy

I want to introduce a formalism to model the problem

==
*Definition:* A Hidden-Reward MDP (HR-MDP) consists of: #pause
- MDP with a *hidden* reward function #pause
- Dataset $bold(X)$ from following an expert policy $pi (a | s; theta_beta)$ #pause

$ (S, A, cal(R), Tr, gamma, bold(X)) $ #pause

$ s_(t+1) tilde Tr(dot | s_t, a_t) $ #pause

$ cal(R)(s_(t+1)) = ? $ #pause

$ bold(X) = mat(bold(tau)_1, bold(tau)_2, dots) = mat(
    vec((s_0, a_0), (s_1, a_1), dots.v),
    vec((s_0, a_0), (s_1, a_1), dots.v),
    dots
)
$

==
https://www.youtube.com/watch?v=4N4czAm61Fc



= Behavioral Cloning
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
    Expert policy $pi (a | s; theta_beta)$ #pause
][
    *Question:* What is our objective? #pause
]


$ pi (a | s; theta_pi) = pi (a | s; theta_beta) $ #pause

$ argmin_(theta_pi) (pi (a | s; theta_beta) - pi (a | s; theta_pi))^2 $ #pause

*Question:* Does this work? #pause

*Answer:* No, $pi(a | s)$ is a distribution not a scalar #pause

*Question:* How can we measure the difference of two distributions? #pause

*Answer:* KL divergence measures difference in distributions

==
$ KL(Pr(X), Pr(Y)) = sum_(omega in Omega) Pr(X=omega) log Pr(X=omega) / Pr(Y=omega) $ #pause

Minimize difference between $underbrace(pi (a | s; theta_beta), Pr(X))$ and $underbrace(pi (a | s; theta_pi), Pr(Y))$ #pause

$ argmin_(theta_pi) space KL(pi (a | s; theta_beta), pi (a | s; theta_pi)) $ #pause

Plug policies into KL equation #pause

$ argmin_(theta_pi) sum_(a in A) pi (a | s; theta_beta) log (pi (a | s; theta_beta)) / (pi (a | s; theta_pi)) $

==

$ argmin_(theta_pi) sum_(a in A) pi (a | s; theta_beta) log (pi (a | s; theta_beta)) / (pi (a | s; theta_pi)) $ #pause

Log of divisors is difference of logs #pause

$ argmin_(theta_pi) sum_(a in A) pi (a | s; theta_beta) [ log(pi (a | s; theta_beta)) - log (pi (a | s; theta_pi)) ] $ #pause

Distribute behavior policy into difference #pause

$ argmin_(theta_pi) sum_(a in A) pi (a | s; theta_beta)  log pi (a | s; theta_beta) - pi (a | s; theta_beta) log pi (a | s; theta_pi)  $

==

$ argmin_(theta_pi) sum_(a in A) pi (a | s; theta_beta)  log pi (a | s; theta_beta) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $ #pause

First term is constant with respect to $theta_pi$ (only depends on $theta_beta$) #pause

Can ignore the first term for optimization purposes #pause

$ argmin_(theta_pi) sum_(a in A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $ #pause

This is the *cross-entropy* objective #pause

*Question:* Have we seen this objective in deep learning? #pause

*Answer:* Loss for classification tasks

==
$ argmin_(theta_pi) sum_(a in A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $ #pause

*Question:* Where does $s$ come from? #pause *Answer:* Dataset $bold(X)$ #pause

$ argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $ #pause

==

*Definition:* Behavioral cloning learns the parameters $theta_pi$ to match an expert policy $theta_beta$ that collected the dataset $bold(X)$ #pause

$ argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $ #pause

Behavioral cloning is a simple supervised learning algorithm!

==

$ argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $ #pause

*Question:* How do we evaluate this? #pause

If $A$ is discrete, we can sum over possible actions $a in A$ #pause
- Our expert policy will often be one-hot #pause
- $pi (a = a_* | s; theta_beta) = 1$ (action the expert took) #pause
- $pi (a != a_* | s; theta_beta) = 0$ (all other actions) #pause

What if $A$ is continuous (infinite)? 

==
$ argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $ #pause

If $A$ is continuous, we have an infinite sum #pause

$ argmin_(theta_pi) sum_(s in bold(X)) integral_(A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) dif a $ #pause

Not all integrals are solvable #pause

Need to be careful how we model $pi$, to make sure we can solve this

==

$ argmin_(theta_pi) sum_(s in bold(X)) integral_(A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) dif a $ #pause

To ensure we have an analytical solution to this integral: #pause
- Use Dirac delta expert policy $pi (a | s; theta_beta) = delta(a - a_*)$ #pause
- Use Gaussian learned policy $pi (a | s; theta_pi) = "Normal"(mu, sigma)$



==
$ argmin_(theta_pi) sum_(s in bold(X)) integral_(A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) dif a $ #pause

According to the exam, not everyone is comfortable with calculus #pause

We will go back to the infinite sum notation (less scary) #pause

$ argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $ 

==
$ argmin_(theta_pi) sum_(s in bold(X)) integral_(A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) dif a $

Many integrals do not have a known solution!

We must be careful how we model $pi$

Let learned policy be Gaussian and expert be Dirac delta, closed form

From exam, calculus can be confusing, pretend infinite sum instead

$ argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $

==

$ argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $

Plug in Dirac delta for expert

$ argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) - delta(a - #pin(1)a_*#pin(2)) log pi (a | s; theta_pi) $

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: top, height: 1.2em)[Expert action taken] 

Dirac delta zero everywhere except $a_*$, Dirac delta vanishes at $a_*$

$ argmin_(theta_pi) sum_(s in bold(X)) - delta(a - a_*) log pi (a=a_* | s; theta_pi) $

$ argmin_(theta_pi) sum_(s in bold(X)) - log pi (a=a_* | s; theta_pi) $
==
$ argmin_(theta_pi) sum_(s in bold(X)) - log pi (a=a_* | s; theta_pi) $

Replace learned policy with Gaussian PDF

$ "Normal"(x) = 1/2 sqrt(2 pi sigma) exp(- 1 / 2 ((x - mu) / sigma)^2 ) $

$ argmin_(theta_pi) sum_(s in bold(X)) - log [1/2 sqrt(2 pi sigma) exp(- 1 / 2 ((a_* - mu) / sigma)^2 )] $

==
$ argmin_(theta_pi) sum_(s in bold(X)) - log [1/2 sqrt(2 pi sigma) exp(- 1 / 2 ((a_* - mu) / sigma)^2 )] $

Log of products is sum of logs

$ argmin_(theta_pi) sum_(s in bold(X)) - log (1/2 sqrt(2 pi sigma)) - log( exp(- 1 / 2 ((a_* - mu) / sigma)^2 )) $

Log and exp cancel in second term

$ argmin_(theta_pi) sum_(s in bold(X)) - log (1/2 sqrt(2 pi sigma)) + 1 / 2 ((a_* - mu) / sigma)^2  $

==
$ argmin_(theta_pi) sum_(s in bold(X)) - log (1/2 sqrt(2 pi sigma)) + 1 / 2 ((a_* - mu) / sigma)^2 $

Clean this up slightly

$ argmin_(theta_pi) sum_(s in bold(X)) - log (1/2 sqrt(2 pi sigma)) + 1 / 2 ((a_* - mu) / sigma)^2 $


==
$ argmin_(theta_pi) KL(pi (a | s; theta_beta), pi (a | s; theta_pi)) $

For continuous policies, we still want the same objective

The loss function changes depending on the distributions

For some distributions, computing the KL can be difficult/intractable

Model the policy as a normal distribution for closed-form solution

==
Start with the categorical form

$ argmin_(theta_pi) sum_(bold(tau) in bold(X)) sum_(s, a in bold(tau)) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $

Reduce for a dirac delta expert policy and normal learned policy

$ argmin_(theta_pi) sum_(bold(tau) in bold(X)) sum_(s, a in bold(tau)) - delta(a - a^*) log pi (a | s; theta_pi) $


==

*Definition:* Behavioral cloning uses *supervised learning* for decision making. We minimize the cross-entropy loss between our dataset policy $theta_beta$ and our learned policy $theta_pi$

$ argmin_(theta_pi) sum_(s, a in bold(X)) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $

==

Behavioral cloning seems very powerful!
- No need for reward function
- No need for exploration, learn from fixed dataset

*Question:* What are some disadvantages of BC?

==
*Limitation:* Imperfect policy

Usually, we collect datasets with human operators $theta_beta$
- Human driver
- Human controlling robot arm
- Human surgeon

Humans can be very bad drivers!

Humans are bad at controlling robot arms

Human surgeons are not as precise as machines

The best policy we can learn is $pi (a | s; theta_pi ) approx underbrace(pi (a | s; theta_beta), "Human policy")$

==
Ok, let us assume we have very good human policies

*Question:* Any other disadvantages?

Humans often stay in small regions of state space

==

Consider our state distribution function 

$ Pr (s_(n+1) | s_0; theta_pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ) $

We can think about which states humans spend time in

$ bb(E) [ Pr (s_(n+1) | s_0; theta_pi) ] $

We call this the stationary state distribution

$ d(theta_pi) = Pr (s_1 | s_0; theta_pi) $



==

- Limited by the dataset
    - Human policies are not perfect, we can only be as good as humans
    - Dataset may not cover
- Often, dataset collected using humans

TODO Downsides of BC
// Often dataset is not optimal policy
// Cannot be better than the dataset
// Does not necessarily generalize well
// Quadratic error


= Coding

==
Similar to policy gradient

The policies and methods change depending on action space

Discrete actions use a categorical distribution

Continuous actions usually use normal distribution
- Can use other distributions (beta, etc)

Start with discrete actions, then do continous

==
Implement a categorical policy network

```python
model = Sequential([
    Linear(state_size, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, hidden_size),
    Lambda(leaky_relu),
    # Output logits (real numbers)
    Linear(hidden_size, action_size),
])
```
Identical to policy gradient

==
Next, we need to sample actions from our policy network
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
Again, identical to policy gradient

==
Next, implement discrete loss function
```python
    def bc_loss(model, states, actions):
        # Often, we can't know the expert action distribution
        # We only have the taken expert action
        # Taken action has p=1, all other actions p=0
        # Represent as a one-hot vector
        expert_probs = actions
        log_policy_probs = log_softmax(vmap(model)(states))
        # Log loss, can reduce over batch using mean or sum
        bce_loss = -sum(
            expert_probs * log_policy_probs, axis=1).mean()
        return bce_loss
```
==
Now, consider Gaussian policy (continuous actions)

Gaussian policy network

```python
model = Sequential([
    Linear(state_size, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, hidden_size),
    Lambda(leaky_relu),
    # Output mu and log_sigma 
    Linear(hidden_size, 2 * action_size),
    Lambda(x: split(x, 2))
])
```
Same as policy gradient

==
Next, we need to sample actions from our policy network
```python
def sample_action(model, state, key):
    mu, log_sigma = model(state)
    # Reparameterization trick
    noise = random.normal(key, (action_size,))
    a = mu + exp(log_sigma) * noise
    return a
```
==
Finally, implement continuous loss function
```python
    def bc_loss(model, states, actions):
        expert_probs = actions # Dirac delta
        mu, log_std = vmap(model)(states)
        log_policy_probs = log_softmax(vmap(model)(states))
        # Log loss, can reduce over batch using mean or sum
        bce_loss = -sum(
            expert_probs * log_policy_probs, axis=1).mean()
        return bce_loss
```

==
The training loop is much easier than RL
```python
model = Sequential(...)
# Just supervised learning
for batch in dataset:
    states, actions = batch
    grad(bc_loss)()    

```

==

= DAgger
// Dagger is BC, but we query the person for help
==

= Inverse RL
// One method is policy gradient
// One is value based
// But how can we learn a value function without a reward function?
// Instead of learning policy, learn reward function
// Key idea behavior cloning has no notion of the goal
    // Distance to goal example, BC cannot generalize but if we know the reward function, we can
    // Small errors accumulate, no way to correct
==
$ sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1), theta_R) | s_0; theta_beta ] >= sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1), theta_R) | s_0; theta_pi]; quad forall theta_pi $

Many reward functions satisfy these constraints!
- $cal(R)(s) = 0; quad s in S$

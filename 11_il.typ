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
$ KL(Pr(X), Pr(Y)) = sum_(omega in Omega_X) Pr(X=omega) log Pr(X=omega) / Pr(Y=omega) $ #pause

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



/*
==
$ argmin_(theta_pi) sum_(s in bold(X)) integral_(A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) dif a $ #pause

According to the exam, not everyone is comfortable with calculus #pause

We will go back to the infinite sum notation (less scary) #pause

$ argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $ #pause

But keep in mind that we select distributions with a analytically-solvable integral
*/
==
$ argmin_(theta_pi) sum_(s in bold(X))  integral_(A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) dif a $ #pause

To ensure we have an analytical solution to this integral: 
- Use Dirac delta expert policy $pi (a | s; theta_beta) = delta(a - a_*)$ 
- Use Gaussian learned policy $pi (a | s; theta_pi) = "Normal"(mu, sigma)$ #pause

Plug our policies into the cross entropy objective #pause

#v(1.2em)
$ argmin_(theta_pi) sum_(s in bold(X)) integral_A - underbrace(delta(a - #pin(1)a_*#pin(2)), "Expert policy") log pi (a | s; theta_pi) dif a $
#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: top, height: 1.2em)[Expert action taken] 

==

$ argmin_(theta_pi) sum_(s in bold(X)) integral_(A) - underbrace(delta(a - a_*), "Expert policy") log pi (a | s; theta_pi) dif a $

*Question:* What happens to $integral_(A) delta(a - a_*) f(a) dif a$? #pause

*Answer:* Becomes $f(a=a_*)$ #pause

$ argmin_(theta_pi) sum_(s in bold(X)) cancel(integral_(A) - delta(a - a_*)) log pi (a | s; theta_pi) cancel(dif a) $

$ argmin_(theta_pi) sum_(s in bold(X)) - log pi (a=a_* | s; theta_pi) $

==
$ argmin_(theta_pi) sum_(s in bold(X)) - log pi (a=a_* | s; theta_pi) $ #pause

Now, plug in Gaussian distribution for learned policy #pause

$ pi (a=a_* | s; theta_pi) = "Normal"(a=a_* | mu, sigma) = 1 / sqrt(2 pi sigma^2) exp(- (a_* - mu)^2 / (2 sigma^2) ) $ #pause

$ argmin_(theta_pi) sum_(s in bold(X)) - log [1 / sqrt(2 pi sigma^2) exp(- (a_* - mu)^2 / (2 sigma^2) )] $ 

==
$ argmin_(theta_pi) sum_(s in bold(X)) - log [1 / sqrt(2 pi sigma^2) exp(- (a_* - mu)^2 / (2 sigma^2) )] $ #pause

Log of products is sum of logs #pause

$ argmin_(theta_pi) sum_(s in bold(X)) - log (1 / sqrt(2 pi sigma^2)) - log( exp(- (a_* - mu)^2 / (2 sigma^2) )) $ #pause

Log of divisors is difference of logs #pause

$ argmin_(theta_pi) sum_(s in bold(X)) - log (1) + log(sqrt(2 pi sigma^2)) - log( exp(- (a_* - mu)^2 / (2 sigma^2) )) $

==
$ argmin_(theta_pi) sum_(s in bold(X)) - log (1) + log(sqrt(2 pi sigma^2)) - log( exp(- (a_* - mu)^2 / (2 sigma^2) )) $ #pause

$log(1) = 0$ #pause

$ argmin_(theta_pi) sum_(s in bold(X)) log(sqrt(2 pi sigma^2)) - log( exp(- (a_* - mu)^2 / (2 sigma^2) )) $ #pause

Rewrite $sqrt(dots)$ as power #pause

$ argmin_(theta_pi) sum_(s in bold(X)) log((2 pi sigma^2)^(1/2)) - log( exp(- (a_* - mu)^2 / (2 sigma^2) )) $ 

==
$ argmin_(theta_pi) sum_(s in bold(X)) log((2 pi sigma^2)^(1/2)) - log( exp(- (a_* - mu)^2 / (2 sigma^2) )) $ #pause

Log of power is product of power and log #pause

$ argmin_(theta_pi) sum_(s in bold(X)) 1/2 log(2 pi sigma^2) - log( exp(- (a_* - mu)^2 / (2 sigma^2) )) $ #pause

Now simplify the second term, $log$ and $exp$ cancel #pause

$ argmin_(theta_pi) sum_(s in bold(X)) 1/2 log(2 pi sigma^2) + (a_* - mu)^2 / (2 sigma^2) $ 

==
$ argmin_(theta_pi) sum_(s in bold(X)) 1/2 log(2 pi sigma^2) + (a_* - mu)^2 / (2 sigma^2) $ #pause

Since this is an optimization problem, we can drop the constant $2 pi$ #pause

$ argmin_(theta_pi) sum_(s in bold(X)) 1/2 log sigma^2 + (a_* - mu)^2 / (2 sigma^2) $ #pause

Clean up a bit by factoring #pause

$ argmin_(theta_pi) sum_(s in bold(X)) 1/2 (log sigma^2 + (a_* - mu)^2 / (sigma^2)) $ #pause

==
For a Gaussian policy, we minimize the following objective #pause

$ argmin_(theta_pi) sum_(s in bold(X)) 1/2 (log sigma^2 + (a_* - mu)^2 / (sigma^2)) $ #pause

*Note:* We derive the loss function for a Gaussian policy gradient loss the exact same way

/*
==
To summarize, for discrete action spaces we use the cross entropy loss #pause

$ argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $ #pause

For continuous actions, we pick special distributions so the cross entropy loss is tractable #pause

Dirac delta expert and learned Gaussian policy, cross entropy loss #pause

#v(1.5em)

$ argmin_(theta_pi) sum_(s in bold(X)) 1/2 log(2 pi #pin(7)sigma#pin(8)^2) + (#pin(1)a_*#pin(2) - #pin(3)mu#pin(4))^2 / (2 #pin(5)sigma#pin(6)^2) $ #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: top, height: 1.2em)[Expert action] 
#pinit-highlight-equation-from((5,6), (5,6), fill: blue, pos: bottom, height: 1.2em)[Policy outputs] 
#pinit-highlight(3,4, fill: blue.transparentize(80%))
#pinit-highlight(7,8, fill: blue.transparentize(80%))
*/

==

*Definition:* Behavioral cloning uses *supervised learning* for decision making, minimizing the cross-entropy between expert $theta_beta$ and our $theta_pi$

$ argmin_(theta_pi) sum_(s, a in bold(X)) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $

For continuous actions, we pick special distributions so the cross entropy loss is tractable (Dirac delta $theta_beta$, Gaussian $theta_pi$) #pause

#v(1.5em)

//$ argmin_(theta_pi) sum_(s in bold(X)) 1/2 log(2 pi #pin(7)sigma#pin(8)^2) + (#pin(1)a_*#pin(2) - #pin(3)mu#pin(4))^2 / (2 #pin(5)sigma#pin(6)^2) $ #pause

$ argmin_(theta_pi) sum_(s in bold(X)) 1/2 (log#pin(5)sigma#pin(6)^2 + (#pin(1)a_*#pin(2) - #pin(3)mu#pin(4))^2 / (#pin(7)sigma#pin(8)^2)) $ #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: top, height: 1.2em)[Expert action] 
#pinit-highlight-equation-from((7,8), (7,8), fill: blue, pos: bottom, height: 1.2em)[Policy outputs] 
#pinit-highlight(3,4, fill: blue.transparentize(80%))
#pinit-highlight(5,6, fill: blue.transparentize(80%))

= Coding

==
Similar to policy gradient, just with different loss function #pause

The policies and methods change depending on action space #pause

Discrete actions use a categorical distribution #pause

Continuous actions usually use normal distribution #pause

Start with discrete actions, then do continous

==
Implement a model for a categorical policy #pause

```python
model = Sequential([
    Linear(state_size, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, hidden_size),
    Lambda(leaky_relu),
    # Output logits (real numbers)
    Linear(hidden_size, action_size),
])
``` #pause

Identical to policy gradient



==
Next, implement discrete loss function #pause

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
Finally, to run our policy we sample actions from our policy #pause

```python
def sample_action(model, state, key):
    z = model(state)
    # BE VERY CAREFUL, always read documentation
    # Sometimes takes UNNORMALIZED logits, sometimes probs
    action_probs = softmax(model, state)
    a = categorical(key, action_probs)
    a = categorical(key, z) # Does not even use pi
    return a
``` #pause
Identical to policy gradient
==

Now, consider Gaussian policy (continuous actions) #pause 

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
``` #pause

Same as policy gradient

==
Implement continuous loss function #pause

Use simplified cross entropy (Dirac-Gaussian) #pause

```python
def bc_loss(model, states, actions):
    expert_probs = actions # Dirac delta
    mu, log_std = vmap(model)(states)
    # Gaussian CE, also called Gaus. Neg. Log Likelihood
    gnll_loss = log_std + 0.5 * ( 
        (mu - action)**2 / exp(log_std)**2
    ) 
    return gnll_loss
```

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
The training loop is much simpler than RL #pause

```python
model = Sequential(...)
opt_state = ...
# Just supervised learning
for batch in dataset:
    states, actions = batch
    J = grad(bc_loss)(model, states, actions)
    update = optim.update(J, opt_state)
    model = apply_updates(update, model)
``` #pause

Then deploy the policy #pause

```python
a_t = sample_action(model, s_t, key)
```

= Applications
==

Behavioral cloning seems very powerful! #pause
- No need for reward function #pause
- No need for exploration, learn from fixed dataset #pause
- Simpler to implement than RL #pause
- More stable to train than RL #pause

Sounds very promising, why do we care about RL? #pause

*Question:* What are some disadvantages of BC?

==
#side-by-side[
    #cimage("fig/11/texting.jpg", height: 80%)

][
    *Limitation:* Imperfect expert #pause

    Dataset is following an "expert" $theta_beta$ #pause

    Humans are not reliable experts in many cases #pause

    You will learn a policy that drives like it is texting
]


==
Even where all the data is from a reliable "expert", we have problems

Consider a human surgeon #pause

Human surgeons are not as fast or precise as machines #pause

Even the best machine will be no better than a human surgeon #pause

$ pi (a | s; theta_pi ) approx underbrace(pi (a | s; theta_beta), "Human policy") $ #pause

*Question:* Any other issues?

==
*Limitation:* Humans limited to small regions of state space #pause

Humans are very bad at exploring #pause

There will be very few crashes in a self driving dataset #pause

When the policy is about to crash, the state will be out of distribution #pause

The policy will be unable to avoid crashing #pause

In practice, BC policies generalizes much worse than RL policies #pause

Small errors in the learned policy eventually drive the policy to out of distribution states

==
One solution to out of distribution error is to collect more data #pause

*DAgger:* The agent asks an expert for help when it visit an out of distribution state #pause
    - This requires an expert to always be paying attention #pause

*Inverse RL:* We learn the reward function that the expert is following #pause

$ argmax_(theta_R) bb(E)[cal(G)(bold(tau)) | s_0; theta_beta] \ = argmax_(theta_R) sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) underbrace(cal(R)(s_(n+1), theta_R), "Learnable") dot Pr (s_(n + 1) | s_0; theta_beta) $ #pause

Then, we learn a policy $theta_pi$ using RL. This generalizes better than BC



/*

Consider our state distribution function 

$ Pr (s_(n+1) | s_0; theta_pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(s_(t+1) | s_t, a_t) dot pi (a_t | s_t; theta_pi) ) $

We can think about which states humans spend time in

$ bb(E) [ Pr (s_(n+1) | s_0; theta_pi) ] $

We call this the stationary state distribution

$ d(theta_pi) = Pr (s_1 | s_0; theta_pi) $


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
*/
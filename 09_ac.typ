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

#let pathology_left = { 
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
                x => normal_fn(1, 0.4, x),
            ) 

            })

            draw.line((1,0), (1,4), stroke: orange)
            draw.content((1,5), text(fill: orange)[$ a $])

            draw.line((2,0), (2,4), stroke: orange)
            draw.content((2,5), text(fill: orange)[$ a $])

            draw.line((3,0), (3,4), stroke: orange)
            draw.content((3,5), text(fill: orange)[$ a $])
    }
)}

#let pathology_right = { 
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
                x => normal_fn(-0.3, 0.4, x),
            ) 

            })

            draw.line((1,0), (1,4), stroke: orange)
            draw.content((1,5), text(fill: orange)[$ a $])

            draw.line((4,0), (4,4), stroke: orange)
            draw.content((4,5), text(fill: orange)[$ a $])

            draw.line((5,0), (5,4), stroke: orange)
            draw.content((5,5), text(fill: orange)[$ a $])
    }
)}

#let pathology_fix = { 
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
                x => normal_fn(-0.33, 0.1, x),
            ) 

            })

            for a in range(0, 7)  {
                draw.line((a,0), (a,4), stroke: orange)
                draw.content((a,5), text(fill: orange)[$ a $])

            }
    }
)}

#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Actor Critic I],
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

// TODO: Talk about final project
// Actor critic methods combine a learne policy and value/Q function
// We will talk about state of the art deep RL today
// Actor Critic (like A2C)
// Policy gradient without complete episodes
    // Monte Carlo returns require complete episodes
    // How can we train without infinite episodes
    // Use Q function 
    // Easier to implement value function
// Variance in returns can hurt learning
// Advantages
// A2C
// TRPO?
// PPO
// Second type of actor critic
// Learn a Q function that relies on argmax
// Cannot armax infinitely many actions
// Can learn a different policy that approximates argmax
// DDPG
// Deterministic policies can have bad exploration
// SAC

= Admin

==
How is homework 2?

==

Quiz next week

Study:
- Actor critic (today)
- Policy gradient
- Deep Q learning 
- Expected returns

= Final Project
==

Final project information is released

Suggest project and group members by next Friday (28th)

Find (or create) a gymnasium environment
- Ensure your task is MDP
- Can also try POMDP, but make sure you are prepared!
- Groups of 5, results should be impressive
- Due just before final exam study week

https://ummoodle.um.edu.mo/pluginfile.php/6900679/mod_resource/content/6/project.pdf

= Review

= Value Policy Gradient
// Monte Carlo returns require complete episodes
// How can we train without infinite episodes
// Use Q function 
// Easier to implement value function
// Called actor critic
// Policy is "actor" because it picks action
// Q function is "critic" because it scores the actor

==
Today, we will investigate modern forms of policy gradient

This is what many researchers use today for impressive tasks

One algorithm we learn today can play Pokemon

https://youtu.be/DcYLT37ImBY?si=jJfZyYwFkPYMJYMy

==
$ nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = bb(E)[ cal(G)(bold(tau)) | s_0; theta_pi] dot nabla_(theta_pi) log pi (a_0 | s_0; theta_pi) $ 

We previously computed the Monte Carlo policy gradient (REINFORCE) 

$ bb(E)[ cal(G)(bold(tau)) | s_0; theta_pi] = sum_(t=0)^oo gamma^t hat(bb(E))[cal(R)(s_(t+1)) | s_0; theta_pi] $

*Question:* Why don't we always use Monte Carlo? 

*Answer:* Requires an infinite return!

==
$ bb(E)[ cal(G)(bold(tau)) | s_0; theta_pi] = sum_(t=0)^oo gamma^t hat(bb(E))[cal(R)(s_(t+1)) | s_0; theta_pi] $

*Question:* Alternative to Monte Carlo return?

Can use $Q$ or $V$ function with TD objective

$ V(s_0, theta_pi) = bb(E)[cal(R)(s_1) | s_0, theta_pi] + gamma V(s_1, theta_pi) $

$ Q(s_0, a_0, theta_pi) = bb(E)[cal(R)(s_1) | s_0, a_0, theta_pi] + gamma Q(s_1, a_1, theta_pi) $

#side-by-side[
Before: \ $a_0 = argmax_(a in A) Q(s, a, theta_pi)$
][
Now: $a tilde pi (dot | s; theta_pi)$

$V = Q$ in this case
]

==
Policy gradient objective uses the return

$ nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] =  bb(E)[ cal(G)(bold(tau)) | s_0; theta_pi] dot nabla_(theta_pi) log pi (a_0 | s_0; theta_pi) $

Estimate return using value function

$ bb(E)[ cal(G)(bold(tau)) | s_0; theta_pi] = V(s_0, theta_pi) $

Combining $V"/"Q$ with policy gradient called *actor-critic*

#v(1em)
$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = #pin(1)V(s_0, theta_pi)#pin(2) dot nabla_(theta_pi) log #pin(3)pi (a_0 | s_0; theta_pi)#pin(4)
$



#pinit-highlight-equation-from((3,4), (3,4), fill: red, pos: top, height: 1.2em)[Actor pick action] 

#pinit-highlight-equation-from((1,2), (1,2), fill: blue, pos: bottom, height: 1.2em)[Critic gives actor score] 

==

*Definition:* Value Policy Gradient is an iterative process that jointly trains a policy network and value function 

$ 
theta_(pi, i+1) = theta_(pi, i) + alpha dot underbrace(V(s_0, theta_(pi, i), theta_(V, i)), "Expected return") dot nabla_(theta_(pi, i)) log pi (a_0 | s_0; theta_(pi, i))
$

$ theta_(V, i+1) = \ argmin_theta_(V, i) underbrace((V(s_0, theta_(pi, i), theta_(V,i)) - (hat(bb(E))[cal(R)(s_(1)) | s_0; theta_pi]+ not d dot gamma dot V(s_0, theta_(pi, i), theta_(V,i) )))^2, "TD error") $


Repeat process until convergence

Can train policy with single transition $s_0, a_0, s_1, r_0, d_0$


= Advantage Actor Critic
// Pathology where overflow/underflow of logits
    // All rewards negative, just pushes all probabilities down
    // All rewards positive, explodes
    // What to do?
    // Zero-center return using next-step
    // What do we want to measure?
    // If the action we take is better than the current policy, improve probs
    // If action is worse, take it less
    // If same, take the same
    // Call normalized return, advantage
    // First use V - Q
    // Replace Q with V

==
$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = V(s_0, theta_pi) dot nabla_(theta_pi) log pi (a_0 | s_0; theta_pi)
$

*Question:* Any scenarios where reward is always negative?

*Answer:* Distance to goal, $cal(R)(s_(t+1)) = -(s_(t+1) - s_g)^2$

*Question:* What happens if reward is always negative?

*Answer:* Return always negative

$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = - | V(s_0, theta_pi) | dot nabla_(theta_pi) log pi (a_0 | s_0; theta_pi)
$

Similar results if reward is always positive

$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = | V(s_0, theta_pi) | dot nabla_(theta_pi) log pi (a_0 | s_0; theta_pi)
$

==
$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = - | V(s_0, theta_pi) | dot nabla_(theta_pi) log pi (a_0 | s_0; theta_pi)
$

*Example:* Environment with a single state and continuous actions

Sample $k$ transitions for each gradient update

What if we cannot sample all possible actions?

#side-by-side[
    #pathology_left
][
    #pathology_right

]

==

#side-by-side[
    #pathology_left
][
    #pathology_right

]

Policy keeps oscillating, can destabilize learning

*Question:* If we take 8 actions, will this fix it?

https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExeGdqZm56NDgzcmY2Ym95dG13Ynczdm9lbDY0cGpjczdtMHBmcnJmMSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/MVUyVpyjakkRW/giphy.gif

#pathology_fix

*Question:* Any solutions?

Hint: Think about the mean of the return

*Answer:* Recenter return such that mean is zero

But we can do even better!

==
What if we:
- Almost never update policy
- Update the policy *only* if action is better/worse than expected

*Question:* What is the expected performance of the policy?

$ bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = V(s_0, theta_pi) $

*Question:* How can we tell the performance of a specific action?

$ bb(E)[cal(G)(bold(tau)) | s_0, a_0; theta_pi] = Q(s_0, a_0, theta_pi) $

*Question:* How can we tell if an action is better/worse than expected?

$ bb(E)[cal(G)(bold(tau)) | s_0, a_0 ; theta_pi] - bb(E)[cal(G)(bold(tau)) | s_0; theta_pi]  
     = Q(s_0, a_0, theta_pi) - V(s_0, theta_pi) $

==

$ A(s_0, a_0, theta_pi) = Q(s_0, a_0, theta_pi) - V(s_0, theta_pi) $

We call this the *advantage*, tells us if we should change policy

If action $a_0$ better than expected, increase policy probability

$ 
theta_pi = theta_pi + | A(s_0, a_0, theta_pi) | dot nabla_(theta_pi) log pi (a_0 | s_0; theta_pi)
$

If action $a_0$ worse than expected, reduce probability

$ 
theta_pi = theta_pi - | A(s_0, a_0, theta_pi) | dot nabla_(theta_pi) log pi (a_0 | s_0; theta_pi)
$

If action $a_0$ is as expected, do nothing

$ 
theta_pi = theta_pi + 0 dot nabla_(theta_pi) log pi (a_0 | s_0; theta_pi)
$

==

*Definition:* The advantage $A$ determines the relative advantage/disadvantage of taking an action $a_0$ in state $s_0$ for a policy $theta_pi$

$ A(s_0, a_0, theta_pi) = Q(s_0, a_0, theta_pi) - V(s_0, theta_pi) $

==
$ A(s_0, a_0, theta_pi) = Q(s_0, a_0, theta_pi) - V(s_0, theta_pi) $

Advantage requires both $Q$ and $V$

But earlier, we saw $Q=V$ in some circumstances

*Question:* Can we replace $Q$ with $V$? How? 

HINT: Think about TD error, use $s_1$

$ A(s_0, theta_pi) = -underbrace(V(s_0, theta_pi), "What we expect") + underbrace((bb(E)[cal(R)(s_(1)) | s_0; theta_pi] + not d gamma V(s_1, theta_pi)), "What happens")
$
Better than expected: $|A| > 0$, worse $|A| < 0$

// When we use advantage with policy gradient, call it A2C
// Written by same guy as DQN (Mnih)

==
*Definition:* Advantage actor critic (A2C) updates the policy and value functions using the advantage, and repeats until convergence

$ A(s_0, theta_pi, theta_V) = -V(s_0, theta_pi, theta_V) + (hat(bb(E))[cal(R)(s_(1)) | s_0; theta_pi] + not d gamma V(s_1, theta_pi, theta_V))
$

$ 
theta_(pi, i+1) = theta_(pi, i) + alpha dot underbrace(A(s_0, theta_(pi, i), theta_(V, i)), "Advantage") dot underbrace(nabla_(theta_(pi, i)) log pi (a_0 | s_0; theta_(pi, i)), "Policy gradient")
$

$ theta_(V, i+1) = \ argmin_theta_(V, i) underbrace((V(s_0, theta_(pi, i), theta_(V,i)) - (hat(bb(E))[cal(R)(s_(1)) | s_0; theta_pi] + not d gamma V(s_0, theta_(pi, i), theta_(V,i) )))^2, "TD error") $

= Off-Policy Gradient
// Policy gradient is an on-policy method
// Off policy vs on policy
// Return relies on parameters
// But what if the policy has only changed slightly
// Can we still somehow reuse this data
// Introduce importance sampling
==
$ nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = bb(E)[ cal(G)(bold(tau)) | s_0; theta_pi] dot nabla_(theta_pi) log pi (a_0 | s_0; theta_pi) $ 

*Question:* Is policy gradient off-policy or on-policy?

*Answer:* On-policy, expected return depends on $theta_pi$

*Question:* Why do we care about being off-policy?

*Answer:* Algorithm can reuse data, much more efficient

*Question:* What do we need to make policy gradient off-policy?

Need to be able to approximate $bb(E)[cal(G)(bold(tau)) | s_0; theta_pi]$ using $bb(E)[cal(G)(bold(tau)) | s_0; theta_beta]$

*Question:* Any math students know how to do this?

==
In *importance sampling*, we want to estimate 

$ bb(E)[f(x) | x tilde Pr (dot space ; theta_a)] $

Unfortunately, we only have data from

$ bb(E)[f(x) | x tilde Pr (dot space ; theta_b)] $

We can use their ratio to approximate the expectation

$ bb(E)[f(x) | x tilde Pr(dot | theta_a)] = bb(E)[
    f(x) dot (Pr (dot space ; theta_a) ) /  (Pr (dot space ; theta_b)) mid(|) x tilde Pr (dot space ; theta_b) ] 
$

*Question:* How can this make policy gradient off policy?

==

$ bb(E)[f(x) | x tilde Pr (dot space ; theta_a)] = bb(E)[
    f(x) dot (Pr (dot space ; theta_a) ) /  (Pr (dot space ; theta_b)) mid(|) x tilde Pr (dot space ; theta_b) ] 
$

Consider our current policy is $theta_pi$, we want $bb(E)[cal(G)(bold(tau)) | s_0; theta_pi]$

We use a *behavior policy* $theta_beta$ to collect data $bb(E)[cal(G)(bold(tau)) | s_0; theta_beta]$

$theta_beta$ can be an old policy or some other policy

#v(1.2em)

$ bb(E)[#pin(5)cal(R)(s_(1))#pin(6) | s_0; #pin(7)theta_pi#pin(8)] = bb(E)[
    #pin(1)cal(R)(s_1)#pin(2) dot (pi (a | s_0 ; theta_pi) ) /  (pi (a | s_0 ; theta_beta)) mid(|) s_0; #pin(3)theta_beta#pin(4)] 
$
#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: bottom, height: 2em)[Reward following $theta_beta$] 
#pinit-highlight(3, 4)

#pinit-highlight-equation-from((5,6), (5,6), fill: blue, pos: top, height: 2em)[Reward following $theta_pi$] 
#pinit-highlight(7, 8, fill: blue.transparentize(80%))

==
$ bb(E)[cal(R)(s_(1)) | s_0; theta_pi] = bb(E)[
    cal(R)(s_1) dot (pi (a | s_0 ; theta_pi) ) /  (pi (a | s_0 ; theta_beta)) mid(|) s_0; theta_beta] 
$

How does this actually work?

Rewrite without expectation to clarify

$ bb(E)[cal(R)(s_(1)) | s_0; theta_pi] = 
    underbrace(sum_(s_1 in S) cal(R)(s_1) sum_(a_0 in A) Tr(s_1 | s_0, a_0) pi (a_0 | s_0; theta_beta), "Expected reward") underbrace((pi (a_0 | s_0 ; theta_pi) ) /  (pi (a_0 | s_0 ; theta_beta)), "Correction") 
$

==

$ bb(E)[cal(R)(s_(1)) | s_0; theta_pi] = 
    underbrace(sum_(s_1 in S) cal(R)(s_1) sum_(a_0 in A) Tr(s_1 | s_0, a_0) pi (a_0 | s_0; theta_beta), "Expected reward") underbrace((pi (a_0 | s_0 ; theta_pi) ) /  (pi (a_0 | s_0 ; theta_beta)), "Correction") 
$

Terms cancel!

$ bb(E)[cal(R)(s_(1)) | s_0; theta_pi] = 
    sum_(s_1 in S) cal(R)(s_1) sum_(a_0 in A) Tr(s_1 | s_0, a_0) cancel(pi (a_0 | s_0; theta_beta)) (pi (a_0 | s_0 ; theta_pi) ) /  cancel(pi (a_0 | s_0 ; theta_beta)) 
$
$ bb(E)[cal(R)(s_(1)) | s_0; theta_pi] = 
    sum_(s_1 in S) cal(R)(s_1) sum_(a_0 in A) Tr(s_1 | s_0, a_0) pi (a_0 | s_0 ; theta_pi)  
$
Left with expression for expected reward following $theta_pi$

==
$ bb(E)[cal(R)(s_(1)) | s_0; theta_pi] = bb(E)[
    cal(R)(s_1) dot (pi (a | s_0 ; theta_pi) ) /  (pi (a | s_0 ; theta_beta)) mid(|) s_0; theta_beta] 
$

$ bb(E)[cal(R)(s_(1)) | s_0; theta_pi] = 
    sum_(s_1 in S) cal(R)(s_1) sum_(a_0 in A) Tr(s_1 | s_0, a_0) pi (a_0 | s_0; theta_beta)(pi (a_0 | s_0 ; theta_pi) ) /  (pi (a_0 | s_0 ; theta_beta)) 
$

We can apply the same approach to find the off-policy return

I won't derive it, just trust me

$ bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = bb(E)[
cal(G)(bold(tau)) product_(t=0)^oo (pi (a_t | s_t ; theta_pi) ) /  (pi (a_t | s_t ; theta_beta)) mid(|) s_0; theta_beta
]
$

==
// TODO: Should I use hat/approx here?

*Definition:* Off-policy gradient uses importance sampling to learn from off-policy data

$ bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = bb(E)[
cal(G)(bold(tau)) product_(t=0)^oo (pi (a_t | s_t ; theta_pi) ) /  (pi (a_t | s_t ; theta_beta)) mid(|) s_0; theta_beta
]
$

$ 
theta_(pi, i+1) = theta_(pi, i) + alpha dot bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] dot nabla_(theta_(pi, i)) log pi (a_0 | s_0; theta_(pi, i))
$

==
$ bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = bb(E)[
cal(G)(bold(tau)) product_(t=0)^oo (pi (a_t | s_t ; theta_pi) ) /  (pi (a_t | s_t ; theta_beta)) mid(|) s_0; theta_beta
]
$

*Question:* Why did I tell you policy gradient is on policy?

*Answer:* Off-policy gradient does not work in most cases

*Question:* Why? HINT: What happens to $product$?

$ product_(t=0)^oo (pi (a_t | s_t ; theta_pi) ) /  (pi (a_t | s_t ; theta_beta)) -> 0, oo $

Only works if $pi (a_t | s_t ; theta_pi)  approx pi (a_t | s_t ; theta_beta)$

= Trust Regions
// Catastrophic forgetting
    // Focus on state space for a while
// Keep new policy close to old
// Focus on sample efficiency, just slightly off-policy
    // However, we often consider it on-policy
    // Reuses very recent data using off-policy gradient
    // Can do this because old policy is very similar to new policy

==
Training policies in RL is difficult

We often see behavior like this

#side-by-side[
    #cimage("fig/09/collapse.png", height: 70%)][
    *Question:* Any idea why?
]

==
#side-by-side[

    #cimage("fig/09/spikes.png", height: 70%)
][
    See it in supervised learning too

    Sometimes, the gradient is inaccurate producing a bad update

    In supervised learning, the network can easily recover

    With policy gradient, it is much harder to recover
]

*Question:* Why?

==

#side-by-side[
    #cimage("fig/09/collapse.png", height: 70%)
][
    Our policy provides the training data $a tilde pi (dot | s; theta_pi)$

    One bad update breaks the policy

    Policy collects useless data

    Off-policy methods recover from "good" data from replay buffer

    On-policy methods cannot!

]

We must be very careful when updating our neural network policy

==
*Question:* How can we make sure our policy does not change too much?

Lower learning rate? Can help a little 

Small parameter updates cause large changes in deep networks

#side-by-side[
    $ pi (a | s_A; theta_(pi, i)) = vec(0.4, 0.6) $
][
    $ pi (a | s_A; theta_(pi, i + 1)) = vec(1.0, 0.0) $
]

Constraining changes in parameter space does not work!

*Question:* What else can we constrain?

*Answer:* The action distributions

==
Can measure the difference in distributions using KL divergence

$ KL [Pr(X), Pr(Y)] in [0, oo] $

Policies are just action distributions

$ KL[pi (a | s; theta_(pi, i)), pi (a | s; theta_(pi, i + 1))] $

//Adding a KL term to loss can prevent large policy changes 

Introduce *trust region* $k$ to prevent large policy changes

$ nabla_(theta_(pi, i)) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)] = V(s_0, theta_(pi, i)) dot nabla_(theta_pi) log pi (a_0 | s_0; theta_(pi, i)) \ s.t. space KL[pi (a | s; theta_(pi, i - 1)), pi (a | s; theta_(pi, i))] < k $ 

See Trust Region Policy Optimization (TRPO), Natural Policy Gradient

==

$ nabla_(theta_(pi, i)) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)] = V(s_0, theta_(pi, i)) dot nabla_(theta_pi) log pi (a_0 | s_0; theta_(pi, i)) \ s.t. space KL[pi (a | s; theta_(pi, i - 1)), pi (a | s; theta_(pi, i))] < k $ 

Constrained optimization can be expensive and tricky to implement

Often requires computing the Hessian (second-order gradient)

*Hack:* Add KL term to the objective (soft constraint)

$ nabla_(theta_(pi, i)) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)] = V(s_0, theta_(pi, i)) dot \ nabla_(theta_pi) [ log pi (a_0 | s_0; theta_(pi, i)) - KL[pi (a | s; theta_(pi, i - 1)), pi (a | s; theta_(pi, i))] ] $ 

= Proximal Policy Optimization

==
Proximal policy optimization (PPO) combines everything we learned today
- Value function
- Advantage
- Off-policy gradient
- Trust regions

PPO designed to be very sample efficient

It is _almost_ on-policy (but very slightly off-policy)

==

```python
for epoch in range(epochs):
    batch = collect_rollout(theta_beta)
    # Minibatching learns faster
    # but is very slightly off-policy!
    for minibatch in batch:
        theta_pi = update_pi(
            theta_pi, theta_beta, theta_V, batch
        ) 
        theta_V = update_V(theta_V, batch)
    theta_beta = theta_pi
```

==
There are different variations of PPO
- PPO clip
- PPO KL penalty
- PPO clip + KL penalty
- PPO clip + KL penalty + entropy

We will focus on the simplest version (PPO KL penalty)

==

#text(size: 24pt)[
#v(2em)
$ 
theta_(pi, i+1) = theta_(pi, i) + alpha dot 
    underbrace((
        (#pin(1)pi (a | s; theta_(pi, i) )#pin(2)) / 
        (#pin(3)pi (a | s; theta_beta )#pin(4))

        #pin(5)A(s, theta_beta, theta_V)#pin(6)
    ), "Value") 
    \ dot (#pin(9)nabla_(theta_(pi, i)) [ log pi (a_0 | s_0; theta_(pi, i))]#pin(10) 
    - rho nabla_(theta_(pi, i + 1))[ #pin(7)KL[pi (a_0 | s_0; theta_(pi, i + 1)), pi (a_0 | s_0; theta_beta)]#pin(8) ] )
$


#pinit-highlight-equation-from((1,4), (1,2), fill: red, pos: top, height: 2em)[Off-policy correction for minibatch]

#pinit-highlight-equation-from((5,6), (5,6), fill: blue, pos: top, height: 1.2em)[Advantage] 

#pinit-highlight-equation-from((7,8), (7,8), fill: orange, pos: bottom, height: 1.2em)[Trust region] 

#pinit-highlight-equation-from((9,10), (9,10), fill: green, pos: bottom, height: 1.2em)[Policy gradient] 

#v(1.2em)


$ A(s_0, theta_beta, theta_V) = -V(s_0, theta_beta, theta_V) + (hat(bb(E))[cal(R)(s_(1)) | s_0; theta_beta] + not d gamma V(s_1, theta_beta, theta_V)) $

$ theta_(V, i+1) = argmin_theta_(V, i) (V(s_0, theta_beta, theta_(V,i)) - (hat(bb(E))[cal(R)(s_(1)) | s_0; theta_beta]+ not d gamma V(s_0, theta_beta, theta_(V,i) )))^2 $
]

==
*Personal opinion:* PPO is overrated, for some reason very popular

Many hyperparameters, hard to implement, computationally expensive

Cohere finds REINFORCE better than PPO for LLM training

https://arxiv.org/pdf/2402.14740v1

Our experiments find that Q learning outperforms PPO

*My suggestion:* 
- Try A2C first, solid actor-critic method, easy to implement
- Regularization (weight decay, layer norm, etc) helpful
- You can make any algorithm work with enough effort!
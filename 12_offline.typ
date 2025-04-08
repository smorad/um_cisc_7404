#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm
#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "common.typ": *
#import "@preview/cetz:0.3.4": canvas
#import "@preview/cetz-plot:0.1.1": plot
#import "@preview/fletcher:0.5.7" as fletcher: diagram, node, edge
#import "@preview/pinit:0.2.2": *

#set math.vec(delim: "[")
#set math.mat(delim: "[")

#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Offline RL],
    subtitle: [CISC 7404 - Decision Making],
    author: [Steven Morad],
    institution: [University of Macau],
    logo: image("fig/common/bolt-logo.png", width: 4cm)
  ),
  //config-common(handout: true),
  header-right: none,
  header: self => utils.display-current-heading(level: 1)
)

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

#let exp_plot = { 
    set text(size: 25pt)
    canvas(length: 1cm, 
    {
        plot.plot(
            size: (10, 4),
            name: "plot",
            x-tick-step: 2,
            y-tick-step: 2,
            //y-ticks: (0, 1),
            y-min: -5,
            y-max: 5,
            x-label: $ r $,
            y-label: [$ $],
            {
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: red)),
                label: $ r $,
                x => x,
            ) 
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: blue)),
                label: $ f(r) $,
                x => calc.exp(x),
            ) 

            })
    }
)}

#let bimodal = { 
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
            y-max: 1,
            x-label: $ a $,
            y-label: [$ $],
            {
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: red)),
                label: $ pi (a | s_0; theta_(beta)) $,
                x => 0.5 * normal_fn(-1, 0.3, x) + 0.5 * normal_fn(1, 0.3, x),
            ) 

            })
            draw.line((1.5,0), (1.5,4), stroke: orange)
            draw.content((1.5,5), text(fill: orange)[$ a_+ $])

            draw.line((4.5,0), (4.5,4), stroke: orange)
            draw.content((4.5,5), text(fill: orange)[$ a_- $])
    }
)}

#let bimodal_pi = { 
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
            y-max: 1,
            x-label: $ a $,
            y-label: [$ $],
            {
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: red)),
                label: $ pi (a | s_0; theta_(pi)) $,
                x => 0.5 * normal_fn(-1, 0.3, x) + 0.5 * normal_fn(1, 0.3, x),
            ) 

            })
            draw.line((1.5,0), (1.5,4), stroke: orange)
            draw.content((1.5,5), text(fill: orange)[$ a_+ $])

            draw.line((4.5,0), (4.5,4), stroke: orange)
            draw.content((4.5,5), text(fill: orange)[$ a_- $])
    }
)}

#let bimodal_return = { 
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
            y-max: 1,
            x-label: $ a $,
            // y-label: $ Pr (a | s) $,
            // y-label: $ pi (a | s; theta_(beta)) $,
            {
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: red)),
                label: $ pi (a | s; theta_(beta)) $,
                x => 0.5 * normal_fn(-1, 0.3, x) + 0.5 * normal_fn(1, 0.3, x),
            ) 

            })
            draw.line((1.5,0), (1.5,4), stroke: orange)
            draw.content((1.5,5), text(fill: orange)[$ cal(G)(bold(E)_1) $])

            draw.line((4.5,0), (4.5,4), stroke: orange)
            draw.content((4.5,5), text(fill: orange)[$ cal(G)(bold(E)_2) $])
    }
)}

#let bimodal_reweight = { 
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
            y-max: 1,
            x-label: $ a $,
            // y-label: $ Pr (a | s) $,
            // y-label: $ pi (a | s; theta_(beta)) $,
            {
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: red)),
                label: $ pi (a | s; theta_(beta)) $,
                x => 0.75 * normal_fn(-1, 0.3, x) + 0.25 * normal_fn(1, 0.3, x),
            ) 

            })
            draw.line((1.5,0), (1.5,4), stroke: orange)
            draw.content((1.5,5), text(fill: orange)[$ cal(G)(bold(E)_1) $])

            draw.line((4.5,0), (4.5,4), stroke: orange)
            draw.content((4.5,5), text(fill: orange)[$ cal(G)(bold(E)_2) $])
    }
)}

#let bimodal_return_adv = { 
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
            y-max: 1,
            x-label: $ a $,
            // y-label: $ Pr (a | s) $,
            // y-label: $ pi (a | s; theta_(beta)) $,
            {
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: red)),
                label: $ pi (a | s; theta_(beta)) $,
                x => 0.5 * normal_fn(-1, 0.3, x) + 0.5 * normal_fn(1, 0.3, x),
            ) 

            })
            draw.line((1.5,0), (1.5,4), stroke: orange)
            draw.content((0.5,5), text(fill: orange)[$ A(s, a=a_"good", theta_beta) $])

            draw.line((4.5,0), (4.5,4), stroke: blue)
            draw.content((6.0,-2), text(fill: blue)[$ A(s, a=a_"bad", theta_beta) $])
    }
)}

#let bimodal_reweight_adv = { 
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
            y-max: 1,
            x-label: $ a $,
            // y-label: $ Pr (a | s) $,
            // y-label: $ pi (a | s; theta_(beta)) $,
            {
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: red)),
                label: $ pi (a | s; theta_(beta)) $,
                x => 0.75 * normal_fn(-1, 0.3, x) + 0.25 * normal_fn(1, 0.3, x),
            ) 

            })
            draw.line((1.5,0), (1.5,4), stroke: orange)
            draw.content((0.5,5), text(fill: orange)[$ A(s, a=a_"good", theta_beta) $])

            draw.line((4.5,0), (4.5,4), stroke: blue)
            draw.content((6.0,-2), text(fill: blue)[$ A(s, a=a_"bad", theta_beta) $])
    }
)}

#title-slide()

== Outline <touying:hidden>

#components.adaptive-columns(
    outline(title: none, indent: 1em, depth: 1)
)

= Offline RL
// Refresher of on-policy and off-policy RL
    // Both require exploration and collecting data from env
    // Imitation learning does not
    // Downsides of IL
    // Can we do better?
// What is offline RL
// Example applications, why we care
// Benefit of offline RL over imitation learning
    // Stitching diagram

==
In on-policy RL, we collect a new dataset using our policy

In off-policy RL, we update our existing dataset using our policy

In imitation learning, we are given an existing expert dataset

==

Imitation learning from a fixed dataset is attractive for many reasons
- Fixed dataset results in much simpler code 
    - No need to collect new data, step environment, etc
- Easier to train (supervised learning)

But imitation learning (IL) also has disadvantages
- Only imitates, does not think or plan
    - Can only do as good as expert
    - Humans are usually bad "experts"
    - We want to do *better* than humans

*Today:* Can we use fixed datasets with RL instead of IL?

==
In *offline RL* or *batch RL*, we learn without exploration

Like imitation learning, learn from a fixed dataset
    - Simpler implementation
    - No need for exploration

Unlike imitation learning, we can do *better* than the expert
    - Can learn an optimal policy from a random "expert"!
    - How is this possible without exploration?

In imitation learning, we learn to imitate dataset trajectories

In offline RL, we learn to *stitch* together subtrajectories

==
#cimage("fig/12/stitching.png")

==
*Definition:* An *offline MDP* consists of: 
- MDP with unknown $cal(R), Tr$
- Dataset $bold(X)$ of episodes and rewards
    - Following a policy $pi (a | s; theta_beta)$

$ (S, A, cal(R), Tr, gamma, bold(X)) $

#side-by-side[$ cal(R)(s_(t+1)) = ? $][$ Tr(s_(t+1) | s_t, a_t) = ? $]

$ bold(X) = mat(bold(E)_[1], bold(E)_[2], dots) = mat(mat(bold(tau)_[0], bold(r)_[0]), mat(bold(tau)_[1], bold(r)_[1])) = mat(
    mat(s_0, a_0, r_1; s_1, a_1, r_2; dots.v, dots.v, dots.v), mat(s_0, a_0, r_1; s_1, a_1, r_2; dots.v, dots.v, dots.v), dots
) $

==
There are two ways to think about offline RL:
+ Off-policy RL without exploration
+ Imitation learning with weighted trajectories

Let us begin with the first


= The Deadly Triad
// Difference between off policy and offline RL
// What off-policy methods could we use for offline RL?
// In assignment 2, you saw how hard TD learning can be
    // Introduce deadly triad
    // Target networks, regularization, etc
    // Q value overestimation
    // Talk a bit about how this happens for off-policy methods too
        // Discuss some fixes
// What happens when we apply standard Q learning without exploration
    // Q value overestimation for OOD actions
    // Works if we try every action in every possible state
    // In many cases, this is too large

==
*Goal:* Derive offline RL algorithm from an off-policy algorithm

*Question:* Why off-policy instead of on-policy algorithm?

On-policy requires collecting data with $theta_pi$
- But we cannot do this! Dataset is collected with $theta_beta$
- $theta_beta != theta_pi$, cannot use on-policy method

Off-policy can learn from any trajectories
- Trajectory collected following $theta_beta$
- Can use this trajectory to update $theta_pi$

==
Ok, create offline RL algorithm from an off-policy algorithm

*Question:* What off-policy algorithms do we know?
- Q learning
- DDPG (continuous Q learning)

*Question:* Temporal Difference or Monte Carlo Q learning?
- MC is on-policy
- Only TD Q learning is off-policy

==
Standard Q learning algorithm
```python
while not terminated:
    transition = env.step(action)
    buffer.append(transition)
    train_data = buffer.sample()
    J = grad(td_loss)(theta_Q, theta_T, Q, train_data)
    theta_Q = opt.update(theta_Q, J)
```
*Question:* What can we do to make this offline?

==

```python
for x in X:
    buffer.append(x) # Add dataset to replay buffer
while not terminated:
    # Comment out exploration code
    # transition = env.step(action)
    # buffer.append(transition)
    train_data = buffer.sample()
    J = grad(td_loss)(theta_Q, theta_T, Q, train_data)
    theta_Q = opt.update(theta_Q, J)
```

*Question:* Will this work?

*Answer:* Yes! But only for very simple problems

For more interesting problems, loss quickly becomes `NaN`

==





= Behavioral Cloning with Rewards
// Main idea is behavior cloning
// However, reweight actions based on advantage
// Constrained to the dataset (no out of distribution actions)
// Learn Q/V based only on dataset actions
    // Cannot overextrapolate to new actions!
    // Use this to select "better" trajectories
    // Should we use TD or MC?
        // Only want to learn for behavior policy, can use MC because more stable

==
Start with behavior cloning

Want to minimize difference between learned and expert policy

$ argmin_(theta_pi) sum_(s in bold(X)) space KL(pi (a | s; theta_beta), pi (a | s; theta_pi)) $ 

Result is the cross entropy loss

$ argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $ 

==

$ argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $ 

Consider the following situation:
- Two identical states $s$ in the dataset
- Two possible actions $A = {a_+, a_-}$
- First time, expert takes action $a_+$ in $s$
- Second time, expert takes action $a_-$ in $s$

$ argmin_(theta_pi) sum_(a in {a_+, a_-}) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $ 

Expert must behave better in one state than the other!

==
$ argmin_(theta_pi) sum_(a in {a_+, a_-}) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $ 

#side-by-side[
    #cimage("fig/12/good-driver.png", height: 60%)
][
    #cimage("fig/11/texting.jpg", height: 60%)
]

*Question:* Which action is better behavior?

==
#side-by-side[
    #cimage("fig/12/good-driver.png", height: 60%)
][
    #cimage("fig/11/texting.jpg", height: 60%)
]

*Question:* Two actions in same state, what policy $theta_pi$ does BC learn?

*Answer:* Take average action or randomly choose $a in {a_+, a_-}$

*Question:* Is this a good idea?

==
#side-by-side[
    #cimage("fig/12/good-driver.png", height: 60%)
][
    #cimage("fig/11/texting.jpg", height: 60%)
]
*Question:* We know which action is better, how can we measure this?

*Answer:* Reward! In BC, no reward. In offline RL, we have reward!

==

Expert has equal probability for each action

#side-by-side[
    #bimodal
][
    #bimodal_pi
]

With offline RL, we have the emipirical reward and empirical return

#side-by-side[

$ hat(bb(E))[cal(R)(s_1) | s_0; theta_beta] $

][
$ hat(bb(E))[cal(G)(bold(tau)) | s_0; theta_beta] $
]


We can do better!

==
#side-by-side[
    #bimodal
][
    #bimodal_pi
]

#side-by-side[

$ hat(bb(E))[cal(R)(s_1) | s_0; theta_beta] $

][
$ hat(bb(E))[cal(G)(bold(tau)) | s_0; theta_beta] $
]

*Question:* What do we want to do?

*Answer:* Increase probability of $a_+$, decrease probability of $a_-$

==
$ argmin_(theta_pi) sum_(a in {a_+, a_-}) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $ 

Increase probability of $a_+$ and decrease probability of $a_-$ using return

*Question:* How?

$ "Hint:" argmin_(theta_pi) - pi (a_+ | s; theta_beta) log pi (a_+ | s; theta_pi) - pi (a_- | s; theta_beta) log pi (a_- | s; theta_pi) $ 

We can reweight the objective

$ argmin_(theta_pi) - #redm[$0.9$] pi (a_+ | s; theta_beta) log pi (a_+ | s; theta_pi) - #redm[$0.1$] pi (a_- | s; theta_beta) log pi (a_- | s; theta_pi) $ 

==
$ argmin_(theta_pi) - #redm[$0.9$] pi (a_+ | s; theta_beta) log pi (a_+ | s; theta_pi) - #redm[$0.1$] pi (a_- | s; theta_beta) log pi (a_- | s; theta_pi) $ 

More generally

$ argmin_(theta_pi) - #redm[$w_+$] pi (a_+ | s; theta_beta) log pi (a_+ | s; theta_pi) - #redm[$w_-$] pi (a_- | s; theta_beta) log pi (a_- | s; theta_pi) $

*Question:* What can we use for $w_+, w_-$?

$ hat(bb(E))[cal(R)(s_1) | s_0; theta_beta] $

==

*Definition:* In *Expectation Maximization Reinforcement Learning* (EMRL, Hinton), we reweight the behavior cloning objective using the reward

$ theta_pi = argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) dot hat(bb(E))[cal(R)(s_1) | s_0; theta_beta] $ 

==

$ theta_pi = argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) dot hat(bb(E))[cal(R)(s_1) | s_0; theta_beta] $ 

Consider the simplified example, now with reward weights $r$

$ argmin_(theta_pi) - #redm[$r_+$] pi (a_+ | s; theta_beta) log pi (a_+ | s; theta_pi) - #redm[$r_-$] pi (a_- | s; theta_beta) log pi (a_- | s; theta_pi) $

*Question:* Are there any problems with EMRL?

Hint: What if the reward is negative?

Want positive weights, EMRL only works with positive rewards!

==

$ argmin_(theta_pi) - #redm[$r_+$] pi (a_+ | s; theta_beta) log pi (a_+ | s; theta_pi) - #redm[$r_-$] pi (a_- | s; theta_beta) log pi (a_- | s; theta_pi) $

$ bb(E)[cal(R)(s_1) | s_0; theta_beta] in [-oo, oo] $

We want our algorithm to work with positive and negative rewards

We need some mapping $f: [-oo, oo] |-> [0, oo]$

*Question:* Any other properties for $f$?

*Answer:* $f$ must be *monotonic* to ensure we still maximize rewards!

$ r_+ > r_- => f(r_+) > f(r_-) $

==

*Question:* What functions $f: [-oo, oo] |-> [0, oo]$ are monotonic?

#align(center, exp_plot)

$ f(r) = e^r $

==
*Definition:* Reward Weighted Regression (RWR) reweights the behavior cloning objective using the exponentiated reward

$ theta_pi = argmin_(theta_pi) sum_(s_0 in bold(X)) sum_(a in A) - pi (a | s_0; theta_beta) log pi (a | s_0; theta_pi) dot exp(hat(bb(E))[cal(R)(s_1) | s_0; theta_beta]) $ 

Consider an infinitely large and diverse dataset containing all $s, a$

Then, weights are proportional to Boltzmann distribution (softmax)

$ sum_(a_0 in A) exp(hat(bb(E))[cal(R)(s_1) | s_0, a_0]) prop sum_(a_i in A) ( exp(hat(bb(E))[cal(R)(s_1) | s_0, a_i]) ) / ( sum_(a_0 in A) exp(hat(bb(E))[cal(R)(s_1) | s_0, a_0]) ) $

==
$ theta_pi = argmin_(theta_pi) sum_(s_0 in bold(X)) sum_(a in A) - pi (a | s_0; theta_beta) log pi (a | s_0; theta_pi) dot exp(hat(bb(E))[cal(R)(s_1) | s_0; theta_beta]) $ 

RWR maximizes the reward

*Question:* Do we maximize the reward in RL?

*Answer:* No, we maximize the return!

$ theta_pi = argmin_(theta_pi) sum_(s_0 in bold(X)) sum_(a in A) - pi (a | s_0; theta_beta) log pi (a | s_0; theta_pi) dot exp(hat(bb(E))[cal(G)(bold(tau)) | s_0; theta_beta]) $ 

==
$ theta_pi = argmin_(theta_pi) sum_(s_0 in bold(X)) sum_(a in A) - pi (a | s_0; theta_beta) log pi (a | s_0; theta_pi) dot exp(hat(bb(E))[cal(R)(s_1) | s_0; theta_beta]) $ 

This works in theory, but does not work well in practice

*Question:* Why won't this work well in practice?

*Answer:*
- Need infinite rewards to approximate Monte Carlo return
- Returns can be big or small, causing overflows $exp(cal(G)(bold(tau))) -> 0, oo$

*Question:* Had similar problems with actor critic, what was solution?
- Introduce value function (remove infinite sum)
- Introduce advantage (normalize rewards)

==
$ theta_pi = argmin_(theta_pi) sum_(s_0 in bold(X)) sum_(a in A) - pi (a | s_0; theta_beta) log pi (a | s_0; theta_pi) dot exp(A(s, a, theta_beta) ) $ 

$ A(s, a, theta_beta) = Q(s, a, theta_beta) - V(s, theta_beta) $

$ A(s_t, s_(t+1), theta_beta) = - V(s_t, theta_beta) + r_t + gamma V(s_(t+1), theta_beta) $

==

*Definition:* Monotonic Advantage Re-Weighted Imitation Learning (MARWIL) reweights the behavior cloning objective based on the advantage

*Step 1:* Learn a value function for $theta_beta$ 

$ theta_V &= argmin_(theta_V) (V(s_0, theta_beta, theta_V) - y)^2 \ 
y &= hat(bb(E))[cal(R)(s_1) | s_0; theta_beta] + gamma V(s_1, theta_beta, theta_V) $

==

*Step 2:* Learn policy using weighted behavioral cloning

$ A(s_t, s_(t+1), theta_beta, theta_V) = - V(s_t, theta_beta, theta_V) + hat(bb(E))[cal(R)(s_1) | s_0; theta_beta] + gamma V(s_(t+1), theta_beta, theta_V) $

$ theta_pi = argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) dot exp(A(s_t, s_(t+1), theta_beta, theta_V)) $ 

==

*Question:* Is MARWIL RL or supervised learning?

*Answer:* Both
- Learn policy using supervised learning (SL)
- But dataset weights require learning value function (RL)

*Question:* We used TD objective, can we also use MC objective?

$
V(s_0, theta_beta, theta_V) &= hat(bb(E))[cal(R)(s_1) | s_0; theta_beta] + gamma V(s_1, theta_beta, theta_V) \

V(s_0, #pin(1)theta_beta#pin(2), theta_V) &= sum_(t=0)^oo gamma^t hat(bb(E))[cal(R)(s_(t+1)) | s_0; #pin(3)theta_beta#pin(4)] $

#pinit-highlight(1,2)
#pinit-highlight(3,4)

*Answer:* Yes, because we learn $V$ for $theta_beta$ not $theta_pi$

==
Add improvements to MARWIL to derive other offline RL algorithms
- Advantage Weighted Regression (AWR)
- Advantage Weighted Actor Critic (AWAC)
- Critic Regularized Regression (CRR)
- Implicit Q learning (IQL)
- Maximum a Posteriori Optimization (MPO)

==

#side-by-side[
    #bimodal
][
    #bimodal_return
]

We have the empirical Monte Carlo return for each episode

$ hat(bb(E))[cal(G)(bold(E)) | s_0; theta_beta] $

We can use this to reweight distributions

==

#side-by-side[
    #bimodal_return
][
    #bimodal_reweight
]

We did something similar with actor critic and policy gradient!

*Question:* What was the issue with using the return for actor critic? 

Hint: What if all returns are negative?

==
#side-by-side[
    #pathology_left
][
    #pathology_right
]

#side-by-side[
    *Question:* What was the solution?
][
    *Answer:* Use advantage not return
]


$ A(s, a, theta_beta) = Q(s, a, theta_beta) - V(s, theta_beta) $

$ A(s_t, s_(t+1), theta_beta) = - V(s_t, theta_beta) + r_t + gamma V(s_(t+1), theta_beta) $

==

#side-by-side[
    #bimodal_return_adv
][
    #bimodal_reweight_adv
]

*Question:* How is this different from A2C (on-policy method)?

*Answer:* Only consider $a$ from the dataset, cannot propose new action
- Good action must exist in dataset!
- Can focus on good action not bad action

==
Furthermore, in A2C we do gradient ascent

$ A(s_t, s_(t+1), theta_pi) dot nabla_(theta_pi) pi (a_t | s_t; theta_pi) $

With behavior cloning, we are *reweighting* actions

In other words, modifying the objective

$ pi (a_t, s_t; theta_pi) = exp(A(s_t, s_(t+1), theta_pi)) dot pi (a_t | s_t; theta_beta) $





= Minimalist Offline RL

= Conservative Q Learning
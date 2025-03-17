#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm
#import "@preview/touying:0.6.1": *
#import themes.university: *
#import "common.typ": *
#import "@preview/cetz:0.3.4": canvas
#import "@preview/cetz-plot:0.1.1": plot
#import "@preview/fletcher:0.5.5" as fletcher: diagram, node, edge
#import "@preview/pinit:0.2.2": *

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
    title: [Policy Gradient],
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

Quiz next week

Study policy gradient, Q learning, etc

==
Changing final project

Simulator is based on web interface, cannot install packages, etc

I do not want you to waste time with this

Instead, find (or create) a gymnasium environment
- Ensure your task is MDP
- Can also try POMDP, but make sure you are prepared!
- Groups of 5, should be impressive results
- Due date either last day of class or during finals week

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
$ nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = bb(E)[ cal(G)(bold(tau)) | s_0; theta_pi] dot nabla_(theta_pi) log pi (a_0 | s_0; theta_pi) $ 

We previously computed the Monte Carlo policy gradient (REINFORCE) 

$ bb(E)[ cal(G)(bold(tau)) | s_0; theta_pi] = sum_(t=0)^oo gamma^t hat(bb(E))[cal(R)(s_(t+1)) | s_0; theta_pi] $

*Question:* Why don't we always use Monte Carlo? 

*Answer:* Requires an infinite return!

==
$ bb(E)[ cal(G)(bold(tau)) | s_0; theta_pi] = sum_(t=0)^oo gamma^t hat(bb(E))[cal(R)(s_(t+1)) | s_0; theta_pi] $

*Question:* Alternative to Monte Carlo?

$ bb(E)[ cal(G)(bold(tau)) | s_0; theta_pi] = V(s_0, theta_pi) $

*Answer:* TD-Value function

$ V(s_0, theta_pi) = bb(E)[cal(R)(s_1) | s_0, theta_pi] + gamma V(s_1, theta_pi) $

==
$ nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = & bb(E)[ cal(G)(bold(tau)) | s_0; theta_pi] dot nabla_(theta_pi) log pi (a_0 | s_0; theta_pi) \ 

& bb(E)[ cal(G)(bold(tau)) | s_0; theta_pi] = sum_(t=0)^oo gamma^t hat(bb(E))[cal(R)(s_(t+1)) | s_0; theta_pi] $

#v(1em)
$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = #pin(1)V(s_0, theta_pi)#pin(2) dot nabla_(theta_pi) log #pin(3)pi (a_0 | s_0; theta_pi)#pin(4)
$

#pinit-highlight-equation-from((3,4), (3,4), fill: red, pos: top, height: 1.2em)[Actor pick action] 

#pinit-highlight-equation-from((1,2), (1,2), fill: blue, pos: bottom, height: 1.2em)[Critic score actor $theta_pi$] 

#v(2em)

*Actor-critic* algorithms combine V/Q learning with policy gradient

==
Actor-critic methods follow one of two forms
- Policy gradient but replace return with V/Q
- Learn V/Q but replace argmax policy with policy gradient

Today, we focus on the first



= Advantages

==
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

Policy keeps forgetting, can destabilize learning

*Question:* If we take 8 actions, will this fix it?

#pathology_fix

*Question:* Any solutions?

Hint: Think about the mean of the return

*Answer:* Recenter return such that mean is zero

Only updates policy when we do better/worse than average

==
Want to update the policy when we do better/worse than average

We call this the *advantage*

$ A(s_0, a_0, theta_pi) $

If action $a_0$ is better than average, it has an advantage

Let us implement the advantage

How can we determine the "average" performance of the policy in some state $s_0$?

$ bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = V(s_0, theta_pi) $

How can we determine value for action $a_0$ in $s_0$

$ bb(E)[cal(G)(bold(tau)) | s_0, a_0; theta_pi] = Q(s_0, a_0, theta_pi) $

==
$ bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = V(s_0, theta_pi) $

$ bb(E)[cal(G)(bold(tau)) | s_0, a_0; theta_pi] = Q(s_0, a_0, theta_pi) $

*Question:* How to measure the advantage of an action $a_0$?

$ A(s_0, a_0, theta_pi) &= 
    bb(E)[cal(G)(bold(tau)) | s_0, a_0 ; theta_pi] - bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] \ 
    & = Q(s_0, a_0, theta_pi) - V(s_0, theta_pi)
$


==
$ A(s_0, a_0, theta_pi) = bb(E)[cal(G) | s_0, a_0, theta_pi] - bb(E)[cal(G) | s_0, theta_pi] $

$ A(s_0, a_0, theta_pi) = Q(s_0, a_0, theta_pi) - bb(E)[cal(G) | s_0, theta_pi] $

$ A(s_0, a_0, theta_pi) = Q(s_0, a_0, theta_pi) - V(s_0, theta_pi) $

Plug into policy gradient

$ nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] dot nabla_(theta_pi) log pi (a | s; theta_pi) $

$ nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi]  = (A(s_0, a_0, theta_pi) + mu) dot  nabla_(theta_pi) log pi (a | s; theta_pi) $

$ nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi]  = (A(s_0, a_0, theta_pi) + mu) dot  nabla_(theta_pi) log pi (a | s; theta_pi) $


$ nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] - b  =  sum_(s, a in bold(tau)) A(s, a, theta_pi) dot nabla_(theta_pi) log pi (a | s; theta_pi) $

Is advantage a biased estimator?

= Advantage Actor Critic
// When we use advantage with policy gradient, call it A2C
// Written by same guy as DQN (Mnih)

= Importance Sampling

= Trust Region Policy Optimization

= Proximal Policy Optimization
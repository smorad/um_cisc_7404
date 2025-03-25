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

#let adv_left = { 
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
                x => normal_fn(0, 0.5, x),
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

#let adv_right = { 
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
                x => normal_fn(0, 0.5, x),
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

#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Actor Critic I],
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
How is homework 2? #pause

Deadlines #pause
- 1 Quiz next week #pause
- Final project proposal due day after quiz #pause
- Homework 2 due in 2 weeks #pause
- Last quiz in #sym.tilde 1 month
- Final project #sym.tilde 6 weeks

==

Quiz next week, topics: #pause

#side-by-side[
- Actor critic 
    - Basic algorithm
    - Advantages
    - Off-policy gradient
    - Trust regions
    - Will not cover PPO #pause
][
- Policy gradient 
    - Expectations, returns, notation
    - Optimization objective
    - REINFORCE #pause
][
- Q learning 
    - Expectations, returns, notation
    - Different objectives
    - Relationships between $V$ and $Q$ #pause
]

Format/difficulty will be similar to last time (3-4 questions, 75 mins) #pause

Continue lecture after quiz next week? Will you be too tired?

= Final Project
==

Final project information is released #pause

Suggest project and group members by next Friday (28th) #pause

Find (or create) a gymnasium environment #pause
- Ensure your task is MDP #pause
- Can also try POMDP, but make sure you are prepared! #pause
- Groups of 5, results should be impressive #pause
- Due just before final exam study week #pause

https://ummoodle.um.edu.mo/pluginfile.php/6900679/mod_resource/content/6/project.pdf

= Review

= Actor Critic
// Monte Carlo returns require complete episodes
// How can we train without infinite episodes
// Use Q function 
// Easier to implement value function
// Called actor critic
// Policy is "actor" because it picks action
// Q function is "critic" because it scores the actor

==
Today, we will investigate modern forms of policy gradient #pause

These forms of policy gradient also learn Q or V functions jointly #pause

We will learn the prerequisites to implement PPO, the most popular RL algorithm #pause

==

#cimage("fig/09/algos.png")

==
Recall the policy gradient #pause

$ nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = bb(E)[ cal(G)(bold(tau)) | s_0; theta_pi] dot nabla_(theta_pi) log pi (a_0 | s_0; theta_pi) $ #pause

We previously computed the Monte Carlo policy gradient (REINFORCE) #pause

$ bb(E)[ cal(G)(bold(tau)) | s_0; theta_pi] = sum_(t=0)^oo gamma^t hat(bb(E))[cal(R)(s_(t+1)) | s_0; theta_pi] $ #pause

*Question:* Why don't we always use Monte Carlo? #pause

*Answer:* Requires collecting an infinite sequence of rewards!

==
$ bb(E)[ cal(G)(bold(tau)) | s_0; theta_pi] = sum_(t=0)^oo gamma^t hat(bb(E))[cal(R)(s_(t+1)) | s_0; theta_pi] $ #pause

*Question:* Other way to compute $bb(E)[ cal(G)(bold(tau)) | s_0; theta_pi]$? #pause

*Answer:* Can use $Q$ or $V$ function with TD objective #pause

$ V(s_0, theta_pi) = bb(E)[cal(R)(s_1) | s_0, theta_pi] + gamma V(s_1, theta_pi) $ #pause

$ Q(s_0, a_0, theta_pi) = bb(E)[cal(R)(s_1) | s_0, a_0, theta_pi] + gamma Q(s_1, a_1, theta_pi) $ #pause

I want to quickly repeat the relationship between $V$ and $Q$

==
$ V(s_0, theta_pi) &= bb(E)[cal(R)(s_1) | s_0, theta_pi] + gamma V(s_1, theta_pi) \
Q(s_0, a_0, theta_pi) &= bb(E)[cal(R)(s_1) | s_0, a_0, theta_pi] + gamma Q(s_1, a_1, theta_pi) $ #pause

$Q$ and $V$ are closely related, we derived $Q$ from $V$ #pause

$ Q(s_0, a_0, theta_pi) &= bb(E)[cal(R)(s_1) | s_0, a_0, theta_pi] + gamma V(s_1, theta_pi) $ #pause

This means we can convert $Q$ to $V$ or $V$ to $Q$ #pause

If you choose $a_0 tilde pi (dot | s_0; theta_pi)$ for $Q$ #pause

$ Q(s_0, a_0, theta_pi) &= bb(E)[cal(R)(s_1) | s_0, cancel(a_0), theta_pi] + gamma V(s_1, theta_pi) #pause \
&= V(s_0, theta_pi)
$



==
Now that $V$ and $Q$ are clear, back to policy gradient #pause

Policy gradient objective uses the expected policy-conditioned return #pause

$ nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] =  bb(E)[ cal(G)(bold(tau)) | s_0; theta_pi] dot nabla_(theta_pi) log pi (a_0 | s_0; theta_pi) $ #pause

Represent expected policy-conditioned return using value function #pause

$ bb(E)[ cal(G)(bold(tau)) | s_0; theta_pi] = V(s_0, theta_pi) $ #pause

Replace MC return with $V"/"Q$ in policy gradient, call it *actor-critic* #pause

#v(1.2em)
$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = #pin(1)V(s_0, theta_pi)#pin(2) dot nabla_(theta_pi) log #pin(3)pi (a_0 | s_0; theta_pi)#pin(4)
$ #pause



#pinit-highlight-equation-from((3,4), (3,4), fill: red, pos: top, height: 1.2em)[Actor pick action] #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: blue, pos: bottom, height: 1.2em)[Critic gives actor score] 

==

*Definition:* The actor-critic algorithm that jointly trains a policy network and value function #pause

$ 
theta_(pi, i+1) = theta_(pi, i) + alpha dot underbrace(V(s_0, theta_(pi, i), theta_(V, i)), "Expected return") dot nabla_(theta_(pi, i)) log pi (a_0 | s_0; theta_(pi, i))
$ #pause

$ theta_(V, i+1) = \ argmin_theta_(V, i) underbrace((V(s_0, theta_(pi, i), theta_(V,i)) - (hat(bb(E))[cal(R)(s_(1)) | s_0; theta_pi]+ not d gamma V(s_0, theta_(pi, i), theta_(V,i) )))^2, "TD error") $ #pause

Repeat process until convergence: $theta_(pi, i+1)=theta_(pi, i), quad theta_(V, i+1)=theta_(V, i)$ #pause

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
$ #pause

*Question:* Any scenarios where reward is always negative? #pause

*Answer:* Distance to goal, $cal(R)(s_(t+1)) = -(s_(t+1) - s_g)^2$ #pause

*Question:* What happens to return if reward is always negative? #pause

*Answer:* Return always negative #pause

$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = - | V(s_0, theta_pi) | dot nabla_(theta_pi) log pi (a_0 | s_0; theta_pi)
$ #pause

Similar results if reward is always positive #pause

$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = | V(s_0, theta_pi) | dot nabla_(theta_pi) log pi (a_0 | s_0; theta_pi)
$

==
$ 
nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = - | V(s_0, theta_pi) | dot nabla_(theta_pi) log pi (a_0 | s_0; theta_pi)
$ #pause

*Example:* MDP with one state and continuous actions, negative reward #pause

Sample $k$ transitions $(s_0, a_0, r_0, d_0, s_1)$ for each policy update #pause

What if we cannot sample all possible actions? #pause

#side-by-side[
    #pathology_left #pause
][
    #pathology_right

]

==
https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExeGdqZm56NDgzcmY2Ym95dG13Ynczdm9lbDY0cGpjczdtMHBmcnJmMSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/MVUyVpyjakkRW/giphy.gif

==

#side-by-side[
    #pathology_left
][
    #pathology_right

] #pause

Policy keeps oscillating, can destabilize learning #pause

*Question:* If we take 8 actions, will this fix it? 


==

#side-by-side[
    #pathology_fix #pause
][
*Question:* Any solutions? #pause

Hint: Think about the mean of the return #pause

*Answer:* Recenter return such that mean is zero #pause

Does not completely solve issue, maybe $cal(R)(s_A) < 0$
]
What if we: #pause
- Almost never update policy #pause
- Update the policy *only* if action is better/worse than expected 

==
*Question:* What is the expected performance of the policy? #pause

$ bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = V(s_0, theta_pi) $ #pause

*Question:* What is the expected performance of a specific action? #pause

$ bb(E)[cal(G)(bold(tau)) | s_0, a_0; theta_pi] = Q(s_0, a_0, theta_pi) $ #pause

*Question:* How can we tell if an action is better/worse than expected? #pause

$ bb(E)[cal(G)(bold(tau)) | s_0, a_0 ; theta_pi] - bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] #pause
     = Q(s_0, a_0, theta_pi) - V(s_0, theta_pi) $

==

$ A(s_0, a_0, theta_pi) = Q(s_0, a_0, theta_pi) - V(s_0, theta_pi) $ #pause

We call this the *advantage*, tells us if we should change policy #pause

If $a_0$ produces better than expected return, increase policy probability #pause

$ 
theta_(pi, i+1) = theta_(pi, i) + | A(s_0, a_0, theta_(pi, i)) | dot nabla_(theta_(pi, i)) log pi (a_0 | s_0; theta_(pi, i))
$ #pause

If action $a_0$ produces worse return than expected, reduce probability

$ 
theta_(pi, i+1) = theta_(pi, i) - | A(s_0, a_0, theta_(pi, i)) | dot nabla_(theta_(pi, i)) log pi (a_0 | s_0; theta_(pi, i))
$ #pause

If action $a_0$ produced expected return, do nothing $theta_(pi, i+1) = theta_(pi, i) + 0$

==
The policy will not oscillate -- policy only changes if it improves return #pause

#side-by-side[
    #adv_left
][
    #adv_right
] #pause

Results in more stable training and faster convergence

==

*Definition:* The advantage $A$ determines the relative advantage/disadvantage of taking an action $a_0$ in state $s_0$ for a policy $theta_pi$ #pause

$ A(s_0, a_0, theta_pi) = Q(s_0, a_0, theta_pi) - V(s_0, theta_pi) $

==
$ A(s_0, a_0, theta_pi) = Q(s_0, a_0, theta_pi) - V(s_0, theta_pi) $ #pause

Advantage requires both $Q$ and $V$ #pause

But earlier, we saw $Q=V$ in some circumstances #pause

*Question:* Can we replace $Q$ with $V$? How? #pause

HINT: Think about TD error, will write as $A(s_0, s_1, r_0, theta_pi)$ #pause

$ A(s_0, s_1, r_0, theta_pi) = -underbrace(V(s_0, theta_pi), "What we expect") + underbrace((bb(E)[cal(R)(s_(1)) | s_0; theta_pi] + not d gamma V(s_1, theta_pi)), "What happens")
$ #pause

Better than expected: $|A| > 0$ #pause , worse than expected $|A| < 0$

// When we use advantage with policy gradient, call it A2C
// Written by same guy as DQN (Mnih)

==
*Definition:* Advantage actor critic (A2C) updates the policy using the advantage, and repeats until convergence #pause

$ A(s_0, s_1, r_0, theta_pi, theta_V) = -V(s_0, theta_pi, theta_V) + underbrace(hat(bb(E))[cal(R)(s_(1)) | s_0; theta_pi], r_0) + not d gamma V(s_1, theta_pi, theta_V)
$ #pause

$ 
theta_(pi, i+1) = theta_(pi, i) + alpha dot underbrace(A(s_0, theta_(pi, i), theta_(V, i)), "Advantage") dot underbrace(nabla_(theta_(pi, i)) log pi (a_0 | s_0; theta_(pi, i)), "Policy gradient")
$ #pause

$ theta_(V, i+1) = \ argmin_theta_(V, i) underbrace((V(s_0, theta_(pi, i), theta_(V,i)) - (hat(bb(E))[cal(R)(s_(1)) | s_0; theta_pi] + not d gamma V(s_0, theta_(pi, i), theta_(V,i) )))^2, "TD error") $

= Off-Policy Gradient
// Policy gradient is an on-policy method
// Off policy vs on policy
// Return relies on parameters
// But what if the policy has only changed slightly
// Can we still somehow reuse this data
// Introduce importance sampling
==
$ nabla_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = bb(E)[ cal(G)(bold(tau)) | s_0; theta_pi] dot nabla_(theta_pi) log pi (a_0 | s_0; theta_pi) $ #pause

*Question:* Is policy gradient off-policy or on-policy? #pause

*Answer:* On-policy, expected return depends on $theta_pi$ #pause

*Question:* Why do we care about being off-policy? #pause

*Answer:* Algorithm can reuse data, much more efficient #pause

*Question:* What do we need to make policy gradient off-policy? #pause

Must approximate $bb(E)[cal(G)(bold(tau)) | s_0; #pin(1)theta_pi#pin(2)]$ using $bb(E)[cal(G)(bold(tau)) | s_0; #pin(3)theta_beta#pin(4)]$ #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: bottom, height: 1.2em)[Training policy] 
#pinit-highlight-equation-from((3,4), (3,4), fill: blue, pos: bottom, height: 1.2em)[Behavior policy] #pause

#v(1.2em)

*Question:* Any statistics students know how to do this?

==
In *importance sampling*, we want to estimate #pause

$ bb(E)[f(x) | x tilde Pr (X)] $ #pause

Unfortunately, we only have data from #pause

$ bb(E)[f(x) | x tilde Pr (Y)] $ #pause

We can use their ratio to approximate the expectation #pause

$ bb(E)[f(x) | x tilde Pr (X)] = bb(E)[
    f(x) dot (Pr (X) ) /  (Pr (Y)) mid(|) x tilde Pr (Y) ] 
$ #pause

*Question:* How can we use this to make policy gradient off-policy?

==

$ bb(E)[f(x) | x tilde Pr (X)] = bb(E)[
    f(x) dot (Pr (X) ) /  (Pr (Y)) mid(|) x tilde Pr (Y) ] 
$ #pause

Consider our current policy is $theta_pi$, we want $bb(E)[cal(G)(bold(tau)) | s_0; theta_pi]$ #pause

A *behavior policy* $theta_beta$ collected the data $bb(E)[cal(G)(bold(tau)) | s_0; theta_beta]$ #pause

$theta_beta$ can be an old policy or some other policy #pause

#v(1.5em)

$ bb(E)[#pin(5)cal(R)(s_(1))#pin(6) | s_0; #pin(7)theta_pi#pin(8)] = bb(E)[
    #pin(1)cal(R)(s_1)#pin(2) dot (pi (a | s_0 ; theta_pi) ) /  (pi (a | s_0 ; theta_beta)) mid(|) s_0; #pin(3)theta_beta#pin(4)] 
$ #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: bottom, height: 2em)[Reward following $theta_beta$] 
#pinit-highlight(3, 4) #pause

#pinit-highlight-equation-from((5,6), (5,6), fill: blue, pos: top, height: 2em)[Reward following $theta_pi$] 
#pinit-highlight(7, 8, fill: blue.transparentize(80%))

==
$ bb(E)[cal(R)(s_(1)) | s_0; theta_pi] = bb(E)[
    cal(R)(s_1) dot (pi (a | s_0 ; theta_pi) ) /  (pi (a | s_0 ; theta_beta)) mid(|) s_0; theta_beta] 
$ #pause

Seems like magic, how does this actually work? #pause

Let us find out, start with expected reward from behavior policy #pause

$ bb(E)[cal(R)(s_(1)) | s_0; theta_beta] = 
    sum_(s_1 in S) cal(R)(s_1) sum_(a_0 in A) Tr(s_1 | s_0, a_0) pi (a_0 | s_0; theta_beta)
    
    //underbrace((pi (a_0 | s_0 ; theta_pi) ) /  (pi (a_0 | s_0 ; theta_beta)), "Correction") 
$

==

$ bb(E)[cal(R)(s_(1)) | s_0; theta_beta] = 
    underbrace(sum_(s_1 in S) cal(R)(s_1) sum_(a_0 in A) Tr(s_1 | s_0, a_0) pi (a_0 | s_0; theta_beta), "Expected reward") underbrace((pi (a_0 | s_0 ; theta_pi) ) /  (pi (a_0 | s_0 ; theta_beta)), "Correction") 
$ #pause


$ //bb(E)[cal(R)(s_(1)) | s_0; theta_pi] = 
    sum_(s_1 in S) cal(R)(s_1) sum_(a_0 in A) Tr(s_1 | s_0, a_0) cancel(pi (a_0 | s_0; theta_beta)) (pi (a_0 | s_0 ; theta_pi) ) /  cancel(pi (a_0 | s_0 ; theta_beta)) 
$
$ 
    sum_(s_1 in S) cal(R)(s_1) sum_(a_0 in A) Tr(s_1 | s_0, a_0) pi (a_0 | s_0 ; theta_pi) #pause = bb(E)[cal(R)(s_(1)) | s_0; theta_pi]
$ #pause
Left with expected reward following $theta_pi$

==
$ bb(E)[cal(R)(s_(1)) | s_0; theta_pi] = bb(E)[
    cal(R)(s_1) dot (pi (a | s_0 ; theta_pi) ) /  (pi (a | s_0 ; theta_beta)) mid(|) s_0; theta_beta] \

bb(E)[cal(R)(s_(1)) | s_0; theta_pi] = 
    sum_(s_1 in S) cal(R)(s_1) sum_(a_0 in A) Tr(s_1 | s_0, a_0) pi (a_0 | s_0; theta_beta)(pi (a_0 | s_0 ; theta_pi) ) /  (pi (a_0 | s_0 ; theta_beta)) 
$ #pause

We found a way to estimate the off-policy reward #pause

Apply the same approach to find the off-policy return (won't derive, trust me) #pause

$ bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = bb(E)[
#pin(1)cal(G)(bold(tau))#pin(2) product_(t=0)^oo (pi (a_t | s_t ; theta_pi) ) /  (pi (a_t | s_t ; theta_beta)) mid(|) s_0; #pin(3)theta_beta#pin(4)
] #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: red, pos: top, height: 1.2em)[Return following $theta_beta$] 
#pinit-highlight(3, 4) #pause
$

==
// TODO: Should I use hat/approx here?

*Definition:* Off-policy gradient uses importance sampling to learn from off-policy data #pause

$ bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = bb(E)[
cal(G)(bold(tau)) product_(t=0)^oo (pi (a_t | s_t ; theta_pi) ) /  (pi (a_t | s_t ; theta_beta)) mid(|) s_0; theta_beta
]
$ #pause

$ 
theta_(pi, i+1) = theta_(pi, i) + alpha dot bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] dot nabla_(theta_(pi, i)) log pi (a_0 | s_0; theta_(pi, i))
$ #pause

*Note:* Wrote MC version for clarity, but you can use $V$ too #pause

$ V(s_0, theta_pi, theta_beta) = bb(E)[
cal(G)(bold(tau)) product_(t=0)^oo (pi (a_t | s_t ; theta_pi) ) /  (pi (a_t | s_t ; theta_beta)) mid(|) s_0; theta_beta
] $

==
$ bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = bb(E)[
cal(G)(bold(tau)) product_(t=0)^oo (pi (a_t | s_t ; theta_pi) ) /  (pi (a_t | s_t ; theta_beta)) mid(|) s_0; theta_beta
]
$ #pause

Why did I tell you policy gradient is on policy? #pause

Off-policy gradient does not work in most cases #pause

*Question:* Why? #pause HINT: What happens to $product$? #pause

$ product_(t=0)^oo (pi (a_t | s_t ; theta_pi) ) /  (pi (a_t | s_t ; theta_beta)) -> 0, oo $ #pause

Only works if $pi (a_t | s_t ; theta_pi)  approx pi (a_t | s_t ; theta_beta) quad forall t$

= Trust Regions
// Catastrophic forgetting
    // Focus on state space for a while
// Keep new policy close to old
// Focus on sample efficiency, just slightly off-policy
    // However, we often consider it on-policy
    // Reuses very recent data using off-policy gradient
    // Can do this because old policy is very similar to new policy

==
Training policies in RL is difficult #pause

We often see strange results during training #pause

#side-by-side[
    #cimage("fig/09/collapse.png", height: 70%) #pause][
    *Question:* Any idea why?
]

==
#side-by-side[

    #cimage("fig/09/spikes.png", height: 70%) #pause
][
    See it in supervised learning too #pause

    Sometimes, the gradient is inaccurate producing a bad update #pause

    In supervised learning, the network can easily recover #pause

    With policy gradient, it is much harder to recover #pause
]

*Question:* Why is it harder to recover with policy gradient?

==

#side-by-side[
    #cimage("fig/09/collapse.png", height: 70%) #pause
][
    Our policy provides the training data $a tilde pi (dot | s; theta_pi)$ #pause

    One bad update breaks the policy #pause

    Policy collects useless data #pause

    Bad data = no policy recovery! #pause 

    Off-policy methods recover with "good" data from replay buffer, on-policy cannot #pause



]

Must be very careful when updating policy using on-policy algorithms 

==
We can fix this issue with small changes to the policy #pause

*Question:* How can we make policy changes small? #pause

Lower learning rate? Can help a little #pause

Small parameter change can cause large changes in deep networks #pause

#side-by-side[
    $ pi (a | s_A; theta_(pi, i)) = vec(#pin(1)0.4#pin(2), #pin(3)0.6#pin(4)) $ #pause
][
    $ pi (a | s_A; theta_(pi, i + 1)) = vec(#pin(5)1.0#pin(6), #pin(7)0.0#pin(8)) $
] #pause

Parameter-space constraints (learning rate) does not work very well! #pause

*Question:* What else can we constrain? #pause

*Answer:* The action distributions
#pinit-highlight(1, 4) 
#pinit-highlight(5, 8) 

==
Can measure the difference in distributions using KL divergence #pause

$ KL [Pr(X), Pr(Y)] in [0, oo] $ #pause

Policies are just action distributions #pause

$ KL[pi (a | s; theta_(pi, i)), pi (a | s; theta_(pi, i + 1))] $ #pause

Introduce *trust region* $k$ to prevent large policy changes #pause

$ theta_(pi, i + 1) = V(s_0, theta_(pi, i)) dot nabla_(theta_pi) log pi (a_0 | s_0; theta_(pi, i)) #pause \ s.t. space KL[pi (a | s; theta_(pi, i)), pi (a | s; theta_(pi, i + 1))] < k $ #pause

See Trust Region Policy Optimization (TRPO), Natural Policy Gradient

==

$ theta_(pi, i + 1) = V(s_0, theta_(pi, i)) dot nabla_(theta_pi) log pi (a_0 | s_0; theta_(pi, i)) \ s.t. space KL[pi (a | s; theta_(pi, i)), pi (a | s; theta_(pi, i + 1))] < k $ #pause

Constrained optimization can be expensive and tricky to implement #pause

Often requires inverting the gradient or computing Hessian #pause

*Hack:* Add KL term to the objective (soft constraint) #pause

$ theta_(pi, i + 1) = V(s_0, theta_(pi, i)) dot  nabla_(theta_(pi, i)) [ log pi (a_0 | s_0; theta_(pi, i))] \ - rho nabla_(theta_(pi, i + 1))[KL[pi (a | s; theta_(pi, i)), pi (a | s; theta_(pi, i + 1))] ] $ 

= Proximal Policy Optimization

==
Proximal policy optimization (PPO) combines all we learned today #pause
- Value function for policy gradient (actor critic) #pause
- Advantage (stable updates, faster convergence) #pause
- Off-policy gradient (data efficiency) #pause
- Trust regions (stable updates, prevents policy collapse) #pause

Let us see a pseudocode PPO update

==

```python
for epoch in range(epochs):
    batch = collect_rollout(theta_beta)
    # Minibatching learns much faster
    # but is very slightly off-policy!
    for minibatch in batch:
        theta_pi = update_pi(
            theta_pi, theta_beta, theta_V, batch
        ) 
        theta_V = update_V(theta_V, batch)
    theta_beta = theta_pi
```

==
There are different variations of PPO #pause
- PPO clip
- PPO KL penalty
- PPO clip + KL penalty
- PPO clip + KL penalty + entropy bonus #pause

We will focus on the simplest version (PPO KL penalty)

==

#text(size: 24pt)[
#v(2em)
$ 
theta_(pi, i+1) = #pause theta_(pi, i) + alpha dot 
    underbrace((
        (#pin(1)pi (a | s; theta_(pi, i) )#pin(2)) / 
        (#pin(3)pi (a | s; theta_beta )#pin(4))

        #pin(5)A(s_0, s_1, r_0, theta_beta, theta_V)#pin(6)
    ), "Value") 
    \ dot (#pin(9)nabla_(theta_(pi, i)) [ log pi (a_0 | s_0; theta_(pi, i))]#pin(10) 
    - rho nabla_(theta_(pi, i + 1))[ #pin(7)KL[pi (a_0 | s_0; theta_(beta)), pi (a_0 | s_0; theta_(pi, i + 1))]#pin(8) ] )
$ #pause


#pinit-highlight-equation-from((1,4), (1,2), fill: red, pos: top, height: 2em)[Off-policy correction for minibatch] #pause

#pinit-highlight-equation-from((5,6), (5,6), fill: blue, pos: top, height: 1.2em)[Advantage] #pause

#pinit-highlight-equation-from((9,10), (9,10), fill: green, pos: bottom, height: 1.2em)[Policy gradient] #pause

#pinit-highlight-equation-from((7,8), (7,8), fill: orange, pos: bottom, height: 1.2em)[Trust region] #pause

#v(1.2em)

$ A(s_0, s_1, r_0, theta_beta, theta_V) = -V(s_0, theta_beta, theta_V) + (hat(bb(E))[cal(R)(s_(1)) | s_0; theta_beta] + not d gamma V(s_1, theta_beta, theta_V)) $ #pause

$ theta_(V, i+1) = argmin_theta_(V, i) (V(s_0, theta_beta, theta_(V,i)) - (hat(bb(E))[cal(R)(s_(1)) | s_0; theta_beta]+ not d gamma V(s_0, theta_beta, theta_(V,i) )))^2 $
]

==
*Personal opinion:* PPO is overrated, for some reason very popular #pause

Many hyperparameters, hard to implement, computationally expensive #pause

Cohere finds REINFORCE better than PPO for LLM training #pause

https://arxiv.org/pdf/2402.14740v1 #pause

Our experiments find that Q learning outperforms PPO #pause

*My suggestions:* #pause
- Try A2C first, solid actor-critic method, easy to implement #pause
- Large batches and regularization (weight decay, layer norm) helpful #pause
- You can make any algorithm work with enough effort!

==
PPO plays Pokemon! 

Video describes the RL experiment process, helpful for your final project 

https://youtu.be/DcYLT37ImBY?si=jJfZyYwFkPYMJYMy

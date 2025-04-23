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

// TODO: Cover inverse RL better as we use it in LLM lecture

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
            // y-label: $ pi (a | s; theta_(pi)) $,
            {
            plot.add(
                domain: (-2, 2), 
                style: (stroke: (thickness: 5pt, paint: red)),
                label: $ pi (a | s_0; theta_(pi)) $,
                x => 0.75 * normal_fn(-1, 0.3, x) + 0.25 * normal_fn(1, 0.3, x),
            ) 

            })
            draw.line((1.5,0), (1.5,4), stroke: orange)
            draw.content((1.5,5), text(fill: orange)[$ a_+ $])

            draw.line((4.5,0), (4.5,4), stroke: orange)
            draw.content((4.5,5), text(fill: orange)[$ a_- $])
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

= Admin

==
Two more lectures after today #pause
- Make sure you start on final projects! #pause

Homework 1 grading is done #pause
- Results on moodle #pause

Homework 2 grading deadline next Wednesday

==

Quiz 1 scores uploaded #pause
- Mean grade 57/100, modes at 25 and 85 #pause
- Someone forget their name #pause
    - If you have no score, come see me #pause
- 2 students with 100% on quiz 1 and quiz 2 can skip final quiz #pause

Mean course grade is 92%
- Lower mean grade after final quiz (second quiz dropped for most)

Final quiz on 17 April (next week), format subject to change #pause
- Question fundamental RL (V/Q/PG) #pause
- Question actor-critic #pause
- Question on new material (imitation/offline RL/etc)

= Review

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

*Review:* 
In on-policy RL, each iteration we collect a *new* dataset using our policy #pause

In off-policy RL, each iteration we *update* our dataset using our policy #pause

In imitation learning, we are given a fixed *expert* dataset

*Question:* Did you find imitation learning interesting? Why?

==

Imitation learning from a fixed dataset is attractive for many reasons #pause
- Fixed dataset results in much simpler code #pause
    - No need to collect new data, step environment, etc #pause
- Easier and more stable to train (supervised learning) #pause

But imitation learning (IL) also has disadvantages #pause
- Only imitates, does not think or plan #pause
    - Can only do as good as expert #pause
    - Humans are usually bad "experts" #pause
    - We want to do *better* than humans #pause

*Question:* Can we learn policies from fixed datasets that do better than the experts?

==
In *offline RL* or *batch RL*, we learn without exploration #pause

Like imitation learning, learn from a fixed dataset #pause
- Simpler implementation #pause
- Can learn from large existing datasets without collecting it youurself #pause

Unlike imitation learning, offline RL can do *better* than the expert #pause
- Can learn an optimal policy from a random "expert"! #pause
- How is this possible without exploration? #pause

In imitation learning, we learn to imitate dataset trajectories #pause

In offline RL, we learn to *stitch* together subtrajectories into optimal trajectories

==
#cimage("fig/12/stitching.png")

==
Offline RL is a very new field #pause

If we can make offline RL work reliably, it can be very powerful #pause
- Learn superhuman driving from existing Xiaomi dataset #pause
- Learn superhuman surgery from existing surgery videos #pause
- Learn language model finetuning from existing internet text #pause

I will also present my work on offline RL at ICRA next month #pause

https://sites.google.com/view/llm-marl/home

==
*Definition:* An *offline MDP* consists of: #pause
- MDP with unknown $cal(R), Tr$ #pause
- Dataset $bold(X)$ of episodes #pause
    - Following a policy $pi (a | s; theta_beta)$ #pause

$ (S, A, cal(R), Tr, gamma, bold(X)) $ #pause

#side-by-side[$ cal(R)(s_(t+1)) = ? $ #pause][$ Tr(s_(t+1) | s_t, a_t) = ? $ #pause] 

$ bold(X) = mat(bold(E)_[1], bold(E)_[2], dots) #pause = mat(
    mat(s_0, a_0, d_0, r_1; s_1, a_1, d_1, r_2; dots.v, dots.v, dots.v), mat(s_0, a_0, d_0, r_1; s_1, a_1, d_1, r_2; dots.v, dots.v, dots.v), dots
) $

==
*Goal:* learn a policy that maximizes the return #pause

$ argmax_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] $ #pause

There are two ways to approach offline RL #pause
- Improve behavior cloning with rewards #pause
- Off-policy RL without exploration #pause

Let us begin with behavior cloning first




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
Recall the behavior cloning objective #pause

Want to minimize difference between learned and expert policy #pause

$ argmin_(theta_pi) sum_(s in bold(X)) space KL(pi (a | s; theta_beta), pi (a | s; theta_pi)) $ #pause

From this, we derive the cross entropy loss #pause

$ argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $ 

==

$ argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $ #pause

Consider the following situation: #pause
- Two possible actions $A = {a_+, a_-}$ #pause
- Single state $s_0$ in the dataset, visited *twice* #pause
- First time, expert takes action $a_+$ in $s$ #pause
- Second time, expert takes action $a_-$ in $s$ #pause

Expert must behave better in one state than the other! #pause

$ argmin_(theta_pi) sum_(a in {a_+, a_-}) - pi (a | s_0; theta_beta) log pi (a | s_0; theta_pi) $


==
// $ argmin_(theta_pi) sum_(a in {a_+, a_-}) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $ 

#side-by-side[
    $ pi (a_+ | s_0; theta_beta) = 0.5 $
    #cimage("fig/12/good-driver.png", height: 60%)
][
    $ pi (a_- | s_0; theta_beta) = 0.5 $
    #cimage("fig/11/texting.jpg", height: 60%)
] #pause

*Question:* Which action is better behavior?

==
#side-by-side[
    $ pi (a_+ | s_0; theta_beta) = 0.5 $
    #cimage("fig/12/good-driver.png", height: 40%)
][
    $ pi (a_- | s_0; theta_beta) = 0.5 $
    #cimage("fig/11/texting.jpg", height: 40%)
] #pause

*Question:* Two actions in same state, what policy $theta_pi$ does BC learn? #pause

*Answer:* Randomly choose $a in {a_+, a_-}$ #pause

*Question:* Is this a good idea?

==
#side-by-side[
    $ pi (a_+ | s_0; theta_beta) = 0.5 $
    #cimage("fig/12/good-driver.png", height: 60%)
][
    $ pi (a_- | s_0; theta_beta) = 0.5 $
    #cimage("fig/11/texting.jpg", height: 60%)
] #pause
*Question:* We know which action is better, how can we measure this? #pause

*Answer:* Reward! In BC, no reward. In offline RL, we have reward!

==

Expert has equal probability for both good and bad actions #pause

#side-by-side[
    #bimodal #pause
][
    #bimodal_pi #pause
]

With IL, we can only imitate the expert #pause

With offline RL, we have empirical rewards/returns, we can do better!

#side-by-side[

$ hat(bb(E))[cal(R)(s_1) | s_0, a_0] $

][
$ hat(bb(E))[cal(G)(bold(tau)) | s_0; theta_beta] $
]

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
] #pause

*Question:* How should we change $pi (a_+ | s_0; theta_pi)$ and $pi (a_- | s_0; theta_pi)$? #pause

*Answer:* Increase probability of $a_+$, decrease probability of $a_-$

==
#side-by-side[
    #bimodal #pause
][
    #bimodal_reweight #pause
]

We want to reweight action probabilities based on reward or return

==
$ argmin_(theta_pi) sum_(a in {a_+, a_-}) - pi (a | s_0; theta_beta) log pi (a | s_0; theta_pi) $ 

Increase probability of $a_+$ and decrease probability of $a_-$ using reward #pause

*Question:* How? #pause Hint:

$ argmin_(theta_pi) - pi (a_+ | s_0; theta_beta) log pi (a_+ | s_0; theta_pi) - pi (a_- | s_0; theta_beta) log pi (a_- | s_0; theta_pi) $ #pause

*Answer:* Reweight each action in the objective using the reward #pause

#text(size: 24pt)[$ argmin_(theta_pi) - #redm[$0.9$] pi (a_+ | s_0; theta_beta) log pi (a_+ | s_0; theta_pi) - #redm[$0.1$] pi (a_- | s_0; theta_beta) log pi (a_- | s_0; theta_pi) $]

==
#text(size: 24pt)[$ argmin_(theta_pi) - #redm[$0.9$] pi (a_+ | s_0; theta_beta) log pi (a_+ | s_0; theta_pi) - #redm[$0.1$] pi (a_- | s_0; theta_beta) log pi (a_- | s_0; theta_pi) $] #pause

More generally, use weights $w$ #pause

#text(size: 24pt)[$ argmin_(theta_pi) - #redm[$w_+$] pi (a_+ | s_0; theta_beta) log pi (a_+ | s_0; theta_pi) - #redm[$w_-$] pi (a_- | s_0; theta_beta) log pi (a_- | s_0; theta_pi) $]

*Question:* What can we use for $w_+, w_-$? #pause

$ hat(bb(E))[cal(R)(s_1) | s_0; theta_beta] $

==

*Definition:* In *Expectation Maximization Reinforcement Learning* (EMRL, Hinton), we reweight the behavior cloning objective using the reward #pause

$ theta_pi = argmin_(theta_pi) [ underbrace(sum_(s_0 in bold(X)) sum_(a in A) - pi (a | s_0; theta_beta) log pi (a | s_0; theta_pi), "BC objective") dot underbrace(hat(bb(E))[cal(R)(s_1) | s_0, a], "Weighting") ]  $ 

==

$ theta_pi = argmin_(theta_pi) [ sum_(s_0 in bold(X)) sum_(a in A) - pi (a | s_0; theta_beta) log pi (a | s_0; theta_pi) dot hat(bb(E))[cal(R)(s_1) | s_0, a] ] $ #pause

Consider the simplified example, now with rewards $r$ #pause

#text(size: 24pt)[$ argmin_(theta_pi) - #redm[$r_+$] pi (a_+ | s_0; theta_beta) log pi (a_+ | s_0; theta_pi) - #redm[$r_-$] pi (a_- | s_0; theta_beta) log pi (a_- | s_0; theta_pi) $] #pause

*Question:* Are there any problems with EMRL? #pause

Hint: What if the reward is negative? #pause

Reweighting only makes sense with positive weights #pause
 
EMRL only works with positive rewards!

==

#text(size: 24pt)[$ argmin_(theta_pi) - #redm[$r_+$] pi (a_+ | s_0; theta_beta) log pi (a_+ | s_0; theta_pi) - #redm[$r_-$] pi (a_- | s_0; theta_beta) log pi (a_- | s_0; theta_pi) $] #pause

$ bb(E)[cal(R)(s_1) | s_0, a_0] in [-oo, oo] $ #pause

We want our algorithm to work with positive and negative rewards #pause

Need a mapping between rewards and weights $f: [-oo, oo] |-> [0, oo]$ #pause

*Question:* Any other properties for $f$? #pause Hint: Does $f(r) = |r|$ work? #pause

*Answer:* $f$ must be *monotonic* to ensure we still maximize rewards! #pause

$ r_+ > r_- => f(r_+) > f(r_-) $

==

*Question:* What functions $f: [-oo, oo] |-> [0, oo]$ are monotonic? #pause

#align(center, exp_plot) #pause

$ f(r) = e^r $

==
*Definition:* Reward Weighted Regression (RWR) reweights the behavior cloning objective using the exponentiated reward #pause

$ theta_pi = argmin_(theta_pi) sum_(s_0 in bold(X)) sum_(a in A) - pi (a | s_0; theta_beta) log pi (a | s_0; theta_pi) dot exp(hat(bb(E))[cal(R)(s_1) | s_0, a]) $ #pause

Consider an infinitely large and diverse dataset containing all $s, a$ #pause

Then, weights are proportional to Boltzmann distribution (softmax) #pause

$ sum_(a_0 in A) exp(hat(bb(E))[cal(R)(s_1) | s_0, a_0]) prop sum_(a_i in A) ( exp(hat(bb(E))[cal(R)(s_1) | s_0, a_i]) ) / ( sum_(a_0 in A) exp(hat(bb(E))[cal(R)(s_1) | s_0, a_0]) ) $

==
$ theta_pi = argmin_(theta_pi) sum_(s_0 in bold(X)) sum_(a in A) - pi (a | s_0; theta_beta) log pi (a | s_0; theta_pi) dot exp(hat(bb(E))[cal(R)(s_1) | s_0, a]) $ #pause

RWR find $theta_pi$ that maximizes the reward #pause

*Question:* Do we maximize the reward in RL? #pause

*Answer:* No, we maximize the return! #pause

$ theta_pi = argmin_(theta_pi) sum_(s_0 in bold(X)) sum_(a in A) - pi (a | s_0; theta_beta) log pi (a | s_0; theta_pi) dot underbrace(exp(hat(bb(E))[cal(G)(bold(tau)) | s_0; theta_beta]), "Replace reward with return") $ 

==
$ theta_pi = argmin_(theta_pi) sum_(s_0 in bold(X)) sum_(a in A) - pi (a | s_0; theta_beta) log pi (a | s_0; theta_pi) dot exp(hat(bb(E))[cal(G)(bold(tau)) | s_0; theta_beta]) $ 

This works in theory, but does not work well in practice #pause

*Question:* Why does this fail in practice? #pause

*Answer:* #pause
- Need infinite rewards to approximate Monte Carlo return #pause
- Returns can be big or small, causing overflows $exp(cal(G)(bold(tau))) -> 0, oo$ #pause

*Question:* Similar problems with actor critic, what was the solution? #pause
- Introduce TD value function (remove infinite sum) #pause
- Introduce advantage (normalize return)

==
$ theta_pi = argmin_(theta_pi) sum_(s_0 in bold(X)) sum_(a in A) - pi (a | s_0; theta_beta) log pi (a | s_0; theta_pi) dot exp(hat(bb(E))[cal(G)(bold(tau)) | s_0; theta_beta]) $ #pause

$ theta_pi = argmin_(theta_pi) sum_(s_0 in bold(X)) sum_(a in A) - pi (a | s_0; theta_beta) log pi (a | s_0; theta_pi) dot underbrace(exp(A(s, a, theta_beta) ), "Use advantage instead") $ #pause

$ A(s, a, theta_beta) = Q(s, a, theta_beta) - V(s, theta_beta) $ #pause

$ A(s_t, s_(t+1), theta_beta) = - V(s_t, theta_beta) + r_t + gamma V(s_(t+1), theta_beta) $

==

*Definition:* Monotonic Advantage Re-Weighted Imitation Learning (MARWIL) reweights the behavior cloning objective based on the advantage #pause

*Step 1:* Learn a value function for $theta_beta$ #pause

$ theta_V &= argmin_(theta_V) (V(s_0, theta_beta, theta_V) - y)^2 #pause \ 
y &= hat(bb(E))[cal(R)(s_1) | s_0, a_0] + gamma V(s_1, theta_beta, theta_V) $ 

==

*Step 2:* Learn policy using weighted behavioral cloning #pause

$ A(s_t, s_(t+1), theta_beta, theta_V) = - V(s_t, theta_beta, theta_V) + hat(bb(E))[cal(R)(s_1) | s_0, a_0] + gamma V(s_(t+1), theta_beta, theta_V) $ #pause

$ theta_pi = argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) underbrace(- pi (a | s; theta_beta) log pi (a | s; theta_pi), "BC objective") dot underbrace(exp(A(s_t, s_(t+1), theta_beta, theta_V)), "Advantage reweighting") $ 

==

*Question:* Is MARWIL RL or supervised learning? #pause

*Answer:* Both #pause
- Learn policy using supervised learning (SL) #pause
- But weights require learning value function (RL) #pause

*Question:* We used TD objective, can we also use MC objective? #pause

$
V(s_0, theta_beta, theta_V) &= hat(bb(E))[cal(R)(s_1) | s_0; theta_beta] + gamma V(s_1, theta_beta, theta_V) #pause \

V(s_0, #pin(1)theta_beta#pin(2), theta_V) &= sum_(t=0)^oo gamma^t hat(bb(E))[cal(R)(s_(t+1)) | s_0; #pin(3)theta_beta#pin(4)] $ #pause

#pinit-highlight(1,2)
#pinit-highlight(3,4)

*Answer:* Yes, because we learn $V$ for $theta_beta$ not $theta_pi$

==
Add improvements to MARWIL to derive other offline RL algorithms #pause
- Advantage Weighted Regression (AWR) #pause
- Advantage Weighted Actor Critic (AWAC) #pause
- Critic Regularized Regression (CRR) #pause
- Implicit Q learning (IQL) #pause
- Maximum a Posteriori Optimization (MPO)

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
There are two standard approaches to offline RL #pause

1. Reweight the BC loss using rewards/returns #pause
2. Improve off-policy algorithms to work without exploration #pause

Finished first, now let us visit the second

==
*Goal:* Derive offline RL algorithm from an off-policy algorithm #pause

*Question:* Why off-policy instead of on-policy algorithm? #pause

On-policy requires collecting data with $theta_pi$ #pause
- But we cannot do this! Dataset is collected with $theta_beta$ 
- $theta_beta != theta_pi$, cannot use on-policy method #pause

Off-policy can learn from any trajectories #pause
- Trajectory collected following $theta_beta$
- Can use $theta_beta$ trajectory to update $theta_pi$ 

==
Ok, let us choose an off-policy algorithm to use #pause

*Question:* Which off-policy RL algorithms do we know? #pause
- Q learning #pause
- DDPG (continuous Q learning) #pause
- Off-policy gradient (does not work well, ignore for now) #pause

*Question:* Temporal Difference or Monte Carlo Q learning? #pause
- MC is on-policy
- Only TD Q learning is off-policy

==
Recall the standard Q learning algorithm #pause

```python
while not terminated:
    transition = env.step(action)
    buffer.append(transition)
    train_data = buffer.sample()
    J = grad(td_loss)(theta_Q, theta_T, Q, train_data)
    theta_Q = opt.update(theta_Q, J)
``` #pause

*Question:* What can we do to make this offline? Without exploration? #pause

*Answer:*
- Put dataset into replay buffer
- Get rid of `env` code

==

```python
for x in X:
    buffer.append(x) # Add dataset to replay buffer
# Comment out exploration code
# while not terminated:
    # transition = env.step(action)
    # buffer.append(transition)
for epoch in num_epochs:
    train_data = buffer.sample()
    J = grad(td_loss)(theta_Q, theta_T, Q, train_data)
    theta_Q = opt.update(theta_Q, J)
``` 

==
```python
for x in X:
    buffer.append(x) # Add dataset to replay buffer

for epoch in num_epochs:
    train_data = buffer.sample()
    J = grad(td_loss)(theta_Q, theta_T, Q, train_data)
    theta_Q = opt.update(theta_Q, J)
``` #pause

*Question:* Will this work? #pause

*Answer:* It can! But only for very simple problems #pause

For harder/interesting problems, loss quickly becomes `NaN` #pause

Let us investigate why

==

On assignment 2, many of you found issues with deep Q learning #pause
1. Q value would often become very large #pause
2. Loss would become very large #pause
3. Loss/parameters become `NaN` #pause

This was not your fault, it is a known problem in RL! #pause

Call it the *deadly triad*, because it is caused by combining three factors: #pause
1. Function approximation (deep neural network) #pause
2. Recursive bootstrapping (TD, $Q(s, a) = r + gamma max Q(s, a)$) #pause
3. Off-policy learning/limited exploration #pause

Let us further investigate the deadly triad

// Too many states to learn Q
// Must generalize to unseen states
// TD + NN can update other states
// Leads to divergence of the value function
    // Caused by argmax, tends to explode
    // If we cannot explore, we cannot "fix" the diverged states
// Cannot visit unvisited states, what can we do?
    // Limit Q function extrapolation
        // Particularly interested in overestimation
==
Imagine a toy MDP #pause

$ S = {s} #pause quad A = {1, 2} #pause quad Q(s, a, theta_Q) = theta_Q dot a #pause quad cal(R)(s) = 0 #pause quad gamma = 1$

Can update $theta_Q$ using simple TD update #pause

$ theta_Q = theta_Q - underbrace([Q(s, a, theta_Q) - (r + gamma max_(a' in A) Q(s', a', theta_Q))], "Q error, can consider" nabla cal(L) )$ #pause

$ theta_Q = theta_Q - [Q(s, a, theta_Q) - max_(a' in A) Q(s', a', theta_Q)]$ #pause

Importantly, to simulate off-policy/offline RL, we have limited dataset #pause
- We only have $s, a=1$ in our dataset, not $s, a=2$ #pause

Let us perform some updates to $theta_Q$ and see what happens

//$ Q(s, 1, theta_Q) = theta_Q dot a = 1 dot 1 = 1 $ #pause

//Receive zero reward $cal(R)(s) = 0$, now let us update $theta_Q$



==
//$ theta_Q = Q(s, 1, theta_Q) - (0 + gamma max_(a' in A) {underbrace(1 dot 1, (a=1) \ 1), underbrace(1 dot 2, (a=2) \ 2)}) $

Initialize $theta_Q = 1$, update for $a=1$ #pause

$ 
theta_Q &= theta_Q - [Q(s, a, theta_Q) - max_(a' in A) Q(s, a', theta_Q)] \ #pause
theta_Q &= theta_Q - [ Q(s, 1, theta_Q) - (max {Q(s, 1, theta_Q), Q(s, 2, theta_Q)}) ] \ #pause
theta_Q &= theta_Q - [ Q(s, 1, theta_Q) - (max {theta_Q dot 1, theta_Q dot 2}) ] \ #pause
theta_Q &= theta_Q - [ Q(s, 1, theta_Q) - (max {1 dot 1, 1 dot 2}) ] \ #pause
theta_Q &= 1 - [1 - 2] \ #pause
theta_Q &= 2 $

==

Repeat with $theta_Q = 2$, update for $a=1$

$ 
theta_Q &= theta_Q - [Q(s, a, theta_Q) - max_(a' in A) Q(s, a', theta_Q)] \ #pause
theta_Q &= theta_Q - [ Q(s, 1, theta_Q) - (max {Q(s, 1, theta_Q), Q(s, 2, theta_Q)}) ] \ #pause
theta_Q &= theta_Q - [ Q(s, 1, theta_Q) - (max {theta_Q dot 1, theta_Q dot 2}) ] \ #pause
theta_Q &= theta_Q - [ Q(s, 1, theta_Q) - (max {2 dot 1, 2 dot 2}) ] \ #pause
theta_Q &= 2 - [2 - 4] \ #pause
theta_Q &= 4 $

==

Repeat with $theta_Q = 4$, update for $a=1$

$ 
theta_Q &= theta_Q - [Q(s, a, theta_Q) - max_(a' in A) Q(s, a', theta_Q)] \ #pause
theta_Q &= theta_Q - [ Q(s, 1, theta_Q) - (max {Q(s, 1, theta_Q), Q(s, 2, theta_Q)}) ] \ #pause
theta_Q &= theta_Q - [ Q(s, 1, theta_Q) - (max {theta_Q dot 1, theta_Q dot 2}) ] \ #pause
theta_Q &= theta_Q - [ Q(s, 1, theta_Q) - (max {4 dot 1, 4 dot 2}) ] \ #pause
theta_Q &= 4 - [4 - 8] \ #pause
theta_Q &= 8 $

==
Each time we update, $theta_Q$ increases, even if $cal(R)(s)=0$ #pause

Larger $theta_Q$ means larger $Q(s,a, theta_Q)$ for both $a=1, a=2$ #pause

#side-by-side[Eventually $theta_Q -> oo$ #pause][$Q(s, a, theta_Q) -> oo$ #pause]

*Question:* Why does $theta_Q$ keep increasing? #pause
+ (Function approximation) We share parameters for $a=1$ and $a=2$ #pause
    - Updating $theta_Q$ for $a=1$ also updates for $a=2$ #pause
+ (Recursive bootstrap) updating $theta_Q$ for $a=1$ uses $max_(a in {1, 2})$ in label #pause
+ (Off-policy) Trains on old data, does not contain $a=2$ #pause
    - Eventually, greedy policy should visit $a=2$ #pause

Offline RL guarantees case 3, because we will never explore

==
+ (Function approximation) We share parameters for $a=1$ and $a=2$
    - Updating $theta_Q$ for $a=1$ also updates for $a=2$
+ (Recursive bootstrap) updating $theta_Q$ for $a=1$ uses $max_(a in {1, 2})$ in label
+ (Off-policy) Trains on old data, does not contain $a=2$ 
    - Eventually, greedy policy should visit $a=2$ #pause

If we can prevent any of these, we can learn a Q function offline #pause
#side-by-side[
    1. Do not use neural network #pause
][
    Need nn for large state space #pause
]

#side-by-side[
    2. Use MC (non-recursive) instead of TD (recursive) #pause
][
    MC is on-policy only, must use TD #pause
]

#side-by-side[
    3. Visit all possible states/actions #pause
][
    Not possible with fixed dataset
]

= Constraining Q
==
So far, offline Q learning seems impossible #pause

Root problem is the out-of-distribution (OOD) TD update #pause

$ max_(a in A) Q(s, a); quad (s, a) in.not bold(X) $ #pause

We *overextrapolate* for state-action pairs missing from dataset #pause

*Question:* What can we do about this? #pause

*Answer:* Ignore $Q$ for missing state-action pairs #pause

==
We want to ignore $Q(s, a)$ where $s, a in.not bold(X)$ #pause

For a finite discrete state space, this is easy! #pause

Only consider actions we have in our dataset $overline(A)(s)$ #pause

$ overline(A)(s) = {a | (s, a) in bold(X) } $ #pause

$ Q(s_0, a_0, theta_Q) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma max_(#redm[$a in overline(A)$]) Q(s_(1), a, theta_Q) $ #pause
 
We ignore actions missing from the dataset! #pause
- This will fix deadly triad via (2. Recursive bootstrap) #pause

*Question:* What if the state space is continuous? Will this work?

==
Continuous state space means we cannot check $(s, a) in bold(X)$ #pause
- Every state $s$ in $bold(X)$ will be different #pause
    - Each state will only have one action #pause
    - $max_(a in overline(A))$ returns the action in the dataset #pause
    - We will learn the behavior policy, not optimal policy #pause

*Solution:* Continuous relaxation of $overline(A)$ #pause

$ overline(A)(s) = {a |  pi (a | s; theta_beta) > rho} $ #pause

Only consider actions that our behavior policy might take #pause

We can learn $theta_beta$ using behavioral cloning



// How can we constrain Q?
    // BCQ - restrict actions to those in the dataset
    // CQL - penalize large out of distribution Q values

==
*Definition:* Batch Constrained Q Learning (BCQ) learns the behavior policy, only considers behavior policy actions in the TD update #pause

*Step 1:* Learn the behavior policy through BC #pause

$ theta_pi = argmin_(theta_pi) sum_(s in bold(X)) sum_(a in A) - pi (a | s; theta_beta) log pi (a | s; theta_pi) $ #pause

*Step 2:* Learn the Q function #pause

$ theta_(Q, i + 1) &= argmin_(theta_(Q, i)) (Q(s_0, a_0, theta_pi, theta_(Q, i)) - y)^2 \  #pause
y &= hat(bb(E))[cal(R)(s_1) | s_0, a_0] + gamma max_(#redm[$a in overline(A)$]) Q(s_1, a, theta_pi, theta_(Q, i)) $

==

$ theta_(Q, i + 1) &= argmin_(theta_(Q, i)) (Q(s_0, a_0, theta_pi, theta_(Q, i)) - y)^2 \ 
y &= hat(bb(E))[cal(R)(s_1) | s_0, a_0] + gamma max_(a in overline(A)) Q(s_1, a, theta_pi, theta_(Q, i)) $ #pause

Constrain $overline(A)$ to contain actions the behavior policy would take #pause

$ overline(A) = {a | pi (a | s_1; theta_pi) > rho} $ #pause

where hyperparameter $rho$ determines the level of extrapolation #pause
- Bigger $rho$ means less extrapolation, less optimal #pause
- Smaller $rho$ means more extrapolation, more optimal #pause
- Too much extrapolation leads to deadly triad!

==
BCQ is a good algorithm, but it requires learning a policy using BC #pause

Can we do offline Q learning without learning the behavior policy? #pause

What if we make Q small for OOD actions? #pause

$ min_(a in.not overline(A)) Q(s, a) $ #pause

This still requires knowing $overline(A)$ and use BC #pause

Can we do this without knowing $overline(A)$?

==

*Solution:* Create two conflicting objectives: #pause
- Learn $Q$ as usual with TD error #pause
- Minimize $Q$ values #pause

*Key idea:* This should force all $Q(s, a)$ to be small, unless $(s, a) in bold(X)$ #pause


$ argmin_(theta_Q) space underbrace((Q(s_0, a_0, theta_pi, theta_(Q)) - y)^2, "TD error") + underbrace(sum_(a in A) Q(s_1, a, theta_pi, theta_Q), "Minimize Q") #pause  \

y = hat(bb(E))[cal(R)(s_1) | s_0, a_0] + gamma max_(a in overline(A)) Q(s_1, a, theta_pi, theta_(Q, i)) $

==

$ argmin_(theta_Q) space underbrace((Q(s_0, a_0, theta_pi, theta_(Q)) - y)^2, "TD error") + underbrace(sum_(a in A) Q(s_1, a, theta_pi, theta_Q), "Minimize Q")  \

y = hat(bb(E))[cal(R)(s_1) | s_0, a_0] + gamma max_(a in A) Q(s_1, a, theta_pi, theta_(Q, i)) $

However, the scale of TD error and Q values can be different #pause

Very sensitive to scale, we might just set all $Q(s, a) = -oo$ #pause

We need to balance the second term a little better

==
$ argmin_(theta_Q) space underbrace((Q(s_0, a_0, theta_pi, theta_(Q)) - y)^2, "TD error") + underbrace(sum_(a in A) Q(s_1, a, theta_pi, theta_Q), "Minimize Q")  \

y = hat(bb(E))[cal(R)(s_1) | s_0, a_0] + gamma max_(a in A) Q(s_1, a, theta_pi, theta_(Q, i)) $ #pause

We can subtract $Q$ for the action we take in the dataset! #pause

$ argmin_(theta_Q) space underbrace((Q(s_0, a_0, theta_pi, theta_(Q)) - y)^2, "TD error") + underbrace(sum_(a in A) Q(s_1, a, theta_pi, theta_Q) - Q(s_1, a_1, theta_pi, theta_Q), "Minimize Q")
$

This balances the second term to be closer to zero

==
$ argmin_(theta_Q) space underbrace((Q(s_0, a_0, theta_pi, theta_(Q)) - y)^2, "TD error") + underbrace(sum_(a in A) Q(s_1, a, theta_pi, theta_Q) - Q(s_1, a_1, theta_pi, theta_Q), "Minimize Q")
$ #pause

While minimizing all $Q$ is useful, we care most about the biggest $Q$ #pause
 
We take $max Q$, so we should emphasize minimizing $max Q$ #pause

Replace sum with logsumexp, a combination of max and sum #pause

$ underbrace((Q(s_0, a_0, theta_pi, theta_(Q)) - y)^2, "TD error") + underbrace(log(sum_(a in A) exp Q(s_1, a, theta_pi, theta_Q)) - Q(s_1, a_1, theta_pi, theta_Q), "Minimize Q")
$ 

==
*Definition:* Conservative Q Learning (CQL) learns a Q function that minimizes $Q$ for out of distribution actions

$ theta_(Q, i + 1) &= argmin_(theta_(Q, i))  underbrace((Q(s_0, a_0, theta_pi, theta_(Q, i)) - y)^2, "TD error") + z^2  \ #pause 
y &= hat(bb(E))[cal(R)(s_1) | s_0, a_0] + gamma max_(a in A) Q(s_1, a, theta_pi, theta_(Q, i)) \ #pause
z &= underbrace((log sum_(a in A) exp Q(s_1, a, theta_pi, theta_(Q, i))), "Minimize Q for all" a) - underbrace(Q(s_1, a_1, theta_pi, theta_(Q, i)), "Push up Q for" \ "in-distribution" a_1) 
$

= Conclusion

==
Today, we looked at offline RL
- Like IL, but learns optimal policy instead of expert policy

Two standard approaches to offline RL #pause
- Behavioral cloning with weighted objectives #pause
    - EMRL
    - RWR 
    - MARWIL #pause
- Breaking the deadly triad with Q learning #pause
    - BCQ
    - CQL
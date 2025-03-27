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

= Quiz
==
- After all students put away their computer/notes/phone I will hand out exams #pause
- If you have computer/notes/phone out after this point, it counts as cheating #pause
- I will hand out exams face down, do not turn them over until I say so #pause
- After turning them over, I will briefly explain each question #pause
- After my explanation, you will have 75 minutes to complete the exam #pause
- After you are done, give me your exam and go relax outside, we resume class at 8:30

==

- There may or may not be different versions of the exam #pause
- If your exam has the answer for another version, it is cheating #pause
- Instructions are in both english and chinese, english instructions take precedence #pause
- Good luck!

==
- 在所有学生收起电脑/笔记/手机后,我会分发试卷。
- 如果在此之后仍有电脑/笔记/手机未收,将视为作弊。
- 试卷会背面朝下发下,在我宣布开始前请勿翻面。
- 试卷翻面后,我会简要说明每道题的注意事项。
- 说明结束后,你们有75分钟完成考试。
- 交卷后请到教室外休息,8:30恢复上课。
- 试卷可能存在不同版本,细节略有差异。
- 若你的试卷上出现其他版本的答案,将被判定为作弊。
- 试卷说明为中英双语,若内容冲突以英文为准。
- 祝各位考试顺利!

= Admin
==
After today, you will know all the foundations of decision making #pause

You should be able to understand research papers on:
- MDPs, bandits, RL algorithms, even some control problems! #pause

Next week, we begin to investigate interesting topics of decision making #pause

Right now, my plan is:
- Imitation Learning
- Offline RL
- Memory and POMDPs
- Large Language Models #pause

*Question:* Should we replace a topic with something else?

==

- Imitation learning
    - Sometimes, designing a reward function is hard
    - It is easier to demonstrate desired behavior to agents
        - Instead of reward for surgery, do what human does
        - Instead of reward for self driving, do what human does
    - With imitation learning, can learn behaviors without rewards
    - Closer to supervised learning, easier to train
    - Policies are not better than dataset/humans

==

- Offline RL
    - RL without exploration
    - How can we learn policies from a fixed dataset?
        - Learn surgery from surgical videos (no need to kill patients)
        - Learn driving from Xiaomi driving dataset (no need to crash cars)
    - Unlike imitation learning, can do *better* than dataset
    - Very new topic (2-3 years old)
        - Does not work very well (yet)

==

- Memory and POMDPs (my research focus)
    - So far, we focused on video games
        - MDP
    - Many interesting problems are not Markov
        - Think of robot with camera, not Markov
        - Almost every task has sensor noise, not Markov
    - Can we extend RL to work for virtually any problem?
        - Yes, requires long-term memory
        - LSTM, transformer, etc
    - May also have time to introduce world models
        - Dreamer, TD-MPC, etc


==

- Large Language Models
    - Can train LLMs using unsupervised learning
        - They only learn to predict next word
    - We use RL to teach them to interact with humans
        - Apply policy gradient to textual MDP
        - DeepSeek math/GRPO
        - RL-adjacent methods (DPO)

==
Also a possibility to split lecture:
- E.g., 1 hour imitation learning, 1 hour something new #pause

*Question:* Any topic sound boring? #pause

*Question:* Any suggestions for other topics? #pause
- Maybe just focus on a specific paper? #pause

Alternative topics:
- Multi-agent RL
- Model-based RL and world-models
- Evolutionary algorithms
==
Homework 2 progress #pause

If you did not already start, you might be in trouble #pause

Experiments take a long time, start as soon as possible #pause

Harder and requires more debugging than `FrozenLake` assignment

==
Those using Tencent AI Arena (Honor of Kings): #pause
- Backup project should not rely on Honor of Kings #pause
- *Make sure to save your code regularly* #pause
    - Everything stored on Tencent VMs, not sure how safe code is #pause
- There is already a PPO baseline, cannot use PPO #pause
    - Instead, consider DDPG, SAC, TRPO, DQN variant, etc #pause
- Cannot install new python libraries (Tencent security issue) #pause
    - No `jax`, must use `torch` 
    - You must learn Tencent's strange callback system 
        - Prevents copy/pasting, so `torch` is ok


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
Alternative descriptions of actor critic algorithms

https://lilianweng.github.io/posts/2018-04-08-policy-gradient/

==
#cimage("fig/09/algos.png")
==
There are two approaches to actor critic #pause
#side-by-side[
1. *Policy gradient based:* #pause
PG with $V$ instead of MC #pause
    - A2C #pause
    - TRPO #pause
    - PPO #pause
    - IMPALA #pause
    - ACKTR #pause
    - ACER #pause
    - PPG #pause

][
2. *Q learning based:* #pause
Learn $Q$ for a specific policy #pause
    - DDPG #pause
    - TD3 #pause
    - SAC #pause
    - Q-Prop #pause
    - QT-Opt #pause
    - NAF #pause
    - MPO
]


= Deterministic Policy Gradient
// Introduce learned argmax policy as function
// Derive policy gradient again, but starting with Q function instead of return
// Go into DDPG

// Could instead try and start from making Q learning continuous
// Factorize policy into mu and pi (pi used for exploration)
==
*Question:* Why did we introduce policy gradient methods? #pause

#cimage("fig/08/benben.png", height: 80%)
==
#side-by-side[
    #cimage("fig/08/benben.png", height: 50%) #pause
][
    *Question:* Why did Q learning fail BenBen? #pause

    $ A = [0, 2 pi]^12 $ #pause

]
$ pi (a_t | s_t; theta_pi) =  cases( 
  1 "if" a_t = argmax_(a_t in A) Q(s_t, a_t, theta_pi), 
  0 "otherwise"
) $  #pause

Infinitely many $a_t$ -- compute $Q$ for each and take $argmax$ over all

==

$ pi (a_t | s_t; theta_pi) =  cases( 
  1 "if" a_t = argmax_(a_t in A) Q(s_t, a_t, theta_pi), 
  0 "otherwise"
) $ #pause

The greedy policy cannot work with continuous action spaces #pause

Can we replace $argmax$ with a different deterministic function? #pause

Remember that the Q function and greedy policy are different #pause

We can learn Q for *any* policy, does not need to be greedy policy #pause

Let us quickly review the Q function and value function

==
Start with general form of Temporal Difference Q function  #pause

$ Q(s_0, a_0, theta_pi) = underbrace(bb(E)[cal(R)(s_(t+1)) | s_0, a_0], "Reward for taking" a_0) + gamma underbrace(V(s_1, theta_pi), cal(G) "following" theta_pi) $ #pause

#v(-0.5em)
We can replace $V$ with $Q$ if $#redm[$a$] tilde pi (dot | s_1; theta_pi)$ #pause

$ Q(s_0, a_0, theta_pi) = underbrace(bb(E)[cal(R)(s_(t+1)) | s_0, a_0], "Reward for taking" a_0) + gamma underbrace(Q(s_1, #redm[$a$], theta_pi), cal(G) "following" theta_pi) $ #pause

For the greedy policy, we can reduce $Q$ further #pause

$ Q(s_0, a_0, theta_pi) = underbrace(bb(E)[cal(R)(s_(t+1)) | s_0, a_0], "Reward for taking" a_0) + underbrace(max_(a in A) gamma Q(s_1, a, theta_pi), cal(G) "following" theta_pi) $

==
$ cancel(Q(s_0, a_0, theta_pi) = bb(E)[cal(R)(s_(t+1)) | s_0, a_0] + max_(a in A) gamma Q(s_1, a, theta_pi))  $ #pause

Cannot use the max Q function with BenBen #pause

$
Q(s_0, a_0, theta_pi) &= bb(E)[cal(R)(s_(t+1)) | s_0, a_0] + gamma V(s_1, theta_pi) \
Q(s_0, a_0, theta_pi) &= bb(E)[cal(R)(s_(t+1)) | s_0, a_0] + gamma Q(s_1, a, theta_pi); quad a tilde pi (dot | s_1; theta_pi) 
$ #pause

*Question:* Can we use continuous $a$ with $Q$? #pause *Answer:* Yes  #pause

Q function $=>$ no problem, policy $=>$ problem $quad #redm[$argmax_(a in A)$] Q(s, a, theta_pi)$ #pause

Greedy deterministic policy worked well for discrete actions #pause

Can we learn a different deterministic policy for continuous actions?

==
$ Q(s_0, a_0, theta_pi) &= bb(E)[cal(R)(s_(t+1)) | s_0, a_0] + gamma Q(s_1, a, theta_pi); quad a tilde pi (dot | s_1; theta_pi) $

*Question:* What method can we use to learn $theta_pi$? #pause

*Answer:* Policy gradient #pause

Perhaps our solution will combine $Q$ with policy gradient #pause

// We will derive the solution like David Silver likely did #pause

The trick is to consider a *deterministic* policy #pause

#side-by-side[
    $ cancel(a tilde pi (dot | s; theta_pi)) $ #pause
][
    $ a = mu(s, theta_mu) $ #pause
][
    $ mu: S times Theta |-> A $ #pause
]

$ Q(s_0, a_0, theta_pi) &= bb(E)[cal(R)(s_(t+1)) | s_0, a_0] + gamma Q(s_1, #redm[$mu$] (s_1, theta_mu), theta_pi) $



==
So let us learn parameters $theta_mu$ for this deterministic function #pause

Recall policy gradient, we find $theta_pi$ using gradient ascent #pause

$ theta_(pi, i + 1) = theta_(pi, i) + alpha dot nabla_theta_(pi, i) bb(E)[cal(G)(bold(tau)) | s_0; theta_(pi, i)] $ #pause

We need to know $nabla_theta_pi bb(E)[cal(G)(bold(tau)) | s_0; theta_pi]$ #pause

We found this for the stochastic policy #pause

Can we also find this for a deterministic policy? #pause

$ nabla_(#pin(1)theta_pi#pin(2)) bb(E)[cal(G)(bold(tau)) | s_0; #pin(3)theta_pi#pin(4)] => nabla_(#pin(5)theta_mu#pin(6)) bb(E)[cal(G)(bold(tau)) | s_0; #pin(7)theta_mu#pin(8)] $ #pause

#pinit-highlight(1,2)
#pinit-highlight(3,4)
#pinit-highlight(5,6, fill: blue.transparentize(85%))
#pinit-highlight(7,8, fill: blue.transparentize(85%))

==

The expected return with a *stochastic* policy #pause

$ 
bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; #pin(1)theta_pi#pin(2)) \ #pause

#pinit-highlight(1,2) #pause

Pr (s_(n+1) | s_0; #pin(3)theta_pi#pin(4)) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( #pin(7)sum_(a_t in A)#pin(8) Tr(s_(t+1) | s_t, a_t) dot #pin(5)pi (a_t | s_t; theta_pi)#pin(6) ) $ #pause

#pinit-highlight(3,4) #pause
#pinit-highlight(5,6) 
#pinit-highlight(7,8) #pause 

The state distribution with a *deterministic* policy #pause

$ Pr (s_(n+1) | s_0; theta_mu) = sum_(s_1, dots, s_n in S) product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, theta_mu)) $ 

==

Let us continue to derive policy gradient with a *deterministic* policy $mu$ #pause

$ 
bb(E)[cal(G)(bold(tau)) | s_0; theta_mu] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (s_(n + 1) | s_0; theta_mu) \
 
Pr (s_(n+1) | s_0; theta_mu) = sum_(s_1, dots, s_n in S) product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, theta_mu)) $ #pause

Plug state distribution into expected return #pause

$
bb(E)[cal(G)(bold(tau)) | s_0; theta_mu] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) sum_(s_1, dots, s_n in S) product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, theta_mu)) 
$

==
$
bb(E)[cal(G)(bold(tau)) | s_0; theta_mu] = sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) sum_(s_1, dots, s_n in S) product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, theta_mu)) 
$ #pause

Take gradient of both sides #pause

$
nabla_theta_mu bb(E)[cal(G)(bold(tau)) | s_0; theta_mu] \ = nabla_theta_mu [ sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) sum_(s_1, dots, s_n in S) product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, theta_mu)) ]
$

==
$
nabla_theta_mu bb(E)[cal(G)(bold(tau)) | s_0; theta_mu] \ = nabla_theta_mu [ sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) sum_(s_1, dots, s_n in S) product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, theta_mu)) ]
$ #pause

Gradient of sum is sum of gradient, move the gradient inside the sums #pause

$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) sum_(s_1, dots, s_n in S) nabla_theta_mu [ product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, theta_mu)) ]
$

==

$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) sum_(s_1, dots, s_n in S) nabla_theta_mu [ product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, theta_mu)) ]
$ #pause

#side-by-side[Recall the log trick #pause][
$ nabla_x f(x)  = f(x) nabla_x log f(x) $ 
] #pause

Apply log trick to product terms #pause

$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) sum_(s_1, dots, s_n in S) \ product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, theta_mu)) nabla_theta_mu [ log(product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, theta_mu))) ]
$

== 
#text(size: 24pt)[
$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) sum_(s_1, dots, s_n in S) product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, theta_mu)) \ nabla_theta_mu [ log(product_(t=0)^n  Tr(s_(t+1) | s_t, mu(s_t, theta_mu))) ]
$ #pause

Log of products is sum of logs #pause

$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) sum_(s_1, dots, s_n in S) product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, theta_mu)) \ nabla_theta_mu [ sum_(t=0)^n log Tr(s_(t+1) | s_t, mu(s_t, theta_mu)) ]
$
]

==

$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) sum_(s_1, dots, s_n in S) product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, theta_mu)) \ nabla_theta_mu [ sum_(t=0)^n log Tr(s_(t+1) | s_t, mu(s_t, theta_mu)) ]
$ #pause

Move the gradient inside sum #pause

$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) sum_(s_1, dots, s_n in S) product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, theta_mu)) \ sum_(t=0)^n nabla_theta_mu log Tr(s_(t+1) | s_t, mu(s_t, theta_mu)) 
$

==

$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) sum_(s_1, dots, s_n in S) product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, theta_mu)) \ sum_(t=0)^n nabla_theta_mu log Tr(s_(t+1) | s_t, mu(s_t, theta_mu)) 
$ #pause

#side-by-side[Use the chain rule][$ nabla_x f(g(x)) = nabla_(g) [f(g(x))] nabla_x g(x)$] #pause

$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot sum_(s_1, dots, s_n in S) product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, theta_mu)) \ sum_(t=0)^n nabla_(mu)[ log Tr(s_(t+1) | s_t, mu(s_t, theta_mu))] dot nabla_theta_mu mu(s_t, theta_mu)
$

==
$
= sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot sum_(s_1, dots, s_n in S) product_(t=0)^n Tr(s_(t+1) | s_t, mu(s_t, theta_mu)) \ sum_(t=0)^n nabla_(mu)[ log Tr(s_(t+1) | s_t, mu(s_t, theta_mu))] dot nabla_theta_mu mu(s_t, theta_mu)
$ #pause

*Question:* Any problems? #pause

We must know $gradient Tr$ to find the deterministic policy gradient #pause

In model-free RL, we do not know $gradient Tr$ -- it might not be differentiable! #pause

Stochastic policy gradient is very special -- we do not need $nabla Tr$ #pause

Let me explain what I mean

==
With deterministic policy, $mu$ inside $Tr$ means chain rule #pause

$ sum_(t=0)^n nabla_theta_mu log Tr(s_(t+1) | s_t, mu(s_t, theta_mu)) 
$ #pause

With stochastic policy, $pi$ *not inside* $Tr$ (product rule) #pause

$ sum_(t=0)^n sum_(a_t in A) nabla_theta_pi [ Tr(s_(t+1) | s_t, a_t) dot log pi (a_t | s_t; theta_pi)] 
$ #pause

We use stochastic policies in RL because of this

= Deep Deterministic Policy Gradient
==
#side-by-side[
    $ 
    nabla_(theta_mu) bb(E)[cal(G)(bold(tau)) | s_0; theta_mu]
    $  #pause
][
    $
    theta_(pi, i + 1) = theta_(pi, i) + alpha dot nabla_(theta_mu) bb(E)[cal(G)(bold(tau)) | s_0; theta_mu]
    $ #pause
]

We failed -- a deterministic policy gradient does not seem to work #pause

Can we try and optimize something else? #pause

*Question:* Could we replace $nabla_theta_mu bb(E)[cal(G)(bold(tau)) | s_0; theta_mu]$ with something else? #pause

#side-by-side[
$ nabla_(theta_mu) V(s_0, theta_mu) 
$ #pause

][
$ nabla_(theta_mu) Q(s_0, a_0, theta_mu) $ #pause
]

Let us try to derive deterministic policy gradient again #pause

This time, take gradient of $V$ instead of gradient of $bb(E)[cal(G)(bold(tau)) | s_0; theta_mu]$

==
$ V(s_0, theta_mu) = bb(E)[cal(R)(s_1) | s_0; theta_mu] + gamma V(s_0, theta_mu) $ #pause

Rewrite $V$ in terms of $Q$ #pause

$ V(s_0, theta_mu) = Q(s_0, a, theta_mu); quad a = mu(s_1, theta_mu) $ #pause

Plug in $mu$ for $a$ #pause

$ V(s_0, theta_mu) = Q(s_0, mu(s_0, theta_mu), theta_mu) $ #pause

Take the gradient of both sides #pause

$ nabla_theta_mu V(s_0, a_0, theta_mu) = nabla_theta_mu  Q(s_0, mu(s_0, theta_mu), theta_mu) $

==
$ nabla_theta_mu V(s_0, theta_mu) = nabla_theta_mu Q(s_0, mu(s_0, theta_mu), theta_mu) $ 

#side-by-side[Use the chain rule][$ nabla_x f(g(x)) = nabla_(g) [f(g(x))] nabla_x g(x)$] #pause

$ nabla_theta_mu V(s_0, theta_mu) = nabla_mu Q(s_0, mu(s_0, theta_mu), theta_mu) dot nabla_theta_mu mu(s_0, theta_mu) $ 

==

#v(1em)

$ nabla_theta_mu V(s_0, theta_mu) = #pin(1)nabla_mu Q(s_1, mu(s_1, theta_mu), theta_mu)#pin(2) dot #pin(3)nabla_theta_mu mu(s_1, theta_mu)#pin(4) $ #pause

#v(1em)

Let us inspect these terms more closely #pause

#pinit-highlight-equation-from((3,4), (3,3), fill: red, pos: top, height: 1.2em)[How $theta_mu$ changes $a$] #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: blue, pos: bottom, height: 1.2em)[How $a$ changes $Q$] #pause

The second term is easy to compute, gradient of deterministic policy #pause

Analytical solution for the first term is difficult (recursive definition) #pause

But what if $Q$ is a neural network? #pause

We can backpropagate through $Q$ without worrying about recursion

==
#v(1em)

$ nabla_theta_mu V(s_0, theta_mu) = #pin(1)nabla_mu Q(s_1, mu(s_1, theta_mu), theta_mu)#pin(2) dot #pin(3)nabla_theta_mu mu(s_1, theta_mu)#pin(4) $

#v(1em)

#pinit-highlight-equation-from((3,4), (3,3), fill: red, pos: top, height: 1.2em)[How $theta_mu$ changes $a$] 

#pinit-highlight-equation-from((1,2), (1,2), fill: blue, pos: bottom, height: 1.2em)[How $a$ changes $Q$] #pause

Writing the code makes it look easy #pause

```python
def V(s, Q_nn, mu_nn):
    a = mu_nn(s)
    return Q_nn(s, a)

# Learn the policy that maximizes V
# Make sure to differentiate w.r.t policy parameters!
J = grad(V, argnums=2)(states, Q_nn, mu_nn)
mu_nn = optimizer.update(mu_nn, J)
```
==
This assumes we know the $Q$ function for $theta_mu$ #pause

We can learn $Q$ for any policy (before we focused on greedy) #pause

$ Q(s_0, a_0, theta_mu, theta_Q) = bb(E)[cal(R)(s_1) | s_0, a_0] + gamma Q(s_1, mu(s_1, theta_mu), theta_mu, theta_Q) $ #pause

```python
def V(s, Q_nn, mu_nn):
    a = mu_nn(s)
    return Q_nn(s, a)
# Before, we learned policy params to maximize Q
# Now, we learn params of Q following policy (argnums=2)
J = grad(V, argnums=1)(states, Q_nn, mu_nn)
Q_nn = optimizer.update(Q_nn, J)
```
==
*Definition:* Deep Deterministic Policy Gradient (DDPG) decomposes $V$ into a deterministic policy $mu$ and $Q$, learning them jointly #pause

*Step 1:* Learn a $Q$ function for $theta_mu$ #pause

$ theta_(Q, i+1) = argmin_(theta_(Q, i)) \ (Q(s_0, a_0, theta_(mu, i), theta_(Q, i)) - (hat(bb(E))[cal(R)(s_1) | s_0, a_0] + gamma Q(s_1, mu(s_1, theta_(mu, i)), theta_(mu, i), theta_(Q, i)))) $ #pause

*Step 2:* Learn  $theta_mu$ that maximizes $Q$ #pause

$ theta_(mu, i+1) = theta_(mu, i) + alpha dot Q(s_0, mu(s_0, theta_mu), theta_(mu, i), theta_(Q, i+1)) $ #pause

Repeat until convergence, $theta_(mu, i+1)=theta_(mu, i), quad theta_(Q, i+1)=theta_(Q, i)$

==
$ theta_(Q, i+1) = argmin_(theta_(Q, i)) \ (Q(s_0, a_0, theta_(mu, i), theta_(Q, i)) - (hat(bb(E))[cal(R)(s_1) | s_0, a_0] + gamma Q(s_1, mu(s_1, theta_(mu, i)), theta_(mu, i), theta_(Q, i)))) \

theta_(mu, i+1) = theta_(mu, i) + alpha dot Q(s_0, mu(s_0, theta_mu), theta_(mu, i), theta_(Q, i+1)) $ #pause

*Question:* Is DDPG on-policy or off-policy? #pause

*Answer:* Depends on how we train $Q$: #pause
- TD $Q$ is off-policy #pause
- MC $Q$ is on-policy #pause

Almost *all* good off-policy actor-critic algorithms are based on DDPG

==

*Summary:* #pause
- Wanted to extend Q learning to continuous action spaces #pause
    - Simple greedy policy does not work! #pause
- Introduced learned deterministic policy $a = mu(s, theta_mu)$ #pause
- Failed to find deterministic policy gradient $nabla_theta_mu bb(E)[cal(G)(bold(tau)) | s_0; theta_mu]$ #pause
    - Must know $nabla Tr$ #pause
- Try gradient ascent on $nabla_theta_mu V$ instead of $nabla_theta_mu bb(E)[cal(G)(bold(tau)) | s_0; theta_mu]$
    - Trick: Factor $V$ in terms of $Q, mu$
    - Iterative optimization of $theta_Q$ and $theta_mu$ #pause

==

Another way to think of DDPG: #pause

$ max_(theta_mu) Q(s, mu(s, theta_mu), theta_mu) approx max_(a in A) Q(s, a, theta_mu) $ #pause

$mu$ is a continuous relaxation of the greedy policy #pause

Because $mu$ is a neural network, it can generalize to continuous $s, a$


==
One small problem: deterministic policy means no exploration! #pause

We must visit other states/actions to find optimal $theta_Q, theta_mu$ #pause

With Q learning, we had epsilon greedy policy #pause

$ pi (a | s; theta_pi) =  cases( 
  1 - epsilon & : a = argmax_(a in A) Q(s, a, theta_pi), 
  epsilon & : a = "uniform"(A)
) $ #pause

*Question:* What about DDPG exploration? HINT: Continuous actions #pause

$ pi (a | s; theta_mu) =  cases( 
  1 - epsilon & : a = Q(s, mu(s, theta_mu), theta_mu), 
  epsilon & : a = "uniform"(A)
) $ 

==

In practice, we can do something a little smarter #pause

Uniform actions cover the full action space, but can take a while to learn #pause

We can add noise to a good action instead of completely random actions #pause

$ pi (a | s; theta_mu) = mu(s, theta_mu) + "Normal"(0, sigma) $ #pause

This tends to learn more quickly #pause

Normal noise (infinite support) guarantees full action space coverage

= Coding

==
Like policy gradient, the math and code is different #pause
- Construct $mu$ and $Q$ networks #pause
- Sample actions #pause
    - Be careful that random actions are in action space! #pause
    - $A = [0, 2 pi]$, then $a = 2.1 pi$ not ok #pause
- Iteratively train $theta_Q, theta_mu$

==
First, construct deterministic policy #pause
```python
mu = Sequential([
    Linear(state_size, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, action_dims),
])
``` #pause
Here, `action_dims` correspond to the number of continuous dimensions #pause

BenBen: $A = [0, 2 pi]^12$, so `action_dims=12`
==
Now, we need to make sure actions do not leave action space! #pause
- BenBen: $A in [0, 2 pi]^12$, `lower=[0, 0, ...]`, `upper=[2pi, 2pi, ...]` #pause

Squash actions to limits using $tanh$ #pause
- Can also use `clip(action, lower, upper)`, but this zeros gradients #pause
- Agent can get stuck taking limiting actions (e.g., -0.01 or $2.1 pi$) #pause

```python
def bound_action(action, lower, upper): 
    return 0.5 * (upper + lower) + 0.5 * (upper - lower) 
        * tanh(action)
``` #pause

```python
def sample_action(mu, state, A_bounds, std):
    action = mu(state)
    noisy_action = action + normal(0, std) # Explore
    return bound_action(noisy_action, *A_bounds)

```

==
Now construct $Q$ #pause

```python
Q = Sequential([
    # Different from DQN network
    # Input action and state together
    Lambda(lambda s, a: concatenate(s, a)),
    Linear(state_size + action_dims, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, hidden_size),
    Lambda(leaky_relu),
    Linear(hidden_size, 1), # Single value for Q(s, a)
])
```

==
```python
while not terminated:
    # Exploration: make sure actions within action space!
    action = sample_action(mu, state, bounds, std)
    transition = env.step(action)
    replay_buffer.append(transition)
    data = replay_buffer.sample()
    # Theta_pi params are in mu neural network
    # Argnums tells us differentiation variable
    J_Q = grad(Q_loss, argnums=0)(theta_Q, theta_T, mu, data)
    theta_Q = apply_updates(J_Q, ...)
    J_mu = grad(mu_loss, argnums=0)(mu, theta_Q, data)
    mu = apply_updates(J_mu, ...)
    if step % 200 == 0: # Target network necessary
        theta_T = theta_Q
```

==
```python
def Q_loss(theta_Q, theta_T, theta_pi, data):
    Qnet = combine(Q, theta_Q)
    Tnet = combine(Q, theta_T) # Target network
    # Predict Q values for action we took
    prediction = vmap(Qnet)(data.state, data.action)
    # Now compute labels using TD error
    next_action = vmap(mu)(data.next_state)
    # NOTE: No max! Mu approximates argmax
    next_Q = vmap(Tnet)(data.next_state, next_action)
    label = data.reward + gamma * data.done * next_Q
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
Many algorithms add improvements to DDPG #pause

The most popular algorithm based on DDPG is *Soft Actor Critic* (SAC) #pause

SAC is arguably the "best" model-free algorithm #pause

The motivation for SAC comes from *max-entropy RL* #pause

We will very briefly cover max-entropy RL #pause

First, let us introduce entropy

==
Entropy measures the uncertainty of a distribution #pause

$ H(pi (a | s; theta_pi)) $ #pause

#side-by-side[
    #high_ent #pause
][
    #low_ent #pause
]

*Question:* Which policy has higher entropy? #pause

Left policy, more uncertain/random

==
In maximum entropy RL, we change the objective #pause

$ argmax_(theta_pi) bb(E)[ cal(G)(bold(tau)) | s_0; theta_pi] = argmax_(theta_pi) sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; theta_pi] $ #pause

We consider the entropy in the return #pause

$ argmax_(theta_pi) bb(E)[ cal(H)(bold(tau)) | s_0; theta_pi] = \ argmax_(theta_pi) sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; theta_pi] + gamma^t H(pi (a | s_t; theta_pi)) $ #pause

We want a policy that is both random and maximizes the return

==
$ argmax_(theta_pi) bb(E)[ cal(H)(bold(tau)) | s_0; theta_pi] = \ argmax_(theta_pi) sum_(t=0)^oo gamma^t (bb(E)[cal(R)(s_(t+1)) | s_0; theta_pi] + H(pi (dot | s_t; theta_pi))) $ #pause

*Question:* Why do want policy entropy? Lowers the return

*Answer:* No good theoretical reason, helpful in practice #pause
- There are theoretical reasons, but they are not very good #pause
- Better exploration during training #pause
- More stable training (explain further in offline RL)

==
DDPG is based on a deterministic policy $mu$ #pause

A deterministic policy $mu$ has no entropy (it is not random) #pause

But for SAC, I talk about $pi$ and policy entropy #pause

How is this possible? #pause

Consider a function $f: S times Theta times bb(R) |-> A$ #pause

$ a = f(s, theta_mu, eta) = mu(s, theta_mu) + eta
$ 

==
$ a = f(s, theta_mu, eta) = mu(s, theta_mu) + eta
$ #pause

If $eta tilde "Normal"(0, 1)$ our function $f$ is still deterministic #pause

We call this the *reparameterization trick*, used in variational autoencoders (VAE) #pause

Mathematically, this is a "deterministic" policy #pause

$ bb(E)[cal(G)(bold(tau)) | s_0, eta_0, eta_1, dots; theta_mu] $ 

==
$ a = f(s, theta_mu, eta) = mu(s, theta_mu) + eta \
bb(E)[cal(G)(bold(tau)) | s_0, eta_0, eta_1, dots; theta_mu] $ 

In practice, $f$ behaves just like a stochastic policy $pi$ #pause

Gradient descent will learn $theta_mu$ that generalize over $eta$ #pause

We abuse notation and write $f$ as a random policy #pause

$ pi (a | s; theta_pi) $ #pause

But $f$ is deterministic when we know $eta$

==
What happens when we combine max entropy RL #pause

$ argmax_(theta_pi) bb(E)[ cal(H)(bold(tau)) | s_0; theta_pi] = \ argmax_(theta_pi) sum_(t=0)^oo gamma^t bb(E)[cal(R)(s_(t+1)) | s_0; theta_pi] + gamma^t H(pi (a | s_t; theta_pi)) $ #pause


With the reparameterization trick? #pause

$ a = mu(s, theta_mu) + eta tilde.equiv 
a tilde pi (dot | s; theta_pi)
$ #pause

We get SAC!

==
*Definition:* Soft Actor Critic (SAC) adds a max entropy objective and stochastic policy to DDPG #pause

*Step 1:* Learn a $Q$ function for max entropy policy (Q learning) #pause

$ theta_(Q, i+1) = argmin_(theta_(Q, i)) (Q(s_0, a_0, theta_(pi, i), theta_(Q, i)) - y)^2 $ #pause

$ y = #pin(5)hat(bb(E))[cal(R)(s_1) | s_0, a_0]#pin(6) + #pin(3)H(pi (a | s_0; theta_mu))#pin(4) + gamma Q(s_1, #pin(1)mu(s_1, theta_mu, eta)#pin(2), theta_(pi, i), theta_(Q, i)) #pause $ #pause

#pinit-highlight-equation-from((5,6), (5,6), fill: orange, pos: bottom, height: 1.2em)[Reward] #pause

#pinit-highlight-equation-from((3,4), (3,4), fill: red, pos: bottom, height: 1.2em)[Entropy bonus] #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: blue, pos: bottom, height: 1.2em)[Deterministic $a$] #pause

#v(1.5em)

where $eta$ is randomly sampled

==

*Step 2:* Learn a $pi$ that maximizes $Q$ (policy gradient) #pause

#v(1.5em)
$ theta_(pi, i+1) = theta_(pi, i) + alpha dot underbrace(Q(s_0, #pin(1)mu(s_0, theta_mu, eta)#pin(2), theta_pi, theta_Q), "Replaces" bb(E)[cal(G)(bold(tau)) | s_0; theta_mu]) $  #pause

#pinit-highlight-equation-from((1,2), (1,2), fill: blue, pos: top, height: 1.2em)[Deterministic $a$] #pause


where $eta$ is randomly sampled #pause

Repeat until convergence, $theta_(mu, i+1)=theta_(mu, i), quad theta_(Q, i+1)=theta_(Q, i)$
==
Like PPO, there are many variants of SAC #pause
    - Learn separate value and Q functions #pause
    - Double Q function #pause
    - Lagrangian entropy adjustment #pause
    - Reduced variance gradients #pause

Like PPO, SAC is complicated -- uses many "implementation tricks" #pause
- Often not documented
- CleanRL describes modern SAC, using tricks from 5+ papers
- https://docs.cleanrl.dev/rl-algorithms/sac/#implementation-details_1

Coding SAC could take an entire lecture, read CleanRL

==
#side-by-side[
    DDPG $approx$ A2C #pause

    Introduces the concept, simple #pause
][
    SAC $approx$ PPO #pause

    Improves the concept, complex #pause
]

I suggest you try DDPG before SAC #pause
- DDPG is much easier to implement #pause
- Fewer hyperparameters #pause
- Tuned DDPG can likely outperform untuned SAC 

==
What algorithm is best in 2025? #pause

For discrete actions (Atari), DQN variants still perform best #pause

For continuous actions (MuJoCo), SAC performs best #pause

PPO is less sensitive to hyperparameters than SAC/DQN #pause
- Noobs like PPO, they cannot tune hyperparameters #pause
- Often performs worse than tuned DQN/SAC #pause

Tuned DDPG/A2C perform 95% as good as tuned SAC/PPO #pause
- Much easier to debug

= Final Project Tips
==
Log and plot EVERYTHING #pause
    - Losses, mean advantage, mean Q, policy entropy, etc
        - Use these to help debug and tune hyperparameters
        - E.g., exploding losses, decrease learning rate
        - E.g., Q values too large? Increase time between target net update #pause

If you get stuck, visualize your policy #pause
- Record some episodes (videos/frames/etc) #pause
- Watch the policy, what did it learn to do? #pause
    - Think about why it learned to do this (exploiting bugs in MDP) 

==

Why does Steven spend so much time on theory instead of coding? #pause

In supervised learning, follow MNIST tutorial and everything works #pause

This is *NOT* the case in RL #pause

In RL, your code never works on the first try #pause

Even if it is correct, you need to play with hyperparameters #pause

Theory is absolutely necessary to understand *why* your policy fails, and *how* to fix it #pause

You must use your brain to be successful!


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
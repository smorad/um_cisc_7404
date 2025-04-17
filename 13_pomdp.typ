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
    title: [Partial Observability],
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

= Quiz

==
I caught and reported some cheaters to the department for quiz 2 #pause
- Cheating will result in 0 for *entire course* #pause

It is not worth risking a 0 in the course for a quiz #pause
- 10% or less of your course grade #pause

Consider the expected return for failing one exam or the course #pause

$ &bb(E)[cal(G) | s_0="No study", a_0="Cheat"] approx 40% \

&bb(E)[cal(G) | s_0="No study", a_0="No cheat"] approx "current_grade" - 5% $ #pause

I cannot catch all cheaters, but is it worth the gamble?


==
- After all students put away their computer/notes/phone I will hand out exams #pause
- If you have computer/notes/phone out after this point, it counts as cheating #pause
- I will hand out exams face down, do not turn them over until I say so #pause
- After turning them over, I will briefly explain each question #pause
- After my explanation, you will have 75 minutes to complete the exam #pause
- After you are done, give me your exam and go relax outside, we resume class at 8:30 #pause

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
Still one quiz 2 without name #pause

If you took quiz 2 and have 0 score, it may be your quiz #pause

Come see me after class
==
Homework 2 grades released #pause
- Average score 80/100 #pause
- Multimodal, modes at 100, 80, 40 #pause
- Changing evaluation random seed until success, not ok #pause
- Difficult assignment, because RL is difficult! #pause
    - CartPole/LunarLander is MNIST equivalent for RL #pause
    - Today, still lots of trial and error, tuning, etc #pause
    - Maybe one day it will be easy like supervised learning

==
Current mean course grade is 88% #pause
    - Mean score will decrease after quiz 3 #pause
    - Mean score will decrease after finalizing participation #pause
    - Hopefully, mean score will increase after final project #pause

If mean course grade drops below 80%, I will normalize upward 
==
Almost done with the course! #pause

Does the course differ from your expectations? #pause

If you understand the material, you are part of a very small group #pause
- $< 5,000$ people in the world truly understand RL #pause
    - Many use RL, few understand it #pause
        - MDP, policy gradient mechanism, $gamma$ meaning, PPO vs DDPG, etc #pause
        - To really succeed with RL, you must understand it (not like SL) #pause
- You are part of this elite group!

==
With these skills, you can do what others cannot #pause

You have the tools to make *better decisions* than most humans #pause

Humans can be: #pause
    - Biased (Incorrect modeling of $Tr$) #pause
    - Irrational (Making decisions while ignoring $cal(G)(bold(tau))$) #pause
    - Shortsighted ($gamma$ too small) #pause
    - Greedy ($cal(R)(s)$ that does not consider other humans) #pause
    - Evil (Positive $cal(R)(s)$ for hurting other humans) #pause

I hope you can create agents that do not share our flaws #pause
    - Please use your skills to improve the world


= Are MDPs Enough?
==
Problems with well-defined losses and gradients can use supervised/unsupervised learning
- Generating or classifying cat pictures

RL is the most practical method for optimization of *arbitrary* objectives
- Reduce world poverty

Fewer "rules" for RL problems than supervised learning
- Only rule: problem must be MDP

Today, we will make RL even more flexible
- Remove almost all rules

==
Throughout the course, I talk about useful applications of RL #pause
- Medicine #pause
- Material science #pause
- Robotics #pause
- Economics #pause

Yet many RL successes focus on video games or board games #pause
- AlphaStar (StarCraft II) #pause
- AlphaGo (Go) #pause
- OpenAI Five (DoTA II) #pause
- DQN (Atari, PyBoyEnv) #pause
- PPO/SAC (MuJoCo)

==
We could be solving real problems, but we are not #pause

*Question:* Why does RL research focus on solving video games? #pause

*Answer?:* RL researchers are nerd gamers and only care about games

==
*Question:* Why does RL research focus on solving video games? 

*Real Answer:* #pause
- RL requires lots of data, video games can generate data for free #pause
    - Robots/medicine/etc require physical work to collect each $s, a, r, d$ #pause
- Video games are more reproducible #pause
    - Same sequence of actions results in same outcome #pause
        - E.g., material science, labs perform actions differently #pause
            - Different centrifuge, reagent purity, etc #pause
            - Makes it hard to rely on other labs results
==
There is one more reason, one I want to cover today #pause
- Video games are almost always MDPs #pause

Remember, RL can *only* solve MDPs #pause

If it not an MDP, we cannot solve it with RL

==

Recall the definition of MDP #pause

*Definition:* A Markov decision process (MDP) is a tuple $(S, A, T, R, gamma)$ #pause
- $S$ is the state space #pause
- $A$ is the action space #pause
- $Tr: S times A |-> Delta S$ is the state transition function #pause
- $cal(R): S |-> bb(R)$ is the reward function #pause
- $gamma in [0, 1]$ is the discount factor #pause

*Question:* Why do we call it *Markov* decision process? #pause

*Answer:* Markov state transition function

==
An MDP must have a Markov state transition function #pause

*Question:* Does anyone remember mathematical definition for this? #pause

The next state only depends on the current state and action 

$ Tr(s_(t+1) | s_(t), a_t, s_(t-1), a_(t-1), dots, s_0, a_0) = Tr(s_(t+1) | s_(t), a_t) $ #pause

Another way of saying this: #pause
- Everything our agent saw in the past is *completely useless* #pause
- Provides zero value for the current decision #pause

*Question:* Do you think this is a strong constraint?

==

*Example:* Simple MDP with sensor noise #pause

$ S = {0, 1}, A = {a}, cal(R)(s) = 0 $ #pause

We sense a small amount of noise $epsilon$ in each state #pause

#side-by-side[
    $ s = 0 + epsilon $ #pause
][

    $ s = 1 + epsilon $ #pause
][
    $ epsilon tilde "Normal"(0, 1) $ #pause
]

$ Tr(s_2 | s_1, a_1) = Tr(s_2 | s_1, a_1, s_0, a_0) $ #pause

$ Tr(s_2=1 | 0.91, a) eq.quest (s_2=1 | 0.91, a, 0.99, a) $ #pause

*Question:* Do you think the probability distribution changes? #pause

*Answer:* Yes, two states near 1 make it more likely we are in $s=1$

==
This is even more clear with high-noise samples #pause

$ S = {0, 1}, A = {a}, cal(R)(s) = 0 $

We sense a small amount of noise $epsilon$ in each state

#side-by-side[
    $ s = 0 + epsilon $
][

    $ s = 1 + epsilon $ #pause
][
    $ epsilon tilde "Normal"(0, 3) $
] #pause


$ Tr(s_2 | s_1, a_1) = Tr(s_2 | s_1, a_1, s_0, a_0) $ #pause

$ underbrace(Tr(s_2=1 | 0.68, a), "Likely" s_2=1) eq.quest underbrace(Tr(s_2=1 | 0.68, a, 0.01, a), "Likely" s_2=0) $ #pause

If we cannot determine the state, RL does not work

==

*Question:* Can we have noise-free state in the real world? #pause

*Answer:* No. Heisenberg uncertainty principle says noise-free measurement is impossible #pause

*Question:* Noise-free state in virtual worlds (video games)? #pause

*Answer:* Yes, $Tr$ does not follow real world physics 

==
#side-by-side[
    #cimage("fig/13/hud.png")
][
    Wing Commander: shoot aliens #pause
    - Position of alien (cockpit/radar) #pause
    - Our heading and velocity #pause
    - Our shields and hull #pause
    - Target shields and hull #pause
]

*Question:* Is there noise in these measurements (state)? #pause *Answer:* No #pause


*Question:* Do you think Wing Commander is an MDP? #pause *Answer:* Yes

==
Let us train an autonomous dentist #pause

#side-by-side[
    $s_0$: Patient arrives at dentist #pause

    $a_0$: *Dentist:* How often do you brush your teeth? #pause

    $s_1$: *Patient:* Once per week #pause

    $a_1$: *Dentist:* Ok, I must check for cavities, and possibly drill your teeth #pause

    $s_2$: *Patient:* Actually, I brush my teeth twice per day #pause

    $s_3 in {"Checking for cavities", "Send patient home"}$ #pause
]

*Question:* Is this an MDP? Will $s_1$ influence $s_3$? #pause *Answer:* No


==
The Markov property is very constraining #pause
- Prevents applying RL to many real problems #pause
- Instead, we focus on Markov video games #pause

Problems with hidden information or noisy sensors are not MDPs #pause
    - No lie detector for humans #pause
    - Obscured cameras #pause
    - Sensor noise #pause

Any problem where prior states contain useful information #pause
- Playing two games against the same chess player #pause
    - Chess player has specific behaviors #pause

MDP traps RL in video games

= Partial Observability
==
So the MDP is not a realistic model for most problems #pause

The core issue, is noise or ambiguity in the state #pause
- Unrealistic that all prior states contain zero useful information #pause

Can we formulate a new decision process that accounts for this noise/ambiguity? #pause

The key idea is to separate *observations* from state #pause
- Observations are what we observe/see #pause
- The state is the hidden/unknown #pause

We can use observations to infer/guess the state

==
*Definition:* A *Partially Observable* MDP (POMDP) represents a Markov process where the state is hidden #pause

$ ( (S, A, Tr, cal(R), gamma), frak(O), O) $ #pause

#side-by-side[
    $frak(O)$: observation space
][
    $O$: observation function
] 

Cannot directly observe state $s in S$, only observation $o in frak(O)$ #pause

#side-by-side[
    $ O: S |-> Delta frak(O) $ #pause
][
    $o_(t+1) tilde O(dot | s_(t+1)) $ #pause
][
    $ o_(t+1) tilde Pr(dot | s_(t+1)) $ #pause
]

//The Markov state transition function is still neccessary

$ Tr(s_(t+1) | s_(t), a_t, s_(t-1), a_(t-1), dots, s_0, a_0) = Tr(s_(t+1) | s_(t), a_t) $ #pause

$ Pr(o_(t+1) | o_(t), a_t, o_(t-1), a_(t-1), dots, o_0, a_0) != Pr(o_(t+1) | o_(t), a_t) $
==
With POMDPs, a $Tr, S$ still governs the system

However, we do not know $Tr$ or $S$, just $Omega$!

*Example:* Can model the stock market as a POMDP
- Complex and unknown $S, Tr$
    - $S$: Stock holdings of millions of people, banks, global events, etc 
    - $Tr$: Cause and effect of banking systems, markets, emotions, etc 

- Stock price is an observable function of a latent state 
    - $o_t tilde O(dot | s_t)$

POMDPs can model almost any type of decision making problem

==
POMDPs seem very flexible, but how are they useful?

All RL algorithms rely on MDPs, not POMDPs

Did you spend 12 weeks learning a pointless skill?

You are in luck, my research focus is on RL for POMDPs! 
- _Deep Memory Models and Efficient Reinforcement Learning under Partial Observability_

So how can we use RL on POMDPs?

==
$ Tr(s_(t+1) | s_(t), a_t, s_(t-1), a_(t-1), dots, s_0, a_0) = Tr(s_(t+1) | s_(t), a_t) $

What if we treat the trajectory as a Markov state?

$ s_t = mat(o_t, emptyset; o_(t-1), a_(t-1); dots.v, dots.v; o_0, a_0) $

==

#grid(align: horizon, columns: (0.7fr, 0.3fr), $ Tr(s_(t+1) | s_(t), a_t, dots, s_0, a_0) = Tr(s_(t+1) | s_(t), a_t) $,
$ s_t = mat(o_t, a_t; o_(t-1), a_(t-1); dots.v, dots.v; o_0, a_0) $ 
)

Plug into equation

$ Tr(s_(t+1) mid(|) 
    mat(o_t, emptyset; o_(t-1), a_(t-1); dots.v, dots.v; o_0, a_0), 
    a_t,
    mat(o_(t-1), emptyset; o_(t-2), a_(t-2); dots.v, dots.v; o_0, a_0), 
    a_(t-1),
    dots
    mat(o_0, emptyset), a_0
) $

==

$ Tr(s_(t+1) mid(|) 
    mat(o_t, emptyset; o_(t-1), a_(t-1); dots.v, dots.v; o_0, a_0), 
    a_t,
    mat(o_(t-1), emptyset; o_(t-2), a_(t-2); dots.v, dots.v; o_0, a_0), 
    a_(t-1),
    dots
    mat(o_0, emptyset), a_0
) \ 
= Tr(s_(t+1) mid(|) 
    mat(o_t, emptyset; o_(t-1), a_(t-1); dots.v, dots.v; o_0, a_0), a_t
) $

*Question:* Does this equality hold?

*Answer:* Yes, because $s_t$ contains all other $s_(t-1), s_(t-2), dots$


/*
==

$ s_t = mat(o_t, emptyset; o_(t-1), a_(t-1); dots.v, dots.v; o_0, a_0) $

This is guaranteed to be Markov!

However, considering the entire past seems like a bad solution

*Question:* Is there is a better solution?

*Answer:* No! This is a situation where we only have bad solutions

We must always reason over prior observations and actions
*/
==
$ s_t = mat(o_t, emptyset; o_(t-1), a_(t-1); dots.v, dots.v; o_0, a_0) $

Now we have a state, can treat POMDP like an MDP

Can use this state in policy gradient, Q learning, etc

Still guaranteed to learn optimal policy $max_(theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi]$

*Note:* Optimal policy is defined by sensors
- Navigation policy for a "blind" robot may not be great
- But we can learn the best policy possible, given the limitation

==
$ s_t = mat(o_t, emptyset; o_(t-1), a_(t-1); dots.v, dots.v; o_0, a_0) $

*Question:* Any problems with this state?

*Answer:* It can become very large!

*Example:* $Omega = [0,255]^(1024 times 768 times 3)$ 

60 images per second over one hour, then state is 500 GB

Next hour, state becomes 1 TB -- not scalable!

==
$ s_t = mat(o_t, emptyset; o_(t-1), a_(t-1); dots.v, dots.v; o_0, a_0) $

Must consider all prior observations and actions, but can we do better?

$ s_t = f(mat(o_t, emptyset; o_(t-1), a_(t-1); dots.v, dots.v; o_0, a_0)) $

Use a function $f$ to extract useful/meaningful information from the past

==
$ s_t = f(mat(o_t, emptyset; o_(t-1), a_(t-1); dots.v, dots.v; o_0, a_0)) $

Use a function $f$ to extract useful/meaningful information from the past

*Question:* Is there a similar mechanism in humans?

*Answer:* Memory! 

In humans, memory is a function of all past sensory information

Function $f$ *recalls* necessary information for decision making

==
$ s_t = f(mat(o_t, emptyset; o_(t-1), a_(t-1); dots.v, dots.v; o_0, a_0)) $

How can we implement $f$? Functions with a dynamic number of inputs
- Functions that take a dynamic number of inputs

Recurrent neural network (LSTM): $quad s_t, h_t = "GRU"([o_t, a_(t-1)], h_(t-1), theta_f)$
    
Attention (Transformer): $quad s_t = "attn"([o_t, a_(t-1)], [o_(t-1), a_(t-2)], dots, theta_f)$

Bayesian methods (inference): $quad Pr (s_t | o_t, a_(t-1), s_(t-1), dots ; theta_f)$


//Your sensors are always collecting data, but identify, store, and recall only a small amount

==
We can train memory $theta_f$ and policy $theta_pi$ end to end

$ s_t = f([o_t, a_(t-1)], [o_(t-1), a_(t-2)], dots, theta_f) \ 
  a_t tilde pi (dot | s_t; theta_pi)
$

$ argmax_(theta_f, theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] $

In this way, we *learn* the Markov state $s_t$ using parameters $theta_f$

*Example:* Stock market POMDP
- Learn $theta_f$ that represents $Tr, S$ from data
- Learn $theta_pi$ to maximize profits using learned $Tr, S$

==
*Definition:* We use a memory function $f$ to apply standard RL algorithms (policy gradient, Q learning, actor critic) to POMDPs

$ #redm[$s_t$] = f([o_t, a_(t-1)], [o_(t-1), a_(t-2)], dots, theta_f) 
$
$
argmax_(theta_f, theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = argmax_(theta_f, theta_pi) sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (#redm[$s_(n + 1)$] | s_0; theta_pi)
$ 

$ Pr (#redm[$s_(n+1)$] | s_0; theta_pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(#redm[$s_(t+1)$] | #redm[$s_t$], a_t) dot pi (a_t | #redm[$s_t$] ; theta_pi) ) $ 

//$ argmax_(theta_f, theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = \ argmax_(theta_f, theta_pi) sum_(n=0)^oo gamma^n sum_(t=0)^oo Pr(s_(t+1) | s_t, a_t) $

==
$ #redm[$s_t$] = f([o_t, a_(t-1)], [o_(t-1), a_(t-2)], dots, theta_f) \

argmax_(theta_f, theta_pi) bb(E)[cal(G)(bold(tau)) | s_0; theta_pi] = argmax_(theta_f, theta_pi) sum_(n=0)^oo gamma^n sum_(s_(n + 1) in S) cal(R)(s_(n+1)) dot Pr (#redm[$s_(n + 1)$] | s_0; theta_pi) \
 

Pr (#redm[$s_(n+1)$] | s_0; theta_pi) = sum_(s_1, dots, s_n in S) product_(t=0)^n ( sum_(a_t in A) Tr(#redm[$s_(t+1)$] | #redm[$s_t$], a_t) dot pi (a_t | #redm[$s_t$] ; theta_pi) ) $ 

This is a very difficult optimization problem
- Difficulty increase combinatorially with trajectory length
- Deep models are surprisingly capable and generalize well
    - In practice, do not need combinatorially more samples

==
POMDPs are the most flexible decision making process I know

I have not yet encountered a problem that POMDPs cannot represent

We can solve POMDPs by combinining memory and standard RL

Today, there is enough compute to solve simpler tasks
- Visual navigation
- Board games
- Memory tasks given to humans

As GPUs become faster, we will see very interesting results
- Your generation will see RL applied to useful tasks
- You can be the ones to do apply it!

= Coding
==
```python
f = Transformer()
pi = nn.Sequential(..)
episode = []
while not terminated:
    a = sample_action(f, pi, episode["o"], episode["a"])
    episode.append(env.step(action))
    next_state = f(episode['o'])
```

==
When sampling actions, we must compute $f$ over the full trajectory 

```python
def sample_action(f, pi, obs, action):
    # trajectory up to timestep t
    traj = concatenate([obs, action])
    state = f(traj) # s_t
    a = pi(state)
```

==
We can utilize existing loss functions

Implement a wrapper to compute states then call regular loss

```python
def recurrent_loss(models, episode, loss_fn=pg_loss):
    f, pi = models
    # You can parallelize this to improve speed
    # I write it out for clarity
    states = []
    for t in range(len(episode)):
        states.append(f(episode["o"], episode["a"]))
    states = array(states)
    return loss_fn(pi, states, episode) 
```

= Multiagent RL
==
We model multiagent RL as a POMDP with additional structure

In a Decentralized MDP (DecMDP), the state is distributed across agents

Consider observations over agents instead of time

#side-by-side[
    Temporal POMDP

    $ s_t = mat(o_t, emptyset; o_(t-1), a_(t-1); dots.v, dots.v; o_0, a_0) $
][
    DecMDP
    $ s_t = mat(o_(i, t); o_(i - 1, t); dots.v; o_(0, t)) $
]
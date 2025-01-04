#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm
#import "@preview/touying:0.5.4": *
#import themes.university: *
#import "common.typ": *
#import "@preview/cetz:0.3.1"

#set math.vec(delim: "[")
#set math.mat(delim: "[")

#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Introduction],
    subtitle: [CISC 7026 - Decision Making],
    author: [Steven Morad],
    institution: [University of Macau],
    logo: image("fig/common/bolt-logo.png", width: 4cm)
  ),
  header-right: none,
  header: self => utils.display-current-heading(level: 1)
)

// TOOD: Replace bandits with overview of RL vs ML vs IL etc

#title-slide()

== Outline <touying:hidden>

#components.adaptive-columns(
    outline(title: none, indent: 1em, depth: 1)
)

= Course information


==
- Prerequisites
- Cheating/AI
- Grading/Participation
- Lecture plan
- Structure
- Github

==
*Prerequisites:* #pause
- Deep learning #pause
- Multivariable calculus #pause
- Statistics and probability 

==
*Grading:*

- Quizzes 30% #pause
- Assignments 30% #pause
- Final Project 30% #pause
- Participation 10% #pause

==
*Quizzes:*
- I will tell you week before exam #pause
- Expect 3 quizzes

==
*Assignments:*
- Programming #pause
- Expect 3 assignments

==
*Final Project:* #pause
#side-by-side[
#cimage("fig/01/hok.jpg") #pause
][
- Research based #pause
- Tencent offers compute and Honor of Kings environment #pause
- Train agents to beat humans at Honor of Kings #pause
- Implement RL algorithm, improve it, write up analysis #pause
- More information later

]

==
*Participation:*

National Academy of Sciences:

#cimage("fig/01/active-learning.png")

==
*Participation:*
I want this class to be interactive #pause

Participation is *asking* or *answering* questions during lecture #pause

To encourage you, your grade depends on interacting #pause

- Class participation #pause
- Individual participation #pause


==
*Office Hours:* Thursday 10:00 - 12:00 #pause

*Textbook:* http://incompleteideas.net/book/the-book-2nd.html #pause

*Github:* https://github.com/smorad/um_cisc_7404 #pause

==
*Cheating:* #pause

I don't like cheating #pause

All assignments will use turnitin #pause

Turnitin detects copying and LLM use #pause

I gave many zeros in last term's deep learning course #pause

This term, I will forward any suspected cheating to the head of department #pause

I will also give you an F grade in the course #pause

It is not worth cheating, do your best and you will get partial credit

==
*Question:* What is cheating? #pause

Copying assignment or exam from another student #pause

Having notes, laptop, or phone out during quiz/exam #pause

Submitting LLM output for assignments

==
*Secret:* After you graduate nobody will care about your grade/degree! #pause

For AI jobs, you will do 5 hours of in-person interviews #pause

You will write on a whiteboard in front of interviewers #pause

Your diploma will not tell you the answer! #pause

To get the job, you must *understand* the material #pause

If you cheat, maybe you pass the class, but you will fail life #pause

Your degree will be useless without the knowledge #pause

I want you to *learn the material* so you succeed in life

==
#cimage("fig/01/interview.png")
==

#cimage("fig/01/interview2.png")

==
*Question:* Can you use LLMs in class? #pause

You can ask LLMs for help, but *do not turn in LLM output* #pause

*Ok:* LLM, is $underline(quad quad)$ a correct translation of $underline(quad quad)$ #pause

*Ok:* LLM, is $underline(quad quad)$ correct grammar? #pause

*Cheating:* LLM, answer the following homework question $underline(quad quad)$ #pause

*Ok:* LLM, why does does this code raise `AttributeError`? #pause

*Ok:* LLM, why does my Q function return large values? #pause

*Cheating:* LLM, implement the policy gradient algorithm in pytorch



== 
*Lecture Topics:* #pause
- Introduction #pause
- Basics #pause
- Modern Methods #pause
- Active Research

==
*Introduction* #pause
- Introduction #pause
- Bandits #pause
==
*Basics:* #pause
- Review of Deep Learning #pause
- Decision Processes #pause
- Value Iteration
- Policy Gradient
- Actor Critic
==
*Modern Methods:*
- Advantage Actor Critic
- Trust Region Policy Optimization
- Proximal Policy Optimization
- Deep Q Learning
- Deep Deterministic Policy Gradient
- Soft Actor Critic
- Imitation learning
==
*Active Research:*
- Memory 
- Offline RL
- RL and Search
- World Models
- RL from Human Feedback

= What is Decision Making?

/*
==
What is decision making? (and problem solving)

History of decision making

Applications of decision making

Difficult problems do not admit human designed algorithms

Difference to neural networks
*/

==
I thought for a while what to call this course #pause

We will focus primarily on reinforcement learning #pause

But reinforcement learning is a method, not a problem #pause

The problem we solve is *decision making*

==
*Question:* What is decision making? #pause

It depends, each field has their own definition  #pause

- Philosophy #pause
- Mathematics #pause
- Cognitive science #pause
- Economics #pause
- Computer science #pause
- Military science  #pause

*Answer:* Given information, make a choice


==
*Question:* Why should we care about decision making? #pause


Everything in life is a decision #pause

- Do I eat dumplings or noodles? #pause
- What time should I leave for class? #pause
- Should I go to school or find a job? #pause
- Should I date this person? #pause
- Where should I live? #pause
- What should we use taxes for? 

==
Humans are decision making machines -- it is all we do! #pause

Your life is a series of decisions #pause

Who we are is defined by what we do #pause

"All we have to decide is what to do with the time that is given to us" #pause

To study decision making is to study ourselves #pause

If we learn to make better decisions, we can lead better lives 

==

In this course, we focus on *optimal* decision making #pause

Making good decisions leads to a better world #pause
- Surgeon (where to cut?) #pause
- Lawyer (what to argue?) #pause
- Scientist (what to research?) #pause

In this course, we investigate how to make the *best* (optimal) decisions #pause

We will create machines to make decisions for us #pause

If our machine makes optimal decisions, it is the best surgeon/lawyer/scientist #pause

If our machine understands *why* it makes decisions, it is conscious

==
Let us discuss the history of decision making to better understand it 

= History of Decision Making
==

*Question:* Who was the first to apply decision making algorithms? #pause

#side-by-side(align: horizon)[#cimage("fig/01/cell.jpeg", height: 60%)][*3.5 GYA:* Single cell organism] #pause

Decides to move away from danger and move towards food #pause

Decision making is necessary for life

==
#side-by-side[
  #cimage("fig/01/hunter.jpg", height: 80%) #pause
][
  *200 kYA:* Humanoid hunter-gatherers develop more complex decision making capabilities #pause

  Sequence of decisions to make fire #pause

  //Should we apply mud to our wounds? #pause

  Do we move with the animals, or do we stay and create farms?
]

==

  #side-by-side()[
    #cimage("fig/01/tzu.jpg") 
  ][

  *500 BCE:* Humans begin to study decision making #pause

    Sun Tzu studies and writes about various forms of decision making #pause

    E.g., zero sum games: "Attack where he is unprepared; appear where you are not expected."

  ]



==
#side-by-side[
  #cimage("fig/01/aristotle.jpg", height: 100%) 
][
*400 BCE:* Aristotle creates the earliest recorded framework for decision making #pause

Syllogistic logic and deductive reasoning from axioms #pause

*Axiom 1:* All philosophers prioritize knowledge over leisure #pause

*Axiom 2:* I am a philosopher #pause

*Decision:* I must attend lecture instead of the party
]

==

#side-by-side[
  #cimage("fig/01/pascal.jpg", height: 100%) 
][
*1654:* Pascal formalizes decision making under uncertainty with "Pascal's Wager" #pause

*Premise:* You are in bed, about to die. Should you believe in God? #pause

#table(
  columns: 3,
  [], [Believe], [Do not believe],
  [God exists], [Good], [Bad],
  [God does not exist], [Neutral], [Neutral]
)

]

==

#side-by-side[
  #cimage("fig/01/markov.jpeg", height: 100%) 
][
*1906:* Markov discovers Markov processes #pause 

All modern decision making systems use Markov processes
]

==

#side-by-side[
  #cimage("fig/01/bellman.jpg", height: 100%) 
][
*1953:* Bellman discovers dynamic programming #pause

Gives us the *Bellman equation*, the basis for optimal decision making
]

==

#side-by-side[
  #cimage("fig/01/sutton.jpg", height: 100%) 
][
*1983:* Sutton solves the Bellman equation using neural networks #pause

Combines reinforcement learning and neural networks #pause

He is still alive and will answer your emails, but will not attend your thesis defense #pause


We use his textbook _An Introduction to Reinforcement Learning_

]

==
#side-by-side[
  #cimage("fig/01/kasparov.jpeg", width: 100%) 
][
*1997:* DeepBlue beats world champion Kasparov at chess #pause

People start to pay attention to decision making machines #pause

Chess AIs start playing each other because humans are too easy #pause

https://www.youtube.com/watch?v=KF6sLCeBj0s
]

==
#side-by-side[
  #cimage("fig/01/sedol.jpg", width: 100%) 
][
*2016:* AlphaGo beats world champion Sedol at Go #pause

https://www.youtube.com/watch?v=tXlM99xPQC8
]

==
#side-by-side[
  #cimage("fig/01/dota.jpeg", width: 100%) 
][
*2018:* OpenAI Five beats world champions Sedol at Dota2 #pause

https://www.youtube.com/watch?v=eHipy_j29Xw
]

==

#side-by-side[
  #cimage("fig/01/dota.jpeg", width: 100%) 
][
*2020-2024:* GPT-3, GPT-4 trained using reinforcement learning
]

==
2025?

= ML vs RL

==
How does decision making differ from machine learning?

= Application

==

TODO: bitter lesson
Machines that make optimal decisions would improve our world #pause

But humans still make most decisions in the world today #pause

*Question:* Why is this? #pause

We have optimal decision making machines, but they focus on smaller problems like games #pause

What is the current state of artificial decision making?

==
TD-Gammon

#side-by-side[
][
  *1992:* TD-Gammon outperforms professionals in Backgammon
]

==

#side-by-side[
  
][
*1997:* DeepBlue beats world champion at Chess 
]

==
Deep Q Networks

==
AlphaGo

==
AlphaStar

==
Tokamak

==
ChatGPT

= Approaches

==
There are many approaches to decision making #pause

==
Rule-based systems follow a system of rules provided by a programmer #pause

*Question:* Any examples? #pause

```python
# Traffic light
if car_at_light:
  pedestrian_light = red
  car_light = green
else:
  pedestrian_light = green
  car_light = red
``` 

==


==
TODO 

- Timeline
- Decision making vs ML
- Classical approaches
  - A\*
  - Programmed
  - Learning
    - Scales with data and compute
    - Bitter lesson
- Types of decision making learning
  - RL 
  - Planning
  - IL
- Videos


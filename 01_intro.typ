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
    subtitle: [CISC 7404 - Decision Making],
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



/*
==
- Prerequisites
- Cheating/AI
- Grading/Participation
- Lecture plan
- Structure
- Github
*/

= Prerequisites
==
- Python numerical programming #pause
- Deep learning #pause
- Statistics and probability 

==
*Python numerical programming:* #pause

You should know: #pause
- Python loops, lists, dicts, etc #pause
- Python objects, inheritance, functional programming, etc #pause
- `numpy` and `torch` #pause
  - Batch matrix multiply, elementwise product, sum, max, etc #pause
  - Multidimensonal tensors (i.e., shape) #pause

Assignments in `jax/equinox`, similar to `torch` - final project in `torch` #pause

If you do not know numerical programming, *you must learn immediately*: https://numpy.org/doc/stable/user/quickstart.html
==
*Deep learning:* #pause

You should know: #pause
- How to construct a neural network in `torch` #pause
- Classification and regression losses #pause
- Optimization/SGD #pause
- How to train a neural network #pause
- Multilayer perceptrons #pause
- Convolutional networks #pause
- Recurrent networks #pause

If you do not, review the deep learning slides: https://github.com/smorad/um_cisc_7026

==

*Statistics and probability:* #pause

You should know: #pause
- Random variables ($X$) #pause
- Probability density and mass functions (PDF, PMF) #pause
- Conditional and unconditional probabilities #pause
- The entropy of a distribution #pause

*Question:* What does $P(X=x)$ mean? #pause

*Answer:* Probability of random variable $X$ taking on a value of $x$ #pause

If you did not know this, you should review!

= Grading

== // 14:00

- Quizzes 30% #pause
- Assignments 30% #pause
- Final Project 30% #pause
- Participation 10% 

==
*Quizzes:* #pause
- I will tell you week before exam #pause
- Expect 3 quizzes #pause
- I will drop your lowest quiz score #pause

*Example 1:* Quiz 1: 70%, Quiz 2: 80%, Quiz 3: 60% #pause

Final quiz score: (70 + 80) / 2 = 75% #pause

*Example 2:* Quiz 1: 90%, Quiz 2: (sick) 0%, Quiz 3: 70% #pause

Final quiz score: (90 + 70) / 2 = 80% #pause

*Question:* What if you are sick for two quizzes? #pause Only one quiz dropped, other quiz is zero


==
*Assignments:* #pause
- Programming #pause
- Expect 2-3 assignments #pause
- We will use Google Colab: https://colab.research.google.com

// 23:00

==
*Final Project:* #pause

#side-by-side[
Honor of Kings 
#cimage("fig/01/hok.jpg") #pause
][
- Research project based on Tencent platform #pause
- Train agents to play each other #pause
- Implement RL algorithm, improve it, write up analysis #pause
- More information later

]

==
*Participation:* #pause

#cimage("fig/01/active-learning.png", height: 85%)

==
*Participation:*
I want this class to be interactive #pause

Participation is *asking* or *answering* questions during lecture #pause

To encourage you, your grade depends on interacting #pause

- Class participation #pause
- Individual participation 

// 30:00

= Resources
==
*Office Hours:* Thursday 10:00 AM - 12:00 PM #pause

*Textbook:* http://incompleteideas.net/book/the-book-2nd.html #pause
- Syllabus lists textbook chapter for each lecture #pause

*Github:* https://github.com/smorad/um_cisc_7404 

// 35:00

= Cheating

==
*Question:* What is cheating? #pause

*Answer:*  #pause
  - Copying assignment or exam from another student #pause
  - Having notes, laptop, or phone during quiz/exam #pause
  - Submitting LLM output for assignments

==
I don't like cheating #pause

All assignments and final project will use `turnitin.com` #pause

Turnitin detects copying between students and LLM use #pause

I gave many zeros in last term's deep learning course #pause

This term, I will report any cheating to the head of department #pause

I will also give you an F grade in the course #pause

It is not worth cheating, do your best and you will get partial credit

==
*Secret:* After you graduate nobody will care about your grade/degree! #pause

For AI jobs, you will do 5 hours of in-person interviews #pause

You will write on a whiteboard in front of interviewers #pause

There is nobody to copy and no LLM to help #pause

To get the job, you must *understand* the material #pause

Your degree will be useless without the knowledge #pause

I want you to *learn the material* so you succeed in life

==
#cimage("fig/01/interview.png")
==

#cimage("fig/01/interview2.png")

// 45:00
==
*Question:* Can you use LLMs in class? #pause

You can ask LLMs for help, but *do not turn in LLM output* #pause

*Ok:* LLM, is $underline(quad quad)$ a correct translation of $underline(quad quad)$ #pause

*Ok:* LLM, is $underline(quad quad)$ correct grammar? #pause

*Cheating:* LLM, answer the following homework question $underline(quad quad)$ #pause

*Ok:* LLM, why does my code raise `AttributeError`? #pause

*Ok:* LLM, why does my Q function return large values? #pause

*Cheating:* LLM, implement the policy gradient algorithm in pytorch



= Lecture Topics
== 
- Basics #pause
- Modern Methods #pause
- Active Research

==
*Basics:* #pause
- Bandits #pause
- Decision Processes #pause
- Value Iteration #pause
- Policy Gradient #pause
- Actor Critic
==
*Modern Methods:* #pause
- Advantage Actor Critic #pause
- Trust Region Policy Optimization #pause
- Proximal Policy Optimization #pause
- Deep Q Learning #pause
- Deep Deterministic Policy Gradient #pause
- Soft Actor Critic #pause
- Imitation learning
==
*Active Research:* #pause
- Memory #pause
- Offline RL #pause
- RL and Search #pause
- World Models #pause
- RL from Human Feedback

// 50:00

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
In this course, we will focus primarily on reinforcement learning #pause

But reinforcement learning is a method, not a problem #pause

The problem is *decision making* #pause

In this course, we will learn how to make good decisions

==
*Question:* What is decision making? #pause

It depends, each field has their own definition  #pause

- Philosophy #pause
- Cognitive science #pause
- Economics #pause
- Machine learning #pause

*Answer:* Given information, make a choice that impacts the world

// 60:00

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

We can represent life as a series of decisions #pause

What we do defines who we are #pause

"All we have to decide is what to do with the time that is given to us" #pause

To study decision making is to study ourselves #pause

If we learn to make better decisions, we can lead better lives 

==

In this course, we focus on *optimal* decision making #pause

Make the best possible decision, given the information we have #pause

We will find methods that *guarantee* optimal decision making #pause

With these methods, we can create optimal decision making machines #pause

With an optimal decision making machine, you can create: #pause
- Best possible doctor (which medicine to give?) #pause
- Best possible lawyer (what to argue?) #pause
- Best possible scientist (what to research?) #pause

If the machine understands *why* it makes decisions, it is conscious

/*
If you 

We will investigate how to make the *best* (optimal) decisions #pause

We will create machines to make optimal decisions for us #pause

If our machine makes optimal decisions, it is the best surgeon/lawyer/scientist #pause

If our machine understands *why* it makes decisions, it is conscious
*/

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

  Sequence of decisions to plant crops

  //Should we apply mud to our wounds? #pause

  //Do we move with the animals, or do we stay and create farms?
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

Modern decision making relies on Markov processes
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

He is still alive and might answer your emails #pause


We use his textbook: _An Introduction to Reinforcement Learning_

]

==
#side-by-side[
  #cimage("fig/01/kasparov.jpeg", width: 100%) 
][
*1997:* DeepBlue beats world champion Kasparov at chess #pause

People start to pay attention to decision making machines #pause

Chess AIs play each other because humans are too easy #pause

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
*2018:* OpenAI Five beats world champions at Dota2 #pause

https://www.youtube.com/watch?v=eHipy_j29Xw
]

==

#side-by-side[
  #cimage("fig/01/openai.svg", width: 100%) 
][
*2020-2024:* GPT-3, GPT-4 trained using reinforcement learning
]

==
2025?

= Decision Making and Deep Learning

==
We will formally define decision making and reinforcement learning later in the course #pause

For now, I want to clarify decision making in the context of machine learning #pause

How does decision making differ from regular deep learning?

==

#cimage("fig/01/ml_types.png")



==
In deep learning, we usually know the answer #pause

$ f(bold(x), bold(theta)) = bold(y) $ #pause

In decision making, we often do not know the answer! #pause

$ f(bold(x), bold(theta)) = ? $ #pause

What does this mean?

==
*Example:* You train a model $f$ to play chess #pause

$ f: X times Theta |-> Y $ #pause

$ X in "Position of pieces on the board" $ #pause

$ Y in "Where to move piece" $ 

==
#side-by-side[$ X in "Position of pieces on the board" $][
    $ Y in "Where to move piece" $ 
] #pause

#cimage("fig/01/chess.png", height: 85%)

==
#cimage("fig/01/chess.png", height: 85%) 

#side-by-side[What is the correct answer? #pause][We do not know the answer]//[But RL can tell us!]

==
#cimage("fig/01/chess.png", height: 85%) 

How can we learn a model without an answer?

//#side-by-side[No answer, no supervised learning#pause][RL can train without the answer!]//[But RL can tell us!]

==
#cimage("fig/01/chess.png", height: 85%) 

#side-by-side[An answer gives us just one move #pause][We need many moves to win]

==
Decision making can give us the best *sequence* of moves to: #pause

- Win a game of chess #pause
- Drive a customer to the store #pause
- Cook a tasty meal #pause
- Treat a sick patient #pause
- Prevent climate change #pause
- Reduce human suffering #pause

We do not know the correct moves #pause

But with decision making, we can find them!


= Questions?


= Homework

==
- Review prerequisites #pause
  - Especially probability #pause
- Play with Google Colab #pause
- Download Sutton and Barto textbook #pause
  - Read Chapter 1.1 (few pages) #pause
  - Read Chapter 2 before next lecture

/*
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

// 1h:21
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

*/
#import "@preview/algorithmic:0.1.0"
#import algorithmic: algorithm
#import "@preview/touying:0.5.4": *
#import themes.university: *
#import "common.typ": *
#import "@preview/cetz:0.3.1"
#import "@preview/fletcher:0.5.4" as fletcher: diagram, node, edge
#import "@preview/pinit:0.2.2": *

#set math.vec(delim: "[")
#set math.mat(delim: "[")


#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Quiz],
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

= Exam

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

==
Our lab is always looking for smart students to work on RL problems #pause

If you thought the exam was easy, come talk to me after class

= Review


= Coding

== 
In this course, we will implement MDPs using *gymnasium* #pause

Developed by OpenAI for reinforcement learning #pause

Gymnasium provides an *environment* (MDP) API #pause

Must define: #pause
  - state space ($S$) #pause
  - action space ($A$) #pause
  - step ($Tr, R, "terminated"$) #pause
  - reset ($s_0$) #pause

https://gymnasium.farama.org/api/env/


==
Gymnasium uses *observations* instead of *states* #pause

*Question:* What was the Markov condition for MDPs? #pause

The next Markov state only depends on the current Markov state #pause

$ Pr(s_(t+1) | s_(t), s_(t-1), dots, s_1) = Pr(s_(t+1) | s_(t)) $ #pause

If the Markov property is broken, $s_t in S$ is not a Markov state #pause

Then, we change $s_t in S$ to an *observation* $o_t in O$ (more later) #pause

Gymnasium uses observations, but for MDPs we treat them as states

==
```python

import gymnasium as gym

MyMDP(gym.Env):
  def __init__(self):
    self.action_space = gym.spaces.Discrete(3) # A
    self.observation_space = gym.spaces.Discrete(5) # S

  def reset(self, seed=None) -> Tuple[Observation, Dict]

  def step(self, action) -> Tuple[
    Observation, Reward, Terminated, Truncated, Dict
  ]
```

==
I stress MDPs in this course because it is the most important concept #pause

We will see an example of using RL to solve a task #pause

You do not know any RL algorithms, but we will can still solve an MDP #pause

If you can make an MDP, you can use existing code to solve it! #pause

For example, you can use stable-baselines3

https://stable-baselines3.readthedocs.io


==
https://colab.research.google.com/drive/1rDNik5oRl27si8wdtMLE7Y41U5J2bx-I#scrollTo=yVjbC_VQ-Wha
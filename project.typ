= CISC 7404 Final Project
For the final project, you will implement a decision making algorithm and solve an interesting problem. Some algorithm examples include Rainbow, CQL, TCQ, GRPO, A2C, PPO, TRPO, DDPG, SAC, DPO, GAIL, BC, and more. You must complete the assignment in `jax` and `equinox` or `flax.nnx`, you will not get points for using `torch`, `tensorflow`, or `flax.linen`.

== Deadlines
- (March 15, 23:59) Submit group members
- (March 29, 23:59) Submit project plan 
- (May 21, 23:59) Submit project

== Deliverables
You must submit:
+ Project plan and group members
    - Create group name (whatever you want)
    - List group members (names and ID)
        - 3-5 members per group
    - Only one person per group submit project plan
    - 2 desired projects
        - One normal project
        - One easier backup project in case your normal project is too hard
        - Provide observation/state space, action space, reward function
+ Your code, `requirements.txt`, and instructions to run code 
    - If I cannot run your code you will not get a good score
+ A video recording of your trained policy in the environment
+ A writeup describing your approach and decisions
    - Motivate why your problem is interesting
    - Describe your algorithm, and why it is good for your problem
    - Describe implementation and your struggles
    - Explain your results, using plots and visualizations
    - Writeup format should follow https://rl-conference.cc/2024/papers.html
        - Make it pretty, ugly papers will lose writeup points
    - Aim for 4-5 pages
        - If more than 5 pages, create appendix (unlimited length)

== Grading
- (10 points) Group members and project plan
- (30 points) Implementation
- (30 points) Video and writeup
- (30 points) Difficulty modifier
    - Trivial projects get 0 points, hard or interesting projects get 30 points

== Tips
- You will probably need to use the GPU lab
- Start early, some problems make require many experiments to work
    - Other problems could take one day to train
- If training an LLM, make sure you have enough compute!
- Reusing your policy gradient or DQN implementation will not give you many points
    - Either use new algorithm or add improvements
        - E.g., DQN with CNN and RNN
- You can implement your own MDP/POMDP or find environments made by others
    - Not all tasks are games! You will receive more points for tasks that help the world
        - Protein building, hospital treatment, etc
    - Solving easy tasks like CartPole/MountainCar/Pendulum will not give many points 
- Work together intelligently
    - While some develop MDP, others can develop algorithm
    - It is much easier to find bugs if you work together


== Example Tasks
I would prefer you find a task that interests you. If you cannot, here are some example tasks:
- Atari tasks (Pong too easy, try others)
- MuJoCo (Humanoid tasks, others too easy)
- Tasks invented by fellow students in Macau (try medium/hard difficulties)
    - https://github.com/bolt-research/popgym_arcade
- Pokemon, Super Mario, other gameboy games
    - https://github.com/Baekalfen/PyBoy
- Jumanji contains tasks like Sudoku, Rubiks Cube, etc
    - https://github.com/instadeepai/jumanji
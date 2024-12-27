# Guide points
1. model description
2. significant design decisions/extensions
3. experiments methodology and results, comparison to other models
5. tipping points
6. equilibrium states

# 2 baseline model
The first proposed model implements all basic behaviours present in subsequent models, with slight differences. This environment generates a set of fishes and dolphin around a 2D space where they're free to move.
The fish agents have a set of rules for:
- Roaming: the fish moves in a random direction.
- Fleeing: the fish flees in the direction opposite to the predator when it sees it. If multiple predator are near the fish, it flees in the direction opposite to the nearest predator.
- Reproducing: the fish can spawn another fish in an adjacent position after a fixed set of time.
The dolphin agents have a set of rules for:
- Roaming: the dolphin moves in a random direction.
- Hunting: the dolphin chase in the direction of a fish when it sees it. If multiple fishes are in the range of vision of the dolphins, it chase the nearest.
- Eat: the dolphin eat the fish when it reaches its position, removing the target agent from the simulation.
For a coding base, i used the [Wolf Sheep Predation meh](http://ccl.northwestern.edu/netlogo/models/community/Wolf Sheep Predation meh) by dj| model present in the NetLogo library. 

## 2.1 Significant design decisions and extensions
Fishes and dolphins have their own separate parameters for speed and vision range, while another parameter exclusive to fishes is the reproduction rate, expressed in ticks. Fish reproduction can be turned off with the apposite switch.
Dolphins are only allowed to eat fishes if and only if they're in the same space as their prey. This is a result of the reference model i used, where wolves would eat sheep following the same condition.
This led to giving the dolphins the ability to adjust their velocity to catch fishes if they're close than their current velocity, as otherwise they might get stuck in a back and forth exchange where the dolphin never reaches the fish for any speed difference greater than 0.

## 2.2 Methodology and results
Research was conducted to find under what conditions and limits the network is in a state of equilibrium, while still being able to predict where the fishes or the dolphins would dominate the environment.
That is, at what point do the survivability of fishes exceeds the dolphin hunting effectiveness, and thus we'll see an increase in the population? at what point the population growth will be equal to the lost fishes?
A proper state of equilibrium was not achieved during the tests because of the inconsistency of the dolphin's time to eat a given amount of fishes. Instead, every parameter was tested in a neutral environment (no advantage to fishes nor dolphins) to see how the changes affected the given statistics. Interest was particularly given to the number of ticks in the simulation before the fishes got extincts.
Common parameters:
Vision range for Fishes and Dolphins: 3 cells
Dolphin speed: 1.2 cells
Fish speed: 1 cell
Fish reproduction rate: 150 ticks
Dolphin population: 10 turtles
Fish population: 100 turtles

All the experiment results are present in the report, with the corresponding name as a csv file.
### 2.2.1 Population
First off, the number of fishes in the simulation was estimated to increase the lifespan of the simulation at a directly proportional exponential increase.
The number of fishes affected the length of the simulation not as predicted, as the increase seemed linear. This is because dolphins can eat one fish at a time. It makes sense that eating more fishes would require more time, hence the proportional increase in fish population and ticks elapsed.

The number of dolphins would then, logically, not be linear, as a dolphin can eat more fishes, but a fish cannot be eaten more than once. Each dolphin is responsible to a percentage of fishes eaten, while each fish is responsible only for itself to be eaten. The expected outcome of the variance in number of ticks is expected to be of rational type.
With the experiments the predictions got confirmed especially when reproduction was enabled. Each dolphin made a huge impact on ticks elapsed, as well as fishes eaten per tick, being as high as 0.699, but retaining a much higher mean compared to the experiment with reproduction off.
The mean of fishes eaten skyrockets when there are fewer dolphins in a reproduction enabled environment, as the fishes have more chances to reproduce, making the total
population of fishes existed greater than in other simulations with higher amounts of dolphins.

### 2.2.2 Speed
Speed was estimated to be a deciding factor in fishes overpopulation, especially when the fish speed exceeded the dolphin's speed. This was not the case once again, as in reality the reported ticks were closer to a tipping point behaviour rather than any linear increase. The tipping point is obviously when the fish speed exceeds the dolphin speed, but it's interesting to see that they don't overpopulate despite the massive advantage they have over the dolphins, which is the case because of their fleeing behaviour: dolphins have the chance to eat the fishes when it's being chased by another dolphin or when the fish stumbles really close by swimming randomly. We experience a rise in fish survivability when the difference is small, but then with higher amounts of speed, the ticks elapsed start to lower a bit as a result of the fish speed causing the fish to move closer to the dolphins before it sees the predator.

Dolphin speed hugely impacted their hunting efficiency, ranging closer to a exponential increase as seen by the numbers reported. The fishes eaten each tick ranged from approximately 0.1 to around 0.5 with the peak of growth being around 1.5 and 1.7 speed. These results seem to be interconnected with the vision range, as the "tipping point" seems to be when the dolphins move at more than 50% of the fishes vision range, which makes perfect sense at a micro level.

### 2.2.3 Vision ranges



- predictions + results
	- initial number of fish -> higher = more ticks, log increase

		Linear increase, makes sense as the dolphins eat linearly
	- initial number of dolphins -> higher -> less ticks, log decrease
		1 dolphin -> 1089
		25 dolphins -> 89
		125 -> 15
		250 -> 10 ticks
		rational type
		Board size has an impact on this
	- delta speed (dolphin > fish) -> 0 tends to infinite ticks, the higher the more fishes eaten per tick, rational type
		-0.1 -> 3k ticks
		0 -> 1100 - 1400 ticks, 0.08~ eaten
		0.1 -> 422 ticks, 0.2~ eaten per tick
		0.5 -> 261, 0.35~ eaten per tick
		1 -> 148, 0.60~ eaten per tick
		2 -> 100~, 0.75~ eaten per tick, inconsistent (0.5 - 1.2)
		5 -> 90~, 0.9~ eaten per tick
		rational positive type
		doesn't tend to infinite when 0 nor negative because multiple dolphins can create a local world state where a fish can be eaten
	- delta vision range -> negative tends to infinite ticks, higher more fishes eaten per tick?
		-1 -> 6.5k
		0 -> 300-400 ticks
		12 -> 150~ ticks
		25 -> 40-60 ticks
		doesn't tend to infinite when 0 nor negative because multiple dolphins can create a local world state where a fish can be eaten
	- fish reproduction rate
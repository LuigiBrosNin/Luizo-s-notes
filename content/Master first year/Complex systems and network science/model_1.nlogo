; fish and dolphin turtles
breed [ fishes fish ]
breed [ dolphins dolphin ]

fishes-own [ lifetime fish-reproduce ]
dolphins-own [ fishes-eaten ]

globals [ max_turtles ]

to setup
  clear-all

  ; blue background
  ask patches [ set pcolor blue ]

  set max_turtles 2000

  create-fishes initial-number-fish ; create the fishes, then initialize their variables
  [
    set shape  "fish"
    set color white
    set size 1.5  ; easier to see
    set label-color blue - 2
    set lifetime 0
    set fish-reproduce 0
    setxy random-xcor random-ycor
  ]

  create-dolphins initial-number-dolphins  ; create the dolphines, then initialize their variables
  [
    set shape "shark"
    set color black
    set size 2  ; easier to see
    set fishes-eaten 0
    setxy random-xcor random-ycor
  ]
  displayLabels
  reset-ticks
end

to go
  ; stop the model if there are no turtles or if there are too many turtles in the simulation
  if not any? turtles or count turtles > max_turtles [ stop ]

  if not any? fishes [ user-message "The dolphins have inherited the earth" stop ]

  if count turtles > max_turtles [ user-message "Turtles limit reached" stop ]

  ask fishes [ ; fish logic

    moveFish

    set lifetime lifetime + 1

    if fish-reproduction [
      reproduceFishes  ; fish reproduce at a random rate governed by a slider
    ]
  ]

  ask dolphins [
    moveDolphin

    eatFish ; dolphins eat a fish on their patch
  ]

  tick
  displayLabels
end

to moveFish  ; move fish procedure

  let closest-dolphin min-one-of dolphins [distance myself]  ; Find the closest dolphin to this fish

  ; move or flee based on nearby dolphins
  ifelse closest-dolphin != nobody and distance closest-dolphin <= fish-vision-range [  ; Adjust to vision range
    face closest-dolphin  ; Make the fish face the dolphin
    set heading (heading + 180)  ; Set heading to the opposite direction (flee)
    fd speed-fish ; Move the fish away from the dolphin (increase number if faster fleeing is desired)
  ]
  [
    rt random 180
    lt random 180
    fd speed-fish
  ]

end

to moveDolphin  ; move dolphin procedure
  let closest-fish min-one-of fishes [distance myself]  ; Find the closest fish to this dolphin
  ifelse closest-fish != nobody and distance closest-fish <= dolphin-vision-range [  ; Adjust to vision range
    set color red  ; Change color to red if a fish is detected
    face closest-fish  ; Face the closest fish
    ifelse distance closest-fish < speed-dolphin [ ; fish in speed range -> no need to go at full speed
      fd distance closest-fish ; move to the fish
    ]
    [
      fd speed-dolphin  ; Move toward the fish
    ]
  ]
  [
    set color black  ; Set color back to black if no fish are detected
    rt random 180  ; Turn randomly
    lt random 180
    fd speed-dolphin  ; Move in a random direction
  ]
end

to reproduceFishes  ; fishes procedure
  set fish-reproduce (fish-reproduce + 1)
  if fish-reproduce >= fish-reproduction-rate [  ; check if it's time to make fishes reproduce
    set fish-reproduce 0
    hatch 1
    [ rt random-float 360
      fd 1
      set lifetime 0
    ]   ; hatch an offspring and move it forward 1 step
  ]
end

to eatFish  ; dolphin procedure to eat
  let prey one-of fishes-here                    ; grab a random fish
  if prey != nobody  [                          ; did we get one? if so,
    ask prey [ die ]                            ; kill it
    set fishes-eaten fishes-eaten + 1
  ]
end

to displayLabels
  ask turtles [ set label "" ]
end
@#$#@#$#@
GRAPHICS-WINDOW
360
10
1043
694
-1
-1
13.24
1
14
1
1
1
0
1
1
1
-25
25
-25
25
1
1
1
ticks
30.0

SLIDER
0
10
202
43
initial-number-fish
initial-number-fish
1
250
100.0
1
1
NIL
HORIZONTAL

SLIDER
0
190
202
223
fish-reproduction-rate
fish-reproduction-rate
0
1000
150.0
2
1
NIL
HORIZONTAL

SLIDER
0
45
217
78
initial-number-dolphins
initial-number-dolphins
1
250
10.0
1
1
NIL
HORIZONTAL

SLIDER
0
100
110
133
speed-fish
speed-fish
1
5
1.0
0.1
1
NIL
HORIZONTAL

BUTTON
280
10
349
43
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
275
50
350
83
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

PLOT
5
525
345
695
populations
time
pop.
0.0
100.0
0.0
100.0
true
true
"" ""
PENS
"fishes" 1.0 0 -612749 true "" "plot count fishes"

MONITOR
290
565
340
610
fishes
count fishes
3
1
11

SLIDER
110
100
245
133
speed-dolphin
speed-dolphin
1
10
1.0
0.1
1
NIL
HORIZONTAL

SWITCH
0
225
177
258
fish-reproduction
fish-reproduction
0
1
-1000

SLIDER
0
135
135
168
fish-vision-range
fish-vision-range
1
25
1.0
1
1
NIL
HORIZONTAL

SLIDER
135
135
337
168
dolphin-vision-range
dolphin-vision-range
1
25
1.0
1
1
NIL
HORIZONTAL

MONITOR
5
480
95
525
avg lifetime
mean [lifetime] of fishes
17
1
11

MONITOR
5
435
97
480
max lifetime
max [lifetime] of fishes
17
1
11

MONITOR
95
480
217
525
avg fishes eaten
mean [fishes-eaten] of dolphins
17
1
11

MONITOR
95
435
242
480
fishes eaten per tick
sum [ fishes-eaten ] of turtles / ticks
17
1
11

@#$#@#$#@
## WHAT IS IT?

This model explores the stability of predator-prey ecosystems. Such a system is called unstable if it tends to result in extinction for one or more species involved.  In contrast, a system is stable if it tends to maintain itself over time, despite fluctuations in population sizes.

## HOW IT WORKS

There are two main variations to this model.

In the first variation, the "sheep-wolves" version, wolves and sheep wander randomly around the landscape, while the wolves look for sheep to prey on. Each step costs the wolves energy, and they must eat sheep in order to replenish their energy - when they run out of energy they die. To allow the population to continue, each wolf or sheep has a fixed probability of reproducing at each time step. In this variation, we model the grass as "infinite" so that sheep always have enough to eat, and we don't explicitly model the eating or growing of grass. As such, sheep don't either gain or lose energy by eating or moving. This variation produces interesting population dynamics, but is ultimately unstable. This variation of the model is particularly well-suited to interacting species in a rich nutrient environment, such as two strains of bacteria in a petri dish (Gause, 1934).

The second variation, the "sheep-wolves-grass" version explicitly models grass (green) in addition to wolves and sheep. The behavior of the wolves is identical to the first variation, however this time the sheep must eat grass in order to maintain their energy - when they run out of energy they die. Once grass is eaten it will only regrow after a fixed amount of time. This variation is more complex than the first, but it is generally stable. It is a closer match to the classic Lotka Volterra population oscillation models. The classic LV models though assume the populations can take on real values, but in small populations these models underestimate extinctions and agent-based models such as the ones here, provide more realistic results. (See Wilensky & Rand, 2015; chapter 4).

The construction of this model is described in two papers by Wilensky & Reisman (1998; 2006) referenced below.

## HOW TO USE IT

1. Set the model-version chooser to "sheep-wolves-grass" to include grass eating and growth in the model, or to "sheep-wolves" to only include wolves (black) and sheep (white).
2. Adjust the slider parameters (see below), or use the default settings.
3. Press the SETUP button.
4. Press the GO button to begin the simulation.
5. Look at the monitors to see the current population sizes
6. Look at the POPULATIONS plot to watch the populations fluctuate over time

Parameters:
MODEL-VERSION: Whether we model sheep wolves and grass or just sheep and wolves
INITIAL-NUMBER-SHEEP: The initial size of sheep population
INITIAL-NUMBER-WOLVES: The initial size of wolf population
SHEEP-GAIN-FROM-FOOD: The amount of energy sheep get for every grass patch eaten (Note this is not used in the sheep-wolves model version)
WOLF-GAIN-FROM-FOOD: The amount of energy wolves get for every sheep eaten
SHEEP-REPRODUCE: The probability of a sheep reproducing at each time step
WOLF-REPRODUCE: The probability of a wolf reproducing at each time step
GRASS-REGROWTH-TIME: How long it takes for grass to regrow once it is eaten (Note this is not used in the sheep-wolves model version)
SHOW-ENERGY?: Whether or not to show the energy of each animal as a number

Notes:
- one unit of energy is deducted for every step a wolf takes
- when running the sheep-wolves-grass model version, one unit of energy is deducted for every step a sheep takes

There are three monitors to show the populations of the wolves, sheep and grass and a populations plot to display the population values over time.

If there are no wolves left and too many sheep, the model run stops.

## THINGS TO NOTICE

When running the sheep-wolves model variation, watch as the sheep and wolf populations fluctuate. Notice that increases and decreases in the sizes of each population are related. In what way are they related? What eventually happens?

In the sheep-wolves-grass model variation, notice the green line added to the population plot representing fluctuations in the amount of grass. How do the sizes of the three populations appear to relate now? What is the explanation for this?

Why do you suppose that some variations of the model might be stable while others are not?

## THINGS TO TRY

Try adjusting the parameters under various settings. How sensitive is the stability of the model to the particular parameters?

Can you find any parameters that generate a stable ecosystem in the sheep-wolves model variation?

Try running the sheep-wolves-grass model variation, but setting INITIAL-NUMBER-WOLVES to 0. This gives a stable ecosystem with only sheep and grass. Why might this be stable while the variation with only sheep and wolves is not?

Notice that under stable settings, the populations tend to fluctuate at a predictable pace. Can you find any parameters that will speed this up or slow it down?

## EXTENDING THE MODEL

There are a number of ways to alter the model so that it will be stable with only wolves and sheep (no grass). Some will require new elements to be coded in or existing behaviors to be changed. Can you develop such a version?

Try changing the reproduction rules -- for example, what would happen if reproduction depended on energy rather than being determined by a fixed probability?

Can you modify the model so the sheep will flock?

Can you modify the model so that wolves actively chase sheep?

## NETLOGO FEATURES

Note the use of breeds to model two different kinds of "turtles": wolves and sheep. Note the use of patches to model grass.

Note the use of the ONE-OF agentset reporter to select a random sheep to be eaten by a wolf.

### BEHAVIORSPACE FEATURES

For more information about BehaviorSpace and the features introduced in NetLogo 6.4.0 see the [documentation](https://ccl.northwestern.edu/netlogo/docs/behaviorspace.html).

The “New BehaviorSpace Features” experiment illustrates some of the BehaviorSpace features introduced in NetLogo 6.4.0. You can open BehaviorSpace using the Tools -> BehaviorSpace menu item. Click the EDIT button to see the details of the experiment.

Note the use of 3 repetitions, so there is enough data to calculate the standard deviation of metrics at steps where data is available for all repetitions.

Note the use of metrics that return lists, which can be processed in the Lists and Statistics Outputs.

Note the use of a reporter to conditionally record metrics every other tick.

Note the use of pre experiment and post experiment commands to show the total elapsed time in the command center at the end of the experiment.

Click the OK button to finish viewing/editing the experiment.

The “Wolf Sheep Crossing” experiment illustrates the use of a reporter to capture interesting behavior, in this case the approximate periodicity of the simulation.

The “BehaviorSpace run 3 experiments” experiment shows how to use the subexperiment syntax (introduced in NetLogo 6.4.0) to run three different experiments. If you uncheck UPDATE VIEW, check UPDATE PLOTS AND MONITORS, and select 1 for SIMULTANEOUS RUNS IN PARALLEL the plots will show you how the experiments differ significantly. The results are also written to the COMMAND CENTER. Since there are list reporters as metrics there is no value to using the lists output format. Since there is only one repetition, there is no value to using statistics output format.

The “BehaviorSpace run 3 variable values per experiments” experiment is an example of how to use the subexperiment syntax to try multiple values of a variable non-combinatorially. Notice that default values need to be provided because the subexperiments only give the value of one of the variables explicitly.

The “BehaviorSpace subset” experiment makes use of the subexperiment syntax to run multiple combinations on a single line. Compare this to the combinatorial combination of the same variable values in the experiment “BehaviorSpace combinatorial”.

## THINGS TO TRY - BEHAVIORSPACE

Use the EXPORT button to save the "New BehaviorSpace Features" experiment as an XML file. Then open the Wolf Sheep Stride Inheritance model and use the IMPORT button to add the "New BehaviorSpace Features" experiment to the model. Run the experiment in this model.

Create your own experiments to explore how the different variables interact. What is the most dynamically stable combination you can find?

With the "New BehaviorSpace Features" experiment explore the effect on the total time of varying your choices for  UPDATE VIEW, UPDATE PLOTS AND MONITORS, and SIMULTANEOUS RUNS IN PARALLEL. Which combination is the fastest? The slowest?


### Reproducibility of Experiments

The experiment “New BehaviorSpace Features Reproducible” produces the same numerical results every time it is run. You can see this by running the experiment twice and saving spreadsheet output with two different names. If you compare the files they will differ only in the line that includes the time at which the experiment was run.

Contrast this to what happens when you do the same thing with the experiment “New BehaviorSpace Features”. In this case the results vary between runs because the NetLogo code includes primitives that introduce randomness, such as RANDOM, RANDOM-XCOR, RANDOM-YCOR and RANDOM-FLOAT. Sometimes it is desirable to have the same outcome each time the experiment is run, for example to show interesting behavior that only happens some of the time or to create a predictable lesson or demonstration. The output of the random functions is made reproducible by the line "random-seed (474 + behaviorspace-run-number)" in the setup command section.

What is the effect of each of the following changes on multiple experiment runs:

- Changing 474 to another number?
- Removing the addition of behaviorspace-run-number?
- Moving setup to before the random-seed line?
- Replacing the random-seed line with new-seed?

With the experiments “New BehaviorSpace Features” and “New BehaviorSpace Features Reproducible” explore whether output values change when you try the following actions:

- Use the slider to vary `wolf-gain-from-food`
- Use sliders to change other variables
- Use the chooser to select `sheep-wolves`
- Use the switch to turn on `show-energy?`

Output values for the experiment “New BehaviorSpace Features Reproducible” remain unchanged because the value of all Interface variables is specified. Note that when you start a new experiment the variables section specifies all the slider variables, but not any chooser or switch variables.

## RELATED MODELS

Look at Rabbits Grass Weeds for another model of interacting populations with different rules.

## CREDITS AND REFERENCES

Wilensky, U. & Reisman, K. (1998). Connected Science: Learning Biology through Constructing and Testing Computational Theories -- an Embodied Modeling Approach. International Journal of Complex Systems, M. 234, pp. 1 - 12. (The Wolf-Sheep-Predation model is a slightly extended version of the model described in the paper.)

Wilensky, U. & Reisman, K. (2006). Thinking like a Wolf, a Sheep or a Firefly: Learning Biology through Constructing and Testing Computational Theories -- an Embodied Modeling Approach. Cognition & Instruction, 24(2), pp. 171-209. http://ccl.northwestern.edu/papers/wolfsheep.pdf .

Wilensky, U., & Rand, W. (2015). An introduction to agent-based modeling: Modeling natural, social and engineered complex systems with NetLogo. Cambridge, MA: MIT Press.

Lotka, A. J. (1925). Elements of physical biology. New York: Dover.

Volterra, V. (1926, October 16). Fluctuations in the abundance of a species considered mathematically. Nature, 118, 558–560.

Gause, G. F. (1934). The struggle for existence. Baltimore: Williams & Wilkins.

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

* Wilensky, U. (1997).  NetLogo Wolf Sheep Predation model.  http://ccl.northwestern.edu/netlogo/models/WolfSheepPredation.  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE

Copyright 1997 Uri Wilensky.

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.

Commercial licenses are also available. To inquire about commercial licenses, please contact Uri Wilensky at uri@northwestern.edu.

This model was created as part of the project: CONNECTED MATHEMATICS: MAKING SENSE OF COMPLEX PHENOMENA THROUGH BUILDING OBJECT-BASED PARALLEL MODELS (OBPML).  The project gratefully acknowledges the support of the National Science Foundation (Applications of Advanced Technologies Program) -- grant numbers RED #9552950 and REC #9632612.

This model was converted to NetLogo as part of the projects: PARTICIPATORY SIMULATIONS: NETWORK-BASED DESIGN FOR SYSTEMS LEARNING IN CLASSROOMS and/or INTEGRATED SIMULATION AND MODELING ENVIRONMENT. The project gratefully acknowledges the support of the National Science Foundation (REPP & ROLE programs) -- grant numbers REC #9814682 and REC-0126227. Converted from StarLogoT to NetLogo, 2000.

<!-- 1997 2000 -->
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

shark
false
0
Polygon -7500403 true true 283 153 288 149 271 146 301 145 300 138 247 119 190 107 104 117 54 133 39 134 10 99 9 112 19 142 9 175 10 185 40 158 69 154 64 164 80 161 86 156 132 160 209 164
Polygon -7500403 true true 199 161 152 166 137 164 169 154
Polygon -7500403 true true 188 108 172 83 160 74 156 76 159 97 153 112
Circle -16777216 true false 256 129 12
Line -16777216 false 222 134 222 150
Line -16777216 false 217 134 217 150
Line -16777216 false 212 134 212 150
Polygon -7500403 true true 78 125 62 118 63 130
Polygon -7500403 true true 121 157 105 161 101 156 106 152

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
set model-version "sheep-wolves-grass"
set show-energy? false
setup
repeat 75 [ go ]
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="1-fish-population" repetitions="5" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>sum [ fishes-eaten ] of turtles / ticks</metric>
    <metric>sum [ fishes-eaten ] of turtles</metric>
    <metric>mean [fishes-eaten] of dolphins</metric>
    <runMetricsCondition>(count fishes) = 0</runMetricsCondition>
    <enumeratedValueSet variable="fish-reproduction">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speed-dolphin">
      <value value="1.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dolphin-vision-range">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fish-vision-range">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fish-reproduction-rate">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speed-fish">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-dolphins">
      <value value="10"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="initial-number-fish">
        <value value="50"/>
        <value value="100"/>
        <value value="200"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="2-dolphin-population" repetitions="5" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>sum [ fishes-eaten ] of turtles / ticks</metric>
    <metric>sum [ fishes-eaten ] of turtles</metric>
    <metric>mean [fishes-eaten] of dolphins</metric>
    <runMetricsCondition>(count fishes) = 0</runMetricsCondition>
    <enumeratedValueSet variable="fish-reproduction">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speed-dolphin">
      <value value="1.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dolphin-vision-range">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fish-vision-range">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fish-reproduction-rate">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speed-fish">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-fish">
      <value value="100"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="initial-number-dolphins">
        <value value="5"/>
        <value value="10"/>
        <value value="20"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="1-fish-population-reproduction" repetitions="5" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>sum [ fishes-eaten ] of turtles / ticks</metric>
    <metric>sum [ fishes-eaten ] of turtles</metric>
    <metric>mean [fishes-eaten] of dolphins</metric>
    <runMetricsCondition>(count fishes) = 0</runMetricsCondition>
    <enumeratedValueSet variable="fish-reproduction">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speed-dolphin">
      <value value="1.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dolphin-vision-range">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fish-vision-range">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fish-reproduction-rate">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speed-fish">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-dolphins">
      <value value="10"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="initial-number-fish">
        <value value="50"/>
        <value value="100"/>
        <value value="200"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="2-dolphin-population-reproduction" repetitions="5" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>sum [ fishes-eaten ] of turtles / ticks</metric>
    <metric>sum [ fishes-eaten ] of turtles</metric>
    <metric>mean [fishes-eaten] of dolphins</metric>
    <runMetricsCondition>(count fishes) = 0</runMetricsCondition>
    <enumeratedValueSet variable="fish-reproduction">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speed-dolphin">
      <value value="1.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dolphin-vision-range">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fish-vision-range">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fish-reproduction-rate">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speed-fish">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-fish">
      <value value="100"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="initial-number-dolphins">
        <value value="5"/>
        <value value="10"/>
        <value value="20"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="3-fish-speed" repetitions="5" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>sum [ fishes-eaten ] of turtles / ticks</metric>
    <metric>sum [ fishes-eaten ] of turtles</metric>
    <metric>mean [fishes-eaten] of dolphins</metric>
    <runMetricsCondition>(count fishes) = 0</runMetricsCondition>
    <enumeratedValueSet variable="fish-reproduction">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speed-dolphin">
      <value value="1.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dolphin-vision-range">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fish-vision-range">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fish-reproduction-rate">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speed-fish">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-dolphins">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-fish">
      <value value="100"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="speed-fish">
        <value value="1"/>
        <value value="1.2"/>
        <value value="1.5"/>
        <value value="1.7"/>
        <value value="2"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="3-dolphin-speed" repetitions="5" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>sum [ fishes-eaten ] of turtles / ticks</metric>
    <metric>sum [ fishes-eaten ] of turtles</metric>
    <metric>mean [fishes-eaten] of dolphins</metric>
    <runMetricsCondition>(count fishes) = 0</runMetricsCondition>
    <enumeratedValueSet variable="fish-reproduction">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dolphin-vision-range">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fish-vision-range">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fish-reproduction-rate">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speed-fish">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-dolphins">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-fish">
      <value value="100"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="speed-dolphin">
        <value value="1"/>
        <value value="1.2"/>
        <value value="1.5"/>
        <value value="1.7"/>
        <value value="2"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="3-fish-speed-reproduction" repetitions="5" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>sum [ fishes-eaten ] of turtles / ticks</metric>
    <metric>sum [ fishes-eaten ] of turtles</metric>
    <metric>mean [fishes-eaten] of dolphins</metric>
    <runMetricsCondition>(count fishes) = 0</runMetricsCondition>
    <enumeratedValueSet variable="fish-reproduction">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speed-dolphin">
      <value value="1.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dolphin-vision-range">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fish-vision-range">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fish-reproduction-rate">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-dolphins">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-fish">
      <value value="100"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="speed-fish">
        <value value="1"/>
        <value value="1.2"/>
        <value value="1.5"/>
        <value value="1.7"/>
        <value value="2"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
  <experiment name="3-dolphin-speed-reproduction" repetitions="5" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>sum [ fishes-eaten ] of turtles / ticks</metric>
    <metric>sum [ fishes-eaten ] of turtles</metric>
    <metric>mean [fishes-eaten] of dolphins</metric>
    <runMetricsCondition>(count fishes) = 0</runMetricsCondition>
    <enumeratedValueSet variable="fish-reproduction">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dolphin-vision-range">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fish-vision-range">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fish-reproduction-rate">
      <value value="150"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speed-fish">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-dolphins">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="initial-number-fish">
      <value value="100"/>
    </enumeratedValueSet>
    <subExperiment>
      <enumeratedValueSet variable="speed-dolphin">
        <value value="1"/>
        <value value="1.2"/>
        <value value="1.5"/>
        <value value="1.7"/>
        <value value="2"/>
      </enumeratedValueSet>
    </subExperiment>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
1
@#$#@#$#@

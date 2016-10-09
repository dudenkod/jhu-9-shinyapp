# jhu-9-shinyapp
A scientific project assisted by shinyapp visualisation

In this project I have decided to kill two crows with one stone.
For my computational chemistry project, where we study hole and electron mobility in photovoltaic organic functional materials,
it is extremely important to see how the interaction between adjacent molecules is evolving during molecular dynamics simulation. For more accurate simulation one needs a supercell simulation and therefore one gets a lot of pairwise transfer integrals to visualise. And here comes R together with shinyapp, whihc made my scientific life my easier.

How to use it?
It is very simple.
Just feed in the following file: trans_int-PIPI-SELECTED-sign.dat (see repository at github).
It is a list of interacting pair with their transfer integral values in meV units.
1)Histogram(HOMO/LUMO). It is showing how broad is the distribution of transfer integrals (sd value) and how far is the mean value from the experimental X-ray structure coordinates. The distribution shape tells a lot above conducting properties and mechanism of the material.
2)Evolution curve(HOMO/LUMO). It is showing how some selected pairs behave during MD simulation.
It is also a very important thing for describing hole/electron mobility in studied models.

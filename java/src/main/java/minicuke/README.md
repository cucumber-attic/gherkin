# Design ideas

## Results

* location in the form of stacktrace (also for passed steps)

## Reports

* Implement fancy report generators in single language (go?) to reduce dev overhead?

## Misc

* Need to randomise TestCases.
* Pluggable ordering so we can order/partition based on:
  * TCP (rerun.txt, Grigoruta style, previous JSON report - retire rerun.txt)
  * Duration of previous run - useful for distributed runs

## Master's thesis "Robust Generalizations of Stochastic Derivative-Free Optimization"


### Introduction, TOC
This repository contains code and data of my master's thesis. More precisely,

* [bayesian-sensitivity-analysis](bayesian-sensitivity-analysis) has everything to reconduct the Analysis in the thesis' section 4 
* [imprecise-bayes-opt-parallel](imprecise-bayes-opt-parallel) contains implementation of parallel hedging and batch-wise speed-up prior-mean-robust BO (sections 6.3, 6.4 in thesis)
* [imprecise-bayes-opt-plug-in](imprecise-bayes-opt-plug-in) contains implementation of GLCB (section 6.5)
* [imp-BO_benchmarking](imp-BO_benchmarking) provides files for simulation experiments (section 6.6), see setup below
* [weighted-ML-GP](weighted-ML-GP) contains implementation of weighted ML estimation of prior mean parameter (section 9.2) as well as files to rerun experiments (section 9.3)
* [univariate-benchmark-functions](univariate-benchmark-functions) contains a selection of benchmark functions from R packages **smoof** and **soobench** that are used throughout the project
* files in [data](data) allow recreating visualizations of data and functions used in the benchmark experiments, see below


### Tested with

- R 4.0.3

on
- Ubuntu 20.04
- Windows 10 Build 19042 (partly)
- MacOS (only visualization)


### Setup

First and foremost, please clone this repo (and install required packages as indicated by your IDE)

In order to reproduce the thesis' key results for glcb on graphene data, please 

* source [this file](imp-BO_benchmarking/imp-BO-kapton-benchmarking-glcb-graphene.R) to kick off the simulation study (estimated time on 64-bit-core (linux gnu): 10h)
* results are saved automatically
* source [this file](imp-BO_benchmarking/viz-glcb-all-comparisons.R) to visualize the retrieved results

Or, alternatively, for glcb on synthetic function, please

* [kick off simulation](imp-BO_benchmarking/imp-BO-synthetic-benchmarking-glcb-only-1.R)
* [visualize your simulation's results](imp-BO_benchmarking/imp-BO-benchmarking-synthetic-glcb-vs-ei-lcb-viz.R)

Note that it's also possible to direclty visualize the stored results by only running the visualization files. In case of own simulation, these stored results will be overwritten.

### Data

Find files to read in data and create target functions in folder [data](data). 
E.g. source [data/data-heartbeat-1.R](data/data-heartbeat-1.R) to read in heartbeat time series from http://ecg.mit.edu/time-series/.
Or run [data/make-heartbeat-1.R](data/make-heartbeat-1.R) to directly retrieve heartbeat target function, including a ggplot2-visualization.



## Prior-RObust Bayesian Optimization (PROBO)


### Introduction, TOC
This repository contains Prior-RObust Bayesian Optimization (PROBO) as introduced in our paper "Accounting for Gaussian Process Imprecision in Bayesian Optimization" (Rodemann, Augustin). More precisely,

* [PROBO](PROBO) contains implementation of PROBO
* [imp-BO_benchmarking](imp-BO_benchmarking) provides files for experiments (section 4), in order to reproduce results, see setup below
* files in [data](data) allow recreating visualizations of data and functions used in the benchmark experiments, see below


### Tested with

- R 4.0.3
- R 4.1.6
- R 3.6.3

on
- Linux Ubuntu 20.04
- Linux Debian 10
- Windows 10 Build 20H2 
- MacOS (only visualization)


### Setup

First and foremost, please clone this repo (and install required packages as indicated by your IDE)

In order to reproduce the thesis' key results for glcb on graphene data, please 

* source [this file](imp-BO_benchmarking/imp-BO-kapton-benchmarking-glcb-graphene.R) to kick off the simulation study (estimated time on 64-bit-core (linux gnu): 10h)
* results are saved automatically
* source [this file](imp-BO_benchmarking/viz-glcb-all-comparisons.R) to visualize the retrieved results

Note that it's also possible to direclty visualize the stored results by only running the visualization files. In case of own simulation, these stored results will be overwritten.

### Data

Find files to read in data and create target functions in folder [data](data). 
E.g. source [data/make-kapton-rf.R](data/make-kapton-rf.R) to read in graphene data (source [https://www.sciencedirect.com/science/article/abs/pii/S0008622320305285](is here)) and reproduce figure 1 of the paper



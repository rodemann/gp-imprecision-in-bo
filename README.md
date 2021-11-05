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

In order to reproduce the papers' **figure 2** (and visualizations of further results not included but only mentioned in the paper on page 10) 

* source [this file](imp-BO_benchmarking/viz-probo-all-comparisons.R)  

In order to reproduce the papers' key results for PROBO on graphene data, please 

* source [this file](imp-BO_benchmarking/main-PROBO-benchmarking-graphene.R) to kick off the simulation study (estimated time on 64-bit-core (linux gnu): 11h)
* results are saved automatically
* source [this file](imp-BO_benchmarking/viz-glcb-all-comparisons-new.R) to visualize the retrieved results


### Data

Find files to read in data and create target functions in folder [data](data). 
E.g. source [data/make-kapton-rf.R](data/make-kapton-rf.R) to read in graphene data (source [is here](https://www.sciencedirect.com/science/article/abs/pii/S0008622320305285)) and reproduce **figure 1** of the paper



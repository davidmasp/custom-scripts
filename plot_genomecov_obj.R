#!/usr/bin/env Rscript

# Usage:
# Rscript plot_genomecov_obj.R genome_cov_file.bg sampleName

# Description:
# Plot a coverage histogram plot from the popular tool 
# genomecov from bedtools

# params ------------------------------------------------------------------

args = commandArgs(trailingOnly = TRUE)
file_name = args[1]
sample_name = args[2]

# imports -----------------------------------------------------------------

library(magrittr)
library(ggplot2)

deps = c("cowplot",
         "ggplot2",
         "glue",
         "magrittr",
         "readr",
         "scales")

stopifnot(sapply(deps, requireNamespace))

# script ------------------------------------------------------------------

dat = readr::read_tsv(file_name,col_names = F)
dat = dplyr::filter(dat,X1 == "genome")
dat$sample = sample_name
dat = dat[order(dat$X2,decreasing = T),]

dat$cumSum = cumsum(dat$X3)
dat$cumSum_perc = cumsum(dat$X5)

median_cov = dat[dat$cumSum_perc > 0.5,"X2"] %>% max
X30 = dat[dat$X2 == 30,][["cumSum_perc"]] %>% scales::percent()
X15 = dat[dat$X2 == 15,][["cumSum_perc"]] %>% scales::percent()
title = glue::glue("sample: {sample_name} / mCOV: {median_cov}X / 30X: {X30} / 15X: {X15}")

# this covers the 99% of the distribution
max_val = dat[dat$cumSum_perc < 0.01,"X2"] %>% min

p1 = dat %>% 
  ggplot(aes(x = X2, y = X3)) + 
  geom_line() +
  scale_y_continuous(labels = scales::comma) +
  coord_cartesian(xlim = c(1,max_val)) +
  theme_classic() +
  labs(title = title,
       x = "Coverage",
       y = "Total (bp)")

p2 = dat %>% 
  ggplot(aes(x = X2, y =cumSum_perc )) +
  geom_line() + 
  scale_y_continuous(labels = scales::percent) +
  coord_cartesian(xlim = c(1,max_val)) +
  theme_classic() +
  labs(x = "Coverage",
       y = "Cumulative Percentage")

fp = cowplot::plot_grid(p1,p2, ncol = 1)

outname = glue::glue("{sample_name}_genomecov_hist.pdf")
ggsave(filename = outname,
       plot = fp,
       width = 5,
       height = 8)


# sfguide-getting-started-with-time-series-analytics-with-pricing-data-on-snowflake
## Overview

This guide explores several time series features using FactSet Tick Data, including TIME_SLICE, ASOF_JOIN, and RANGE BETWEEN for insights into trade data. Aggregating time-series data through downsampling reduces data size and storage needs, using functions like TIME_SLICE and DATE_TRUNC for efficiency. ASOF JOIN simplifies joining time-series tables, matching trades with the closest previous quote, ideal for transaction-cost analysis in financial trading. Windowed aggregate functions, such as moving averages using the RANGE BETWEEN window frame, allow trend analysis over time, accommodating data gaps for flexible rolling calculations.

## Step-By-Step Guide

For prerequisites, environment setup, step-by-step guide and instructions, please refer to the [QuickStart Guide]().

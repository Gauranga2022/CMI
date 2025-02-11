# Assignment 2: Experiment Tracking (due 25 Feb 2025)
-----------------------------------------------------------------

## 1. Data Version Control

In `prepare.ipynb` track the versions of data using `dvc`

- Load the raw data into `raw_data.csv` and save the split data into `train.csv` / `validation.csv` / `test.csv`
- Update train/validation/test split by choosing a different random seed
- Checkout the first version (before update) using `dvc` and print the distribution of the target variable (number of 0s and number of 1s) in `train.csv`, `validation.csv`, and `test.csv`
- Checkout the updated version using `dvc` and print the distribution of the target variable in `train.csv`, `validation.csv`, and `test.csv`
- **Bonus:** (Decouple compute and storage) Track the data versions using Google Drive as storage

## 2. Model Version Control and Experiment Tracking

In `train.ipynb` track the experiments and model versions using `mlflow`

- Build, track, and register 3 benchmark models using MLflow
- Checkout and print AUCPR for each of the three benchmark models

## References

### Data Version Control
- [DVC Documentation - Data Versioning](https://dvc.org/doc/start/data-management/data-versioning)
- [Real Python - Python Data Version Control](https://realpython.com/python-data-version-control/)
- [Managing Files in Google Drive with Python](https://towardsdatascience.com/how-to-manage-files-in-google-drive-with-python-d26471d91ecd)
- [MadeWithML - Versioning](https://madewithml.com/courses/mlops/versioning/)

### ML Experiment Tracking
- [MLflow Tracking Docs](https://mlflow.org/docs/latest/tracking.html)
- [MLflow Quickstart](https://mlflow.org/docs/latest/getting-started/intro-quickstart/index.html)
- [How We Track ML Experiments with MLflow](https://www.datarevenue.com/en-blog/how-we-track-machine-learning-experiments-with-mlflow)
- [Experiment Tracking with MLflow in 10 Minutes](https://towardsdatascience.com/experiment-tracking-with-mlflow-in-10-minutes-f7c2128b8f2c)
- [MadeWithML - Experiment Tracking](https://madewithml.com/courses/mlops/experiment-tracking/)

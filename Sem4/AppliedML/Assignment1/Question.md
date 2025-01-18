# Assignment 1: Prototype (Due 30 Jan 2025)

## Build a Prototype for SMS Spam Classification

Develop a prototype for classifying SMS messages as spam or not spam. Follow the steps below:

### Instructions

#### `prepare.ipynb`
- Write functions to:
  - Load the data from a given file path.
  - Preprocess the data (if needed).
  - Split the data into train/validation/test sets.
  - Store the splits as `train.csv`, `validation.csv`, and `test.csv`.

#### `train.ipynb`
- Write functions to:
  - Fit a model on the training data.
  - Score a model on a given dataset.
  - Evaluate the model predictions.
  - Validate the model:
    - Fit the model on the training data.
    - Score on training and validation data.
    - Evaluate performance on training and validation data.
  - Fine-tune hyperparameters using training and validation sets (if necessary).
  - Score three benchmark models on the test data and select the best one.

### Resources
- SMS Spam Data: [UCI SMS Spam Collection](https://archive.ics.uci.edu/ml/datasets/sms+spam+collection)
- Python Guide: [Radim Řehůřek's Data Science Guide](https://radimrehurek.com/data_science_python/)
- Machine Learning Concepts: [An Introduction to Statistical Learning (Chapters 1-3)](https://www.statlearning.com/)
- Solution Design Example: Refer to the example covered in class.

### Solution Structure

#### `prepare.ipynb`
1. Load the SMS spam dataset using a function that reads data from the provided file path.
2. Preprocess the data by:
   - Converting text to lowercase.
   - Removing punctuation and special characters.
   - Tokenizing and lemmatizing (if required).
3. Split the data into training, validation, and test sets (e.g., 70%-15%-15%).
4. Save the split datasets as CSV files: `train.csv`, `validation.csv`, and `test.csv`.

#### `train.ipynb`
1. Define a function to train models using the training dataset.
2. Create a scoring function to evaluate model predictions against true labels using metrics like accuracy, precision, recall, and F1-score.
3. Validate the model by:
   - Training it on the training data.
   - Evaluating it on both training and validation datasets.
4. Fine-tune hyperparameters (e.g., using grid search or random search) for optimal performance.
5. Test three different models (e.g., Logistic Regression, Random Forest, and SVM) on the test dataset.
6. Select the best-performing model based on evaluation metrics.

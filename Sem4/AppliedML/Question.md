<!DOCTYPE html>
<html>
<head>
    <title>SMS Spam Classification Assignment</title>
</head>
<body>
    <h1>Assignment 1: Prototype for SMS Spam Classification</h1>
    <h2>Due Date: 30 Jan 2025</h2>

    <h2>Task Description</h2>
    <p>Build a prototype for SMS spam classification.</p>

    <h3>Requirements</h3>
    <h4>1. Prepare.ipynb</h4>
    <ul>
        <li>Write the functions to:
            <ul>
                <li>Load the data from a given file path.</li>
                <li>Preprocess the data (if needed).</li>
                <li>Split the data into train/validation/test sets.</li>
                <li>Store the splits in the following files:
                    <ul>
                        <li><code>train.csv</code></li>
                        <li><code>validation.csv</code></li>
                        <li><code>test.csv</code></li>
                    </ul>
                </li>
            </ul>
        </li>
    </ul>

    <h4>2. Train.ipynb</h4>
    <ul>
        <li>Write the functions to:
            <ul>
                <li>Fit a model on train data.</li>
                <li>Score a model on given data.</li>
                <li>Evaluate the model predictions.</li>
                <li>Validate the model.</li>
                <li>Fit on train data.</li>
                <li>Score on train and validation data.</li>
                <li>Evaluate on train and validation data.</li>
                <li>Fine-tune hyperparameters using train and validation data (if necessary).</li>
                <li>Score three benchmark models on test data and select the best one.</li>
            </ul>
        </li>
    </ul>

    <h3>Notes</h3>
    <ul>
        <li>You may download the SMS spam data from <a href="https://archive.ics.uci.edu/ml/datasets/sms+spam+collection" target="_blank">this link</a>.</li>
        <li>You may refer to <a href="https://radimrehurek.com/data_science_python/" target="_blank">this resource</a> for building a prototype.</li>
        <li>You may refer to the first three chapters of <a href="https://www.statlearning.com/" target="_blank">this book</a> for basic ML concepts.</li>
        <li>You may refer to the Solution Design example covered in the class as a guideline for experiment design.</li>
    </ul>

    <h2>Solution</h2>

    <h3>Prepare.ipynb</h3>
    <ol>
        <li><b>Load Data:</b> A function is written to load the data from a given file path using <code>pandas.read_csv()</code>.</li>
        <li><b>Preprocess Data:</b> Text data is cleaned by removing stopwords, punctuation, and applying tokenization and stemming.</li>
        <li><b>Split Data:</b> The dataset is split into train (70%), validation (15%), and test (15%) sets using <code>sklearn.model_selection.train_test_split</code>.</li>
        <li><b>Save Splits:</b> The splits are saved as <code>train.csv</code>, <code>validation.csv</code>, and <code>test.csv</code> using <code>pandas.DataFrame.to_csv()</code>.</li>
    </ol>

    <h3>Train.ipynb</h3>
    <ol>
        <li><b>Fit Model:</b> A function trains a model (e.g., Logistic Regression) using the train data.</li>
        <li><b>Score Model:</b> A function calculates model scores (e.g., accuracy, precision, recall) on the provided data.</li>
        <li><b>Evaluate Model:</b> A function evaluates predictions using metrics like confusion matrix and classification report.</li>
        <li><b>Validate Model:</b> Cross-validation is applied on train and validation data to select the best hyperparameters.</li>
        <li><b>Fine-Tune Hyperparameters:</b> Grid search or random search is implemented for hyperparameter tuning.</li>
        <li><b>Score on Test Data:</b> Three benchmark models (e.g., Logistic Regression, Random Forest, Naive Bayes) are evaluated, and the best model is selected based on test data performance.</li>
    </ol>

    <h3>Final Outputs</h3>
    <ul>
        <li><code>prepare.ipynb</code>: Data preparation notebook with split files.</li>
        <li><code>train.ipynb</code>: Model training, evaluation, and benchmarking notebook.</li>
        <li>Selected best model and its metrics on test data.</li>
    </ul>
</body>
</html>

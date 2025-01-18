<!DOCTYPE html>
<html>
<head>
    <title>Assignment 1: SMS Spam Classification Prototype</title>
</head>
<body>
    <h1>Assignment 1: Prototype (Due: 30 Jan 2025)</h1>
    <h2>Build a Prototype for SMS Spam Classification</h2>
    <p>Develop a prototype for classifying SMS messages as spam or not spam. Follow the steps below:</p>

    <h3>Instructions</h3>
    <h4>prepare.ipynb</h4>
    <ul>
        <li>Write functions to:
            <ul>
                <li>Load the data from a given file path.</li>
                <li>Preprocess the data (if needed).</li>
                <li>Split the data into train/validation/test sets.</li>
                <li>Store the splits as <code>train.csv</code>, <code>validation.csv</code>, and <code>test.csv</code>.</li>
            </ul>
        </li>
    </ul>

    <h4>train.ipynb</h4>
    <ul>
        <li>Write functions to:
            <ul>
                <li>Fit a model on the training data.</li>
                <li>Score a model on a given dataset.</li>
                <li>Evaluate the model predictions.</li>
                <li>Validate the model:
                    <ul>
                        <li>Fit the model on the training data.</li>
                        <li>Score on training and validation data.</li>
                        <li>Evaluate performance on training and validation data.</li>
                    </ul>
                </li>
                <li>Fine-tune hyperparameters using training and validation sets (if necessary).</li>
                <li>Score three benchmark models on the test data and select the best one.</li>
            </ul>
        </li>
    </ul>

    <h3>Resources</h3>
    <ul>
        <li>SMS Spam Data: <a href="https://archive.ics.uci.edu/ml/datasets/sms+spam+collection" target="_blank">UCI SMS Spam Collection</a></li>
        <li>Python Guide: <a href="https://radimrehurek.com/data_science_python/" target="_blank">Radim Řehůřek's Data Science Guide</a></li>
        <li>Machine Learning Concepts: <a href="https://www.statlearning.com/" target="_blank">An Introduction to Statistical Learning (Chapters 1-3)</a></li>
        <li>Solution Design Example: Refer to the example covered in class.</li>
    </ul>

    <h3>Solution Structure</h3>
    <h4>prepare.ipynb</h4>
    <ol>
        <li>Load the SMS spam dataset using a function that reads data from the provided file path.</li>
        <li>Preprocess the data by:
            <ul>
                <li>Converting text to lowercase.</li>
                <li>Removing punctuation and special characters.</li>
                <li>Tokenizing and lemmatizing (if required).</li>
            </ul>
        </li>
        <li>Split the data into training, validation, and test sets (e.g., 70%-15%-15%).</li>
        <li>Save the split datasets as CSV files: <code>train.csv</code>, <code>validation.csv</code>, and <code>test.csv</code>.</li>
    </ol>

    <h4>train.ipynb</h4>
    <ol>
        <li>Define a function to train models using the training dataset.</li>
        <li>Create a scoring function to evaluate model predictions against true labels using metrics like accuracy, precision, recall, and F1-score.</li>
        <li>Validate the model by:
            <ul>
                <li>Training it on the training data.</li>
                <li>Evaluating it on both training and validation datasets.</li>
            </ul>
        </li>
        <li>Fine-tune hyperparameters (e.g., using grid search or random search) for optimal performance.</li>
        <li>Test three different models (e.g., Logistic Regression, Random Forest, and SVM) on the test dataset.</li>
        <li>Select the best-performing model based on evaluation metrics.</li>
    </ol>

    <p>Follow these steps to implement your solution and ensure the prototype meets the requirements.</p>
</body>
</html>

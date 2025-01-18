</head>
<body>

<h1>Assignment 1: Prototype</h1>
<p class="due-date"><strong>Due Date:</strong> 30 Jan 2025</p>

<p>In this assignment, you will build a prototype for SMS spam classification. The workflow is divided into two main notebooks:</p>

<ol>
    <li><code>prepare.ipynb</code></li>
    <li><code>train.ipynb</code></li>
</ol>

<h2>1. <code>prepare.ipynb</code> Tasks</h2>
<ul>
    <li><strong>Load the data</strong> from a specified file path.</li>
    <li><strong>Preprocess the data</strong> if needed (e.g., removing special characters, converting to lowercase, etc.).</li>
    <li><strong>Split the data</strong> into train, validation, and test sets.</li>
    <li><strong>Store each split</strong> in separate CSV files: <code>train.csv</code>, <code>validation.csv</code>, and <code>test.csv</code>.</li>
</ul>

<h2>2. <code>train.ipynb</code> Tasks</h2>
<ul>
    <li><strong>Fit a model</strong> on the training data.</li>
    <li><strong>Score a model</strong> on any given data (e.g., training, validation, test).</li>
    <li><strong>Evaluate the model predictions</strong> (e.g., accuracy, precision, recall, F1-score).</li>
    <li><strong>Validation step</strong>:
        <ul>
            <li>Fit on train.</li>
            <li>Score on train and validation.</li>
            <li>Evaluate on train and validation.</li>
        </ul>
    </li>
    <li><strong>Fine-tune hyperparameters</strong> using the combined knowledge from train and validation sets (if necessary).</li>
    <li><strong>Final step</strong>: 
        <ul>
            <li>Score three benchmark models on the test data.</li>
            <li>Select the best model.</li>
        </ul>
    </li>
</ul>

<h2>Notes</h2>
<div class="note">
    <p>You may download the SMS spam data from 
        <a href="https://archive.ics.uci.edu/ml/datasets/sms+spam+collection" target="_blank" rel="noopener noreferrer">
        https://archive.ics.uci.edu/ml/datasets/sms+spam+collection</a>.
    </p>
    <p>You may refer to <a href="https://radimrehurek.com/data_science_python/" target="_blank" rel="noopener noreferrer">
    https://radimrehurek.com/data_science_python/</a> for building a prototype.</p>
    <p>You may refer to the first three chapters of <a href="https://www.statlearning.com/" target="_blank" rel="noopener noreferrer">
    https://www.statlearning.com/</a> for basic ML concepts.</p>
    <p>You may also refer to the <em>Solution Design</em> example covered in class as a guideline for experiment design.</p>
</div>

<h2>Suggested Structure</h2>
<ul>
    <li><strong>Repository Structure</strong>
        <pre>
project/
├─ prepare.ipynb
├─ train.ipynb
├─ data/
│  ├─ raw/
│  └─ processed/
├─ train.csv
├─ validation.csv
├─ test.csv
└─ README.md
        </pre>
    </li>
    <li><strong>Workflow Summary</strong>
        <ol>
            <li>Download and place data in <code>data/raw/</code>.</li>
            <li>Use <code>prepare.ipynb</code> to preprocess and split data into <code>train.csv</code>, <code>validation.csv</code>, and <code>test.csv</code>.</li>
            <li>Use <code>train.ipynb</code> to build, evaluate, and select the best model.</li>
        </ol>
    </li>
</ul>

<h2>Deliverables</h2>
<ul>
    <li>A functional <code>prepare.ipynb</code> notebook with clear data preparation steps.</li>
    <li>A functional <code>train.ipynb</code> notebook demonstrating model training, validation, hyperparameter tuning, and final selection of the best model.</li>
    <li>The final chosen model’s test set evaluation metrics.</li>
    <li>A brief discussion of results and any improvements or next steps you might consider.</li>
</ul>

</body>
</html>

### Narendra C MDS202336 <br> Siddhesh Maheshwari MDS202347 <br> Gauranga Kumar Baishya MDS202325

---

<h1 align = 'center'> Assignment 02 Report </h1>

### Task 1

* Did data cleaning by removing unwanted columns, renamed the column names to `Category` and `Messages`.
* Checked for Null values in the dataset there were ** no null value instances** in the dataset.
* Feature engineered a new column called `message_length`. Adding a message_length column can improve spam detection by capturing patterns in message size. Spam messages often have distinct lengths, either unusually short or long, which helps differentiate them from typical messages.
* Found out that the dataset was imbalanced. Obviously there were more `ham` messaged than `spam`. In order to address this class imbalance i made use of Undersampling technique.
* Created a Vocabulary of 10,000 words for the messages, also created one hot vec for all the words in the vocab.
* Considered the `Messages` as feature set and `Category` as Target.
* I trained on this using RNN and LSTM both models reached high training accuracy, but **LSTM showed a slight advantage** in validation accuracy across epochs.
* The **RNN model reached ~95.3%** accuracy, while the **LSTM achieved ~98.4%**.**LSTM consistently outperformed RNN**, with a **96% test accuracy** for LSTM versus **93.8% for RNN**, indicating better generalization.

### Task 2

* Developed RNN and LSTM models to predict the second half of an SMS given the first half, with an `<END>` token to signal the end of the output.
* Text cleaning included tokenization, removal of special characters, and lowercasing.
* Each SMS was split into two halves, where the first half was used as input and the second half as the target.
* Tokenized SMS messages were converted into integer sequences and padded to ensure consistent sequence lengths across inputs and targets.
* **RNN Model**: Consisted of Embedding, Simple RNN, Dropout, and Dense layers.
* **LSTM Model**: Consisted of Embedding, LSTM, Dropout, and Dense layers, using similar parameters to maintain comparability.
* Both models were trained with sparse categorical cross-entropy loss and evaluated on a test set, achieving comparable accuracies (~90.5%).
* The LSTM model displayed slightly better convergence, producing more coherent message continuations than the RNN model.
* **LSTM** was found to be more effective than RNN for sequential text generation, as it better preserved context over longer sequences.


### Task 3
* Loaded the Fashion MNIST dataset, which consists of 70,000 grayscale images of clothing items, and split it into training and test sets for model training and evaluation.
* Normalized the image pixel values to a range between -1 and 1 for better convergence during training. Labels were one-hot encoded to facilitate class-specific image generation.

* **Model Architecture**:

   -  **Generator**: Designed a neural network that takes a random noise vector (latent code) and class label as inputs, producing an image that corresponds to the specified label. The architecture typically includes dense layers, reshaping layers, and transposed convolutions.
    - **Discriminator**: Built a neural network that takes both an image and a class label as input to classify the image as real or fake. This model usually consists of convolutional layers followed by dense layers for classification.

* Implemented the GAN training loop where the generator and discriminator are trained alternately

*  Utilized binary cross-entropy loss for both the generator and discriminator. The generator's loss encourages it to produce images that are classified as real by the discriminator, while the discriminator's loss focuses on correctly classifying real and fake images.

*  After training, generated images were created by providing random noise vectors and specific class labels to the generator. This allowed the generation of images corresponding to different clothing categories.

* For each class in the dataset, displayed four examples of generated images, illustrating the generator's ability to produce distinct clothing items based on the class label.
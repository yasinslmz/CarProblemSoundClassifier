import pickle
import json
import numpy as np
from sklearn.model_selection import train_test_split
import keras as keras
import matplotlib.pyplot as plt
import keras.layers,keras.optimizers
import pickle
import librosa
import librosa.feature
data_path = "data.json"

def load_data(data_path):
    """Loads training dataset from json file.
        :param data_path (str): Path to json file containing data
        :return X (ndarray): Inputs
        :return y (ndarray): Targets
    """

    with open(data_path, "r") as fp:
        data = json.load(fp)

    X = np.array(data["melspectrogram"])
    y = np.array(data["labels"])
    return X, y

def predict(model, X):
    """Predict a single sample using the trained model
    :param model: Trained classifier
    :param X: Input data
    :param y (int): Target
    """

    # add a dimension to input data for sample - model.predict() expects a 4d array in this case
    X = X[np.newaxis, ...] # array shape (1, 130, 13, 1)

    # perform prediction
    prediction = model.predict(X)

    # get index with max value
    predicted_index = np.argmax(prediction, axis=1)
    #print("Target: {}, Predicted label: {}".format(str(y), str(predicted_index[0])))
    print("Predicted label: {}".format(str(predicted_index[0])))
    return [str(predicted_index[0])]

def prepare_datasets(test_size, validation_size):
    """Loads data and splits it into train, validation and test sets.
    :param test_size (float): Value in [0, 1] indicating percentage of data set to allocate to test split
    :param validation_size (float): Value in [0, 1] indicating percentage of train set to allocate to validation split
    :return X_train (ndarray): Input training set
    :return X_validation (ndarray): Input validation set
    :return X_test (ndarray): Input test set
    :return y_train (ndarray): Target training set
    :return y_validation (ndarray): Target validation set
    :return y_test (ndarray): Target test set
    """

    # load data
    X, y = load_data(data_path)

    # create train, validation and test split
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=test_size)
    X_train, X_validation, y_train, y_validation = train_test_split(X_train, y_train, test_size=validation_size)

    # add an axis to input sets
    X_train = X_train[..., np.newaxis]
    X_validation = X_validation[..., np.newaxis]
    X_test = X_test[..., np.newaxis]

    return X_train, X_validation, X_test, y_train, y_validation, y_test

def soundtoarray():
    SAMPLE_RATE = 22050
    n_fft = 1024
    hop_length = 512
    signal, sample_rate = librosa.load("sound.mp3", sr=SAMPLE_RATE)

    S = librosa.feature.melspectrogram(y=signal, sr=sample_rate, n_mels=128, n_fft=n_fft, hop_length=hop_length,
                                       fmax=11025)
    S_dB = librosa.power_to_db(S, ref=np.max)
    S_dB = S_dB.T
    if (S_dB.shape == (87, 128)):
        xtest = S_dB
        xtest = xtest[..., np.newaxis]
        return xtest
    else:
        print(S_dB.shape)



def analizbaslat():
    # X_train, X_validation, X_test, y_train, y_validation, y_test = prepare_datasets(0.25, 0.2)
    filename = 'finalized_model.sav'
    loaded_model = pickle.load(open(filename, 'rb'))
    # evaluate model on test set
    # test_loss, test_acc = loaded_model.evaluate(X_test, y_test, verbose=2)
    # print('\nTest accuracy:', test_acc)

    X_to_predict=soundtoarray()

    # pick a sample to predict from the test set
    # X_to_predict = X_test[100]
    # y_to_predict = y_test[100]
    # tahmin = predict(loaded_model, X_to_predict, y_to_predict)
    # predict sample
    tahmin=predict(loaded_model, X_to_predict)
    print(tahmin)
    return tahmin


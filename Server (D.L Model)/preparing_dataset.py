import csv
import math

import pandas as pd
import librosa.feature

import random
import librosa
import numpy as np
import soundfile as sf

#Importing library and thir function
import librosa
import soundfile as sf
import numpy as np
import matplotlib.pyplot as plt
import librosa.display


 # MEL SPECTROGRAM OF SOUND CLIPS
# y, sr = librosa.load("sesler/brake_sounds/scbrake0.mp3",sr=22050)
#
# # Passing through arguments to the Mel filters
# S = librosa.feature.melspectrogram(y=y, sr=sr, n_mels=128,
#                                     fmax=11025)
#
# fig, ax = plt.subplots()
# S_dB = librosa.power_to_db(S,ref=0.01)
# # for i in range(len(S_dB)):
# #     for j in range(len(S_dB[i])):
# #         if S_dB[i,j]<-15:
# #             S_dB[i,j]=-70
#
# print(S_dB.shape)
# img = librosa.display.specshow(S_dB, x_axis='time',
#                          y_axis='mel', sr=sr,
#                          fmax=11025, ax=ax)
# fig.colorbar(img, ax=ax, format='%+2.0f dB')
# ax.set(title='Mel-frequency spectrogram')
# plt.show()
# #

import os

datapath="sesler/"

import json
import os
import math
import librosa

DATASET_PATH = "sesler/"
JSON_PATH = "data.json"
SAMPLE_RATE = 22050

def save_mel(dataset_path, json_path, n_fft=1024, hop_length=512):
    """Extracts MFCCs from music dataset and saves them into a json file along witgh genre labels.

        :param dataset_path (str): Path to dataset
        :param json_path (str): Path to json file used to save MFCCs
        :param num_mfcc (int): Number of coefficients to extract
        :param n_fft (int): Interval we consider to apply FFT. Measured in # of samples
        :param hop_length (int): Sliding window for FFT. Measured in # of samples
        :param: num_segments (int): Number of segments we want to divide sample tracks into
        :return:
        """

    # dictionary to store mapping, labels, and MFCCs
    data = {
        "mapping": [],
        "labels": [],
        "melspectrogram": []
    }

    # loop through all genre sub-folder
    for i, (dirpath, dirnames, filenames) in enumerate(os.walk(dataset_path)):

        # ensure we're processing a genre sub-folder level
        if dirpath is not dataset_path:

            # save genre label (i.e., sub-folder name) in the mapping
            semantic_label = dirpath.split("/")[-1]
            data["mapping"].append(semantic_label)
            print("\nProcessing: {}".format(semantic_label))

            # process all audio files in genre sub-dir
            for f in filenames:

                # load audio file
                file_path = os.path.join(dirpath, f)
                signal, sample_rate = librosa.load(file_path, sr=SAMPLE_RATE)

                S = librosa.feature.melspectrogram(y=signal, sr=sample_rate, n_mels=128,n_fft=n_fft,hop_length=hop_length,
                                                   fmax=11025)
                S_dB = librosa.power_to_db(S, ref=np.max)
                S_dB=S_dB.T
                if(S_dB.shape==(87,128)):
                    data["melspectrogram"].append(S_dB.tolist())
                    data["labels"].append(i - 1)
                    # store only mfcc feature with expected number of vectors
                    print("{},{}".format(file_path, S_dB.shape))
            print(len(data["labels"]))


    # save MFCCs to json file
    with open(json_path, "w") as fp:
        json.dump(data, fp, indent=4)


if __name__ == "__main__":
    save_mel(DATASET_PATH, JSON_PATH)


#
#
#

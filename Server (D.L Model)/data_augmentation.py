import random
import librosa.display
import matplotlib.pyplot as plt
import soundfile as sf
import os
import librosa
import os
import numpy as np
import soundfile as sf



directory="yenisesler/rod"


    #### Data Augmentation Methods ######

def add_white_noise(signal, noise_percentage_factor):
    noise = np.random.normal(0, signal.std(), signal.size)
    augmented_signal = signal + noise * noise_percentage_factor
    return augmented_signal

def pitch_scale(signal, sr, num_semitones):
    """Pitch scaling implemented with librosa:
    https://librosa.org/doc/main/generated/librosa.effects.pitch_shift.html?highlight=pitch%20shift#librosa.effects.pitch_shift
    """
    return librosa.effects.pitch_shift(signal, sr, num_semitones)


def random_gain(signal, min_factor=1.25, max_factor=1.46):
    gain_rate = random.uniform(min_factor, max_factor)
    augmented_signal = signal * gain_rate
    return augmented_signal




if __name__ == "__main__":
    j=180  #devam edecek sayıyı seç ornek alternator 22
    for filename in os.listdir(directory):
        print(filename)
        signal, sr = librosa.load("yenisesler/rod/"+str(filename), sr=22050)
        sf.write("sesler/rod_knock_sounds/rodknock" + str(j) + ".mp3", signal, sr)
        j += 1
        augmented_signal=add_white_noise(signal,0.14)
        sf.write("sesler/rod_knock_sounds/rodknock"+str(j)+".mp3", augmented_signal, sr)
        augmented_signal = pitch_scale(signal, sr, 2)
        j+=1
        sf.write("sesler/rod_knock_sounds/rodknock" + str(j)+".mp3", augmented_signal, sr)
        augmented_signal = random_gain(signal)
        j += 1
        sf.write("sesler/rod_knock_sounds/rodknock" + str(j)+".mp3", augmented_signal, sr)
        j += 1



    ### Show waveform of signal ###
# def _plot_signal_and_augmented_signal(signal, augmented_signal, sr):
#     fig, ax = plt.subplots(nrows=2)
#     librosa.display.waveshow(signal, sr=sr, ax=ax[0])
#     ax[0].set(title="Original signal")
#     librosa.display.waveshow(augmented_signal, sr=sr, ax=ax[1])
#     ax[1].set(title="Augmented signal")
#     plt.show()


#####   TO CUT CLIP TO THE CHUNKS  ########
# j=0
# k=20 # başlatmak istediğin index numarası ses dosyasının , ona göre tekrar seç
# for i in range(0, len(x),44100):
#     y = x[j*44100:(j+1)*44100]
#     if(len(y)<44050 and len(y)>20000):
#         N=44100-len(y)
#         zeros = np.zeros((N,), dtype=float)
#         arr = np.concatenate((y, zeros))
#         y=arr
#     sf.write("slices/newparts/seizedengine"+str(k)+".mp3", y, 22050)
#     j+=1
#     k+=1


















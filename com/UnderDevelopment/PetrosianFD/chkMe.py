import numpy as np


def hfd(X, Kmax):
    """ Compute Higuchi Fractal Dimension of a time series X. kmax
     is an HFD parameter
    """
    print("I am here")
    L = []
    x = []
    N = len(X)
    for k in range(1, Kmax):
        print("k = ",k)
        Lk = []
        for m in range(0, k):
            print("m = ",m)
            Lmk = 0
            print("chk Value ::",int(np.floor((N - m) / k)))
            for i in range(1, int(np.floor((N - m) / k))):
                print("i : ",i)
                Lmk += abs(X[m + i * k] - X[m + i * k - k])
                print("Lmk ",Lmk)
            Lmk = Lmk * (N - 1) / np.floor((N - m) / float(k)) / k
            print("LmK ::: ",Lmk)
           
            Lk.append(Lmk)
            print("Lk ::",Lk)
        L.append(np.log(np.mean(Lk)))
        x.append([np.log(float(1) / k), 1])

    (p, _, _, _) = np.linalg.lstsq(x, L)
    print(p)
    return p[0]

data = np.loadtxt('../../../Data/SampleData/RR_Data/ECG_BC_c_25_8_hrv.txt')


hfd(data,5)
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
                if Lmk>0:
                    kkk=1
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

import glob
files = glob.glob("../../../Data/SampleData/RR_Data/*.txt")
files.sort()
ans=[]
for f in files:
    #print(f)
    data = np.loadtxt(f)
    data = data[0:20]
    ans.append(hfd(data,5))

for a in ans:
    print(a)
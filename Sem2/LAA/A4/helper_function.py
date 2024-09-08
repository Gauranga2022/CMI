import numpy as np
from scipy import linalg
import random
from numpy import linalg as LA

# done +1 +1 in i and j in order to make them or our requirements o/w it will have divide by 0 error
def construct(n,eps):
    b = [random.randint(-100,100) for i in range(n*1)]
    A = np.zeros((n,n))
    for i in range(n):
        for j in range(n):
            value = 1/(i+1+j+1-1)
            A[i,j] = value
    return A,b

# 1 - Partial Pivoting

def GEPP(A,eps): 
    
    A = A.astype(float)
    n = A.shape[0]
    U = A.copy()
    L = np.identity(n)
    P = np.identity(n)
    pivots = []

    for k in range(n-1):
        # Below snippet does partial pivoting 
        column_k = np.abs(U[k:, k])
        pivot = max(column_k)
        if pivot <= eps  :
            return None
 
        index_col = np.argmax(column_k)
        
        if k != (index_col + k) :
            U[[k, index_col+k],:] = U[[index_col+k, k],:]
            P[[k, index_col+k],:] = P[[index_col+k, k],:]
            L[[k, index_col+k],:k] = L[[index_col+k, k],:k]
        
        # Now comes the computation part of LU
        # k denotes the no. of row and j denotes the column and i again columns
            
        for j in range(k+1,n):
            L[j,k] = U[j,k]/U[k,k]  
            U[j,k:] -= L[j,k]*U[k,k:]

    return P,L,U

# 2 - Rook Pivoting

def GERP(A,eps): 

    A = A.astype(float)
    n = A.shape[0]
    U = A.copy()
    L = np.identity(n)
    P = np.identity(n)
    Q = np.identity(n)

    for k in range(n-1):
        
        column_vals = np.abs(U[k:,k])   # k th column
        row_vals = np.abs(U[k,k:])        # k th row

        (row, col) = (-1,-1)

        (max_col,max_row) = (max(column_vals),max(row_vals))
        if max_col >= max_row and all([max_col,max_row]) >= eps : 
            col = np.argmax(column_vals) + k
        elif all([max_col,max_row]) >= eps  :
            row = np.argmax(row_vals) + k
        else:
            return None
       
        P[[k,row],:] = P[[row,k],:]
        U[[k,row],:] = U[[row,k],:]
        
        Q[:,[k,col]] = Q[:,[col,k]]  # can be avoided too
        U[:,[k,col]] = U[:,[col,k]]
        
        L[[k,row],:k] = L[[row,k],:k]
        
        for j in range(k + 1, n):
            L[j, k] = U[j, k] / U[k, k]
            U[j, k:] -= L[j, k] * U[k, k:]

    return P, L, U, Q

# 3 - Complete pivoting

def GECP(A,eps):
    
    A = A.astype(float)
    n = A.shape[0]
    U = A.copy()
    L = np.identity(n)
    P = np.identity(n)
    Q = np.identity(n)

    for k in range(n):
        max_index = np.unravel_index(np.argmax(np.abs(U[k:, k:])), (n-k, n-k))
        
        row = max_index[0] + k
        col = max_index[1] + k

        if U[row,col] <= eps:
            return None
        
        P[[k,row],:] = P[[row,k],:]
        U[[k,row],:] = U[[row,k],:]
        
        Q[:,[k,col]] = Q[:,[col,k]]  # can be avoided too
        U[:,[k,col]] = U[:,[col,k]]
        
        L[[k,row],:k] = L[[row,k],:k]
        
        for j in range(k + 1, n):
            L[j, k] = U[j, k] / U[k, k]
            U[j, k:] -= L[j, k] * U[k, k:]

    return P, L, U, Q

# 4 - Cholesky Decomposition 

def CHOP(A,eps):

    A = A.astype(float)
    n = A.shape[0]
    L = np.identity(n)
    P = np.identity(n)
    Q = np.identity(n)

    # Check for symmetry and positive definiteness (basic check)
    if not np.allclose(A, A.T):
        raise ValueError("Input matrix is not symmetric.")

    for k in range(n):

        if not np.all(np.linalg.eigvals(A[k:,k:]) > 0):
            return P,L,Q

        pos = np.argmax([A[j,j] for j in range(k,n)]) + k
        if A[pos,pos] <= eps:
            print("Terminated @ CHOP")
            return None

        A[[k,pos],:] = A[[pos,k],:]
        P[[k,pos],:] = P[[pos,k],:]
        L[[k,pos],:] = L[[pos,k],:]

        A[:,[k,pos]] = A[:,[pos,k]]
        Q[:,[k,pos]] = Q[:,[pos,k]]  
        L[:,[k,pos]] = L[:,[pos,k]]
        
        L[k,k] = np.sqrt(A[k,k] - np.sum(L[k, :k] ** 2))
        for p in range(k+1,n):
            L[p,k] = (A[p,k] - np.sum(L[p,:k]*L[k,:k])) / L[k,k]
        
    return P,L,Q

# Calculates norms of (PA - LU) and (AX - b) respectively 

def norm_calc(P,A,L,U,X,b): # returns norms for Mat and vector
    X = X.astype(float)
    diff_mat = P @ A - L @ U
    diff_vector = A @ X - b
    diff_vector = diff_vector.astype(float)
    return np.linalg.norm(diff_mat), np.linalg.norm(diff_vector)

# forward substitution 

def forward_subs(P,L,b,n):
    Pb = P @ b
    Y = np.zeros(n)
    for i in range(n):
        temp = 0
        for j in range(i):
            temp += Y[j]*L[i,j]
        Y[i] = (Pb[i] - temp)/L[i,i]
    return Y

# backward substitution

def backward_subs(U,Y,n):
    X = np.ones(n)
    for i in range(n-1,-1,-1):
        temp = 0
        for j in range(n-1,i,-1):
            temp += X[j]*U[i,j]
        X[i] = (Y[i] - temp)/U[i,i]
    return X

def subs_partial(P,L,U,b,n):
    Y = forward_subs(P,L,b,n)
    X = backward_subs(U,Y,n)
    return X

def subs_rest_all(P,L,U,b,Q,n):
    Y = forward_subs(P,L,b,n)
    x_prime = backward_subs(U,Y,n)
    return Q @ x_prime

def norm_calc(P,A,L,U,X,b): # returns norms for Mat and vecto
    X = X.astype(float)
    diff_mat = P @ A - L @ U
    diff_vector = A @ X - b
    diff_vector = diff_vector.astype(float)
    return np.linalg.norm(diff_mat), np.linalg.norm(diff_vector,ord = 2)

def norm_calc_rest(X,P,A,Q,L,U,b):
    X = X.astype(float)
    diff_mat = P @ A @ Q - L @ U
    diff_vector = A @ X - b
    diff_vector = diff_vector.astype(float)
    return np.linalg.norm(diff_mat), np.linalg.norm(diff_vector, ord = 2)

import numpy as np
arr=np.array([1,2,3])
print(arr * 2) #multiplying each element by 2

# 1.creating 1D array
arr1=np.array([10,20,30,40,50])
print("\n1D Array: \n",arr1)

#2. create 2D array
arr2=np.array([[1,2,3],[4,5,6]])
print("\n2D Array: \n",arr2)

# 3. reshape array-used to change the shape of an array without chnaging its data
reshaped=arr2.reshape(3,2)      #3 rows ,2 columns
print("\n Reshaped Array:",reshaped)

print("\n SUM:",arr1.sum())
print("\n MEAN:",arr1.mean())
print("\n MAX:",arr1.max())
print("\n MIN:",arr1.min())
print("\n SUM:",arr2.sum())
print("\n MEAN:",arr2.mean())
print("\n MAX",arr2.max())
print("\n MIN",arr2.min())

 
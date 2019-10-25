#include<iostream>
using namespace std;

__global__ void vectMat(int*a,int*b,int *c,int n)
{
	int row=blockIdx.y*blockDim.y+threadIdx.y;

	int sum=0;
	for(int j=0;j<n;j++)
	{
		sum+=a[row*n+j]*b[j];
	}
	c[row]=sum;

}
int main()
{
	int n=3;

	int*a,*b,*c;
	a=new int[n*n];
	b=new int[n];
	c=new int[n];
	
	for(int i=0;i<n;i++)
	{
		for(int j=0;j<n;j++)
		{
			a[i*n+j]=i+j;
		}
	}
	
	for(int i=0;i<n;i++)
	{
		b[i]=i+1;
	}
	
	cout<<"Matrix A is: "<<endl;
	for(int i = 0; i < n; i++) {
		for(int j = 0; j < n; j++) {
			cout << "a[" << i * n + j << "] = " << a[i * n + j] << " ";
		}
		cout << endl;
	}

	cout<<"Vector B is: "<<endl;
	for(int i = 0; i < n; i++) {
		cout << "b[" << i << "] = " <<b[i] << " ";
	}
	cout<<endl;

	int size=n*sizeof(int);

	cudaEvent_t start,end;

	int* dev_a,*dev_b,*dev_c;
	cudaMalloc(&dev_a,n*size);
	cudaMalloc(&dev_b,size);
	cudaMalloc(&dev_c,size);

	cudaEventCreate(&start);
	cudaEventCreate(&end);

	cudaMemcpy(dev_a,a,n*size,cudaMemcpyHostTODevice);
	cudaMemcpy(dev_b,b,size,cudaMemcpyHostToDevice);
	

	dim3 grid_dim(n,n,1);
	cudaEventRecord(start);

	vectMat<<<grid_dim,1>>>(dev_a,dev_b,dev_c,n);
	cudaEventRecord(end);
	cudaEventSynchronize(end);

	cudaMemcpy(dev_c,c,size,cudaMemcpyDeviceToHost);

	float time=0;
	cudaEventElapsedTime(&time,start,end);
	cout << "Output: " << endl;
	for(int i = 0; i < n; i++) {
		cout<< "c[" << i << "] = " << c[i] <<" ";
	}

	cout<<"\n Time elpased"<<time<<endl;



}
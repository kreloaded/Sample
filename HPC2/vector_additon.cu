#include<iostream>
using namespace std;

__global__ void addition(int *a,int *b,int *c,int n)
{
	int large_id=blockIdx.x*blockDim.x+threadIdx.x;

	while(large_id<n)
	{
		c[large_id]=a[large_id]+b[large_id];
		large_id+=blockDim.x*gridDim.x;
	}

}

int main()
{
	int *a,*b,*c;

	int n=20;

	a=(int*)malloc(n*sizeof(int));
	b=(int*)malloc(n*sizeof(int));
	c=(int*)malloc(n*sizeof(int));

	for(int i=0;i<n;i++)
	{
		a[i]=i+1;
		b[i]=i+1;
		c[i]=0;
	}

	cudaEvent_t start,end;
	int size=n*sizeof(int);

	int *dev_a,*dev_b,*dev_c;

	cudaMalloc(&dev_a,size);
	cudaMalloc(&dev_b,size);
	cudaMalloc(&dev_c,size);

	cudaMemcpy(dev_a,a,size,cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b,b,size,cudaMemcpyHostToDevice);

	cudaEventCreate(&start);
	cudaEventCreate(&end);

	cudaEventRecord(start);

	addition<<<128,128>>>(dev_a,dev_b,dev_c,n);

	cudaEventRecord(end);
	cudaEventSynchronize(end);

	float time=0;
	cudaEventElapsedTime(&time,start,end);

	cudaMemcpy(c,dev_c,size,cudaMemcpyDeviceToHost);
	for(int i = 0; i < n; i++) {
		cout<<a[i]<<"+"<<b[i]<<"="<<c[i]<<endl;
	}
	cout<<"\n Time elapsed:"<<time<<endl;

	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);



}
#include<iostream>
#include<omp.h>

using namespace std;

int q[1000];
int vis[7];

void bfs(int mat[7][7],int q[],int f,int l,int n)
{
	if(f==l)
	{
		return;
	}

	int cn=q[f];
	f++;

	cout<<cn<<" ";
	omp_set_num_threads(3);

	#pragma omp parallel for shared(vis)
	for(int i=0;i<n;i++)
	{
		if(mat[cn][i]==1 && vis[i]==0)
		{
			q[l++]=i;
			vis[i]=1;
		}
	}

	bfs(mat,q,f,l,n);
}

int main()
{
	int i,n=7,f=-1,l=0;
	for(i=0;i<n;i++)
	{
		vis[i]=0;
	}
	int mat[7][7]={
				{0,  1  ,1  ,0  ,0  ,0  ,0},
				{1	,0	,1	,1	,0	,0	,0},
				{1	,1	,0	,0	,1	,0	,0},
				{0	,1	,0	,0	,1	,0	,0},
				{0	,0	,1	,1	,0	,1	,0},
				{0	,0	,0	,0	,1	,0	,1},
				{0	,0	,0	,0	,0	,1	,0}
			};

	int stn=3;
	q[l++]=stn;
	f++;
	vis[stn]=1;

	bfs(mat,q,f,l,n);

}
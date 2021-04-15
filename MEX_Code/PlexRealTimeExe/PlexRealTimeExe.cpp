#include <stdio.h>
#include <string>
#include <math.h>
#include "windows.h"
#include "plexon.h"

/* Entry Point */
void main() {
	int res = PL_InitClientEx3(0, NULL, NULL);
	//int res = PL_InitClientEx(0, NULL, NULL);
    char name[1000];
	if (res==1) {
		int freq[64],channels[64],gains[64];
		PL_GetSlowInfo64(freq, channels, gains);
	
	  for (int j=0;j<64;j++) {
		  PL_GetName(1+j, name);
		  printf("%s\n",name);
		  PL_GetSlowChanName(j, name);
		  printf("%s\n",name);
	  }
	}
}

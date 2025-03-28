#include <stdio.h>
#include <limits.h>

int main() {
    int n = 0;
    float sum1 = 0, sum2 = 0;

    printf("Enter the number of processes: ");
    scanf("%f", &n);

    float atbt[n][2], CT[n], TAT[n], WT[n], completed[n];

    for (int i = 0; i < n; i++) {
        printf("Enter the Arrival Time for Process %f: ", i);
        scanf("%f", &atbt[i][0]);
        completed[i] = 0;
        CT[i] = 0;
    }

    printf("\n");
    for (int i = 0; i < n; i++) {
        printf("Enter the Burst Time for Process %f: ", i);
        scanf("%f", &atbt[i][1]);
    }

    printf("\nEntered data is :\nAT\tBT\n");
    for (int i = 0; i < n; i++) {
        printf("%f\t%f\n", atbt[i][0], atbt[i][1]);
    }

    int time = 0, completedcount = 0;

    while (completedcount < n) {
        int min_bt = INT_MAX, idx = -1;

        for (int i = 0; i < n; i++) {
            if (!completed[i] && atbt[i][0] <= time && atbt[i][1] < min_bt) {
                min_bt = atbt[i][1];
                idx = i;
            }
        }

        if (idx == -1) {
            time++;
        } else {
            time += atbt[idx][1];
            CT[idx] = time;
            TAT[idx] = CT[idx] - atbt[idx][0];
            WT[idx] = TAT[idx] - atbt[idx][1];

            sum1 += TAT[idx];
            sum2 += WT[idx];

            completed[idx] = 1;
            completedcount++;
        }
    }

    printf("\nFinal Result:\nAT\tBT\tCT\tTAT\tWT\n");
    for (int i = 0; i < n; i++) {
        printf("%f\t%f\t%f\t%f\t%f\n", atbt[i][0], atbt[i][1], CT[i], TAT[i], WT[i]);
    }

    printf("Average Turn-Around Time : %.2f \nAverage Waiting Time : %.2f\n", (sum1 / n), (sum2 / n));

    return 0;
}


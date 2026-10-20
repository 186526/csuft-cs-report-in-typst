#include <stdio.h>
int main()
{
    int a, b, c, max;

    printf("input a,b,c: ");
    scanf("%d,%d,%d", &a, &b, &c);

    max = a;
    if (b > max) max = b;
    if (c > max) max = c;

    printf("max=%d\n", max);

    return 0;
}

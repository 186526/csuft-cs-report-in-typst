#include <stdio.h>
#include <stdlib.h>

#define MAXSIZE 100

typedef struct {
    int data[MAXSIZE];
    int length;
} SqList;

/* 初始化顺序表 */
void InitList(SqList *L) {
    L->length = 0;
}

/* 在第 i 个位置插入元素 e */
int ListInsert(SqList *L, int i, int e) {
    if (i < 1 || i > L->length + 1) return 0;
    if (L->length >= MAXSIZE) return 0;
    for (int j = L->length; j >= i; j--)
        L->data[j] = L->data[j - 1];
    L->data[i - 1] = e;
    L->length++;
    return 1;
}

/* 删除第 i 个元素，并用 e 返回其值 */
int ListDelete(SqList *L, int i, int *e) {
    if (i < 1 || i > L->length) return 0;
    *e = L->data[i - 1];
    for (int j = i; j < L->length; j++)
        L->data[j - 1] = L->data[j];
    L->length--;
    return 1;
}

/* 按值查找，返回位序 */
int LocateElem(SqList L, int e) {
    for (int i = 0; i < L.length; i++)
        if (L.data[i] == e) return i + 1;
    return 0;
}

int main(void) {
    SqList L;
    InitList(&L);
    for (int i = 1; i <= 5; i++)
        ListInsert(&L, i, i * 10);

    for (int i = 0; i < L.length; i++)
        printf("%d ", L.data[i]);
    printf("\n");

    int e;
    ListDelete(&L, 2, &e);
    printf("deleted = %d, locate 50 = %d\n", e, LocateElem(L, 50));
    return 0;
}

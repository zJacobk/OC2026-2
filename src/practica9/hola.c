#include <stdio.h>

extern int maximo(int *arr,int len);
extern int minimo(int *arr,int len);
extern int sumatoria(int *arr,int len);

int main(){
    int arreglo[5],cantidad;
    int lectura;

   
    printf("Cuantos numeros vas a ingresar (1 a 5): ");
   
    lectura = scanf("%d",&cantidad);

    if(lectura!=1){
        printf("Debes ingresar un numero entero\n");
        return 1;
    }

    if(cantidad<1 || cantidad>5){
        printf("Cantidad invalida\n");
        return 1;
    }

    for(int i=0;i<cantidad;i++){
        printf("Numero %d: ",i+1);
        lectura = scanf("%d",&arreglo[i]);

        if(lectura!=1){
            printf("Numero invalido\n");
            return 1;
        }
    }

    printf("\nArreglo: ");
    for(int i=0;i<cantidad;i++){
        printf("%d ",arreglo[i]);
    }

    printf("\nMaximo: %d\n",maximo(arreglo,cantidad));
    printf("Minimo: %d\n",minimo(arreglo,cantidad));
    printf("Suma: %d\n",sumatoria(arreglo,cantidad));

    return 0;
}




#include <stdio.h>

extern int maximo(int *arr,int len);
extern int minimo(int *arr,int len);
extern int sumatoria(int *arr,int len);

int main(){
    int arreglo[5],cantidad;
    int lectura;

   
    printf("Cuantos numeros vas a ingresar (1 a 5): ");
   
    lectura = scanf("%d",&cantidad);

    if(lectura!=1){
        printf("Debes ingresar un numero entero\n");
        return 1;
    }

    if(cantidad<1 || cantidad>5){
        printf("Cantidad invalida\n");
        return 1;
    }

    for(int i=0;i<cantidad;i++){
        printf("Numero %d: ",i+1);
        lectura = scanf("%d",&arreglo[i]);

        if(lectura!=1){
            printf("Numero invalido\n");
            return 1;
        }
    }

    printf("\nArreglo: ");
    for(int i=0;i<cantidad;i++){
        printf("%d ",arreglo[i]);
    }

    printf("\nMaximo: %d\n",maximo(arreglo,cantidad));
    printf("Minimo: %d\n",minimo(arreglo,cantidad));
    printf("Suma: %d\n",sumatoria(arreglo,cantidad));

    return 0;
}
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define SENSORS 2

extern void set_bit(unsigned char *value, unsigned char bit);
extern unsigned char get_bit(unsigned char value, unsigned char bit);

void update_temp(int *temps){
    for(int i=0; i< SENSORS; i++){
        int cambio=(rand()%11)-5;
        temps[i] +=cambio;
    }
}


void update_flags(int *temps, int *last_temps, unsigned char *flags)
{
    for(int i=0; i<SENSORS; i++)
    {
        int diferencia= temps[i]- last_temps[i];

        flags[i] =0;

        if(diferencia== 0)
        {
            set_bit(&flags[i], 0); 
        }
        else
        {
            if (diferencia > 0)
            {
                set_bit(&flags[i], 5); 
            }
            else
            {
                set_bit(&flags[i], 4); 
                diferencia = -diferencia;
            }

            if (diferencia == 1)
            {
                set_bit(&flags[i], 1); 
            }
            else if (diferencia == 2)
            {
                set_bit(&flags[i], 2); 
            }
            else
            {
                set_bit(&flags[i], 3); 
            }
        }

        last_temps[i] = temps[i];
    }
}

void print_flag(unsigned char flag)
{
    if (get_bit(flag, 0))
    {
        putchar('-');
    }
    else
    {
        char direccion;
        int cantidad= 1;

        if(get_bit(flag, 5))
        {
            direccion = '>';
        }
        else
        {
            direccion = '<';
        }

        if (get_bit(flag, 3))
        {
            cantidad =3;
        }
        else if (get_bit(flag, 2))
        {
            cantidad =2;
        }

        for(int i=0; i<cantidad; i++)
        {
            putchar(direccion);
        }
    }
}

int main(void)
{
    int temps[SENSORS]= {25, 25};
    int last_temps[SENSORS]  {25, 25};
    unsigned char flags[SENSORS]= {1, 1}; 
    int opcion;

    srand((unsigned int)time(NULL));

    do
    {
        printf("\n\r SENSOR 1: ~%d °C ", temps[0]);
        print_flag(flags[0]);

        printf("\n\r SENSOR 2: ~%d °C ", temps[1]);
        print_flag(flags[1]);

        printf("\n\n[1] Actualizar\n");
        printf("[2] Salir\n");
        printf("\nSeleccionar opcioon: ");

        if (scanf("%d", &opcion) != 1)
        {
            printf("\nEntrada invalida.\n");
            return 1;
        }

        switch (opcion)
        {
            case 1:
                update_temp(temps);
                update_flags(temps, last_temps, flags);
                break;

            case 2:
                break;

            default:
                printf("\nOpcion invalida.\n");
                break;
        }

    } while (opcion !=2);

    printf("\n\rFIN DE PROGRAMA\n\n");
    return 0;
}
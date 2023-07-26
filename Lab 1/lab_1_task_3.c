#include<stdio.h>
#include<stdlib.h>

int main(void)
{
    //Opening files
    FILE *grades=fopen("grades.txt", "r");
    FILE *info=fopen("studentInfo.txt", "r");

    //Checking if files opened correctly
    if(grades==NULL || info==NULL)
    {
        printf("Could not open files!");
        exit(0);
    }

    //Variables
    int id=0, check=0, semester=0, min_sem=0;
    char e[100]= {'\0'}, c;
    int is_present=0;
    float gpa=0.0, min=4.50;

    //Taking input
    printf("Enter Student ID: ");
    scanf("%d", &id);

    //Checking if input is valid
    if(id>0 && id<=2e9)
    {
        ;
    }
    else
    {
        printf("\nInvalid Input!\n");
        exit(0);
    }

    while(1)
    {
        //Scanning id, rest of the string and new line char separately
        fscanf(info, "%d", &check);
        //Scans ; char so that it is not scanned into e array
        fgetc(info);
        fscanf(info, "%s", &e);
        c=fgetc(info);

        //Terminates when reaches EOF
        if(c==EOF)
        {
            break;
        }

        //Checking if same ID found
        if(check==id)
        {
            is_present=1;

            //Printing name
            printf("\nName: ");

            for(int i=0; e[i]!=';'; i++)
            {
                printf("%c", e[i]);
            }

            printf("\n");

            break;
        }
    }

    while(1)
    {
        //Scanning ID, GPA and semester separately
        //fgetc scans ; char
        fscanf(grades, "%d", &check);
        fgetc(grades);
        fscanf(grades, "%f", &gpa);
        fgetc(grades);
        fscanf(grades, "%d", &semester);

        //Terminates when reaches EOF
        if(fgetc(grades)==EOF)
        {
            break;
        }

        //Checking if same ID found
        if(check==id)
        {
            is_present=1;

            //Checking and storing minimum GPA and that semester
            if(gpa<=min)
            {
                min=gpa;
                min_sem=semester;
            }
        }
    }

    //Checking if ID was found in the files or not
    if(is_present==0)
    {
        printf("\nID does not exist!\n");
        exit(0);
    }
    else
    {
        //Printing output
        printf("\nSemester with lowest GPA: %d\n", min_sem);
    }


    return 0;
}

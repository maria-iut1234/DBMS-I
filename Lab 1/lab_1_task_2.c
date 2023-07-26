#include<stdio.h>
#include<stdlib.h>

int main(void)
{
    //Opening files
    FILE *grades=fopen("grades.txt", "a");

    //Checking if files opened correctly
    if(grades==NULL)
    {
        printf("Could not open file!");
        exit(0);
    }

    //Variables
    int id=0, semester=0;
    float gpa=0.0;

    //Taking input for new entry
    printf("Enter Student ID: ");
    scanf("%d", &id);
    printf("\nEnter GPA: ");
    scanf("%f", &gpa);
    printf("\nEnter Semester: ");
    scanf("%d", &semester);

    //Checking if inputs are valid
    if(id>0 && id<=2e9 && gpa>=2.50 && gpa<=4.00 && semester>=1 && semester<=8)
    {
        ;
    }
    else
    {
        printf("\nInvalid Input!\n");
        exit(0);
    }

    //Scanning new line char so that entry prints from next line
    fgetc(grades);

    //Printing new entry
    fprintf(grades, "\n%d;%.2f;%d", id, gpa, semester);

    return 0;
}

#include<stdio.h>
#include<stdlib.h>

int main(void)
{
    //Opening file
    FILE *grades=fopen("grades.txt", "r");

    //Checking if file opened correctly
    if(grades==NULL)
    {
        printf("Could not open file!");
        exit(0);
    }

    //Variables
    char c;
    int column=0, count=0;
    double total=0.0, cg=0.0;

    //Scanning char one by one
    while((c=getc(grades))!=EOF)
    {
        //Starts scanning grade after first column
        if(column==1 && c!=';')
        {
            //Since after ; char, the first number of the GPA was already scanned by fgetc, so we use ungetc then scan GPA
            ungetc(c, grades);
            fscanf(grades, "%lf", &cg);

            //adding to total and counting number of entries
            total+=cg;
            count++;
        }
        //Counting column using ; char occurence
        if(c==';')
        {
            column++;
        }
        //Initialing column counter after each row
        if(c=='\n')
        {
            column=0;
        }
    }

    //Printing output
    printf("Average GPA: %.2lf\n", total/count);

    return 0;
}

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h> 

#include "linked-list.h"
#include "myparser.tab.h"

/* Insertar por nodo key~nombre de variable, tipo,  token, numero de parametros, tipo de return  */

node *create(char *varName, int varType, node *next)
{
    node* new_node = (node*)malloc(sizeof(node));
    if(new_node == NULL)
    {
        printf("Error creating a new node.\n");
        exit(0);
    }
    new_node->varName = varName;
	new_node->varType = varType;
    new_node->next = next;
 
    return new_node;
}


node *prepend(node *head, char *varName, int varType)
{
    node* new_node = create(varName,varType,head);
    head = new_node;
    return head;
}

node *append(node *head, char *varName, int varType)
{
    if(head == NULL)
		return NULL;
    /* go to the last node */
    node *cursor = head;
    while(cursor->next != NULL)
        cursor = cursor->next;
 
    /* create a new node */
    node* new_node = create(varName,varType,NULL);
    cursor->next = new_node;
 
    return head;
}


node *search(node *head, char *varName)
{
 
    node *cursor = head;
    while(cursor!=NULL)
    {
        if(cursor->varName == varName)
            return cursor;
        cursor = cursor->next;
    }
    return NULL;
}

void dispose(node *head)
{
    node *cursor, *tmp;
 
    if(head != NULL)
    {
        cursor = head->next;
        head->next = NULL;
        while(cursor != NULL)
        {
            tmp = cursor->next;
            free(cursor);
            cursor = tmp;
        }
    }
}



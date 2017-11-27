

typedef struct node
{
	char *varName;
	int varType, token, paramNumber, returnType, arrayBound;
    struct node* next;
	struct node* offset;
} node;

typedef void (*callback)(node* data);
node *create(char *varName, int varType, node* next);
node *prepend(node* head, char *varName, int varType);
node *append(node* head, char *varName, int varType);
node *search(node* head, char *varName);
void dispose(node *head);


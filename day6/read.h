/* Wyatt Geckle
 *
 * MIPS file read functions
 *
 * fgets documentation from https://en.cppreference.com/w/c/io/fgets
 */


#include <stdint.h>

/* Writes at most count - 1 characters from an input file with file
 * descriptor fd to the character buffer str.  Stops when character
 * is found, which is omitted from the buffer.  Returns -1 if an
 * error occurs, or the number of characters in str otherwise.
 */
int read_to_char(char* str, int count, int fd, char character);


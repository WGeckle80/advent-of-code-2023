/* Wyatt Geckle
 *
 * MIPS file read functions
 */


#include <stdint.h>

/* Reads an unsigned integer from a line from an input file into the
 * num buffer.  Ignores any characters except newline.  Returns -1
 * if an error occurs, 1, if a numeric is read, or 0 if end of file
 * is reached.
 */
int read_line_u64(uint64_t* num, int fd);

/* Reads an unsigned integer from an input file into the num buffer.
 * Ignores leading characters before the first numeric character,
 * and stops after a non-numeric character is found.  Returns -1
 * if an error occurs, 1 if a numeric is read, or 0 if end of file
 * is reached.
 */
int read_next_u32(uint32_t* num, int fd);

/* Writes at most count - 1 characters from an input file with file
 * descriptor fd to the character buffer str.  Stops when character
 * is found, which is omitted from the buffer.  Returns -1 if an
 * error occurs, or the number of characters in str otherwise.
 *
 * Heavily based on the C standard library's fgets.
 * https://en.cppreference.com/w/c/io/fgets
 */
int read_to_char(char* str, int count, int fd, char character);


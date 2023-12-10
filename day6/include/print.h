/* Wyatt Geckle
 *
 * MIPS print functions
 */


#include <stdint.h>

/* Prints a signed integer to standard output. */
void print_i32(int32_t x);

/* Prints an unsigned integer to standard output. */
void print_u32(uint32_t x);

/* Prints a null-terminated string to the specified file descriptor. */
void print_str(char* str, int fd);

/* Prints a character to standard output. */
void putchar(char character);


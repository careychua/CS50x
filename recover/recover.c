#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

typedef uint8_t  BYTE;

int blk_size = 512;
int max_files = 1000;

int main(int argc, char *argv[])
{
    // check number of command line arguments
    if (argc != 2)
    {
        fprintf(stderr, "Usage: ./recover image\n");
        return 1;
    }

    // remember filenames
    char *infile = argv[1];

    // open input file
    FILE *inptr = fopen(infile, "r");
    if (inptr == NULL)
    {
        fprintf(stderr, "Could not open %s.\n", infile);
        return 2;
    }

    int file_count = -1;
    int loop_count = 0;
    BYTE buffer[blk_size];
    char outfile[sizeof "100.txt"];
    FILE *outptr = NULL;

    while (file_count < max_files)
    {
        loop_count++;
        //printf("..........loop_count: %i\n", loop_count);
        //printf("..........file_count: %i\n", file_count);

        //printf("inptr before read: %li\n", ftell(inptr));
        // read blk contents and store into buffer and check for EOF
        if (fread(buffer, 1, blk_size, inptr) < 512)
        {
            //printf("..........EOF........\n");
            break;
        }
        //printf("inptr after read: %li\n", ftell(inptr));

        //printf("buffer[0]: %i\n", buffer[0]);
        //printf("buffer[1]: %i\n", buffer[1]);
        //printf("buffer[2]: %i\n", buffer[2]);
        //printf("buffer[3]: %i\n", buffer[3]);

        // check for jpeg header
        if (buffer[0] == 0xFF && buffer[1] == 0xD8 && buffer[2] == 0xFF && (buffer[3] & 0xF0) == 0xE0)
        {
            // create new file
            //printf("...File Header...\n");

            file_count++;
            //printf("file_count: %i\n", file_count);

            sprintf(outfile, "%03i.jpg", file_count);

            // open output file
            outptr = fopen(outfile, "w");
            if (outptr == NULL)
            {
                fprintf(stderr, "Could not create %s.\n", outfile);
                return 3;
            }
        }

        if (file_count >= 0)
        {
            //printf("...File Content...\n");

            // write blk contents from buffer
            //printf("outptr before read: %li\n", ftell(outptr));
            fwrite(buffer, blk_size, 1, outptr);
            //printf("outptr after read: %li\n", ftell(outptr));

        }
    }

    // Success
    return 0;
}

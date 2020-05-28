// resizes a BMP image

#include <stdio.h>
#include <stdlib.h>

#include "bmp.h"

int main(int argc, char *argv[])
{
    // ensure proper usage
    if (argc != 4)
    {
        fprintf(stderr, "Usage: ./resize n infile outfile\n");
        return 1;
    }

    // assign n factor
    int n = atoi(argv[1]);
    //printf("n: %i\n", n);

    if (n < 0 || n > 100)
    {
        fprintf(stderr, "n should be a positive integer not be more than 100.\n");
        return 2;
    }

    // remember filenames
    char *infile = argv[2];
    char *outfile = argv[3];

    // open input file
    FILE *inptr = fopen(infile, "r");
    if (inptr == NULL)
    {
        fprintf(stderr, "Could not open %s.\n", infile);
        return 3;
    }

    // open output file
    FILE *outptr = fopen(outfile, "w");
    if (outptr == NULL)
    {
        fclose(inptr);
        fprintf(stderr, "Could not create %s.\n", outfile);
        return 4;
    }

    // read infile's BITMAPFILEHEADER
    BITMAPFILEHEADER bf;
    fread(&bf, sizeof(BITMAPFILEHEADER), 1, inptr);

    // read infile's BITMAPINFOHEADER
    BITMAPINFOHEADER bi;
    fread(&bi, sizeof(BITMAPINFOHEADER), 1, inptr);

    // ensure infile is (likely) a 24-bit uncompressed BMP 4.0
    if (bf.bfType != 0x4d42 || bf.bfOffBits != 54 || bi.biSize != 40 ||
        bi.biBitCount != 24 || bi.biCompression != 0)
    {
        fclose(outptr);
        fclose(inptr);
        fprintf(stderr, "Unsupported file format.\n");
        return 4;
    }

    // update BITMAPFILEHEADER and BITMAPINFOHEADER details
    int biWidth_r = bi.biWidth;
    int biHeight_r = abs(bi.biHeight);
    bi.biWidth *= n;
    bi.biHeight *= n;
    int biWidth_w = bi.biWidth;
    int biHeight_w = abs(bi.biHeight);

    // determine padding for scanlines
    int padding_r = (4 - (biWidth_r * (sizeof(RGBTRIPLE)) % 4)) % 4;
    int padding_w = (4 - (biWidth_w * (sizeof(RGBTRIPLE)) % 4)) % 4;

    bi.biSizeImage = (biWidth_w * (sizeof(RGBTRIPLE)) + padding_w) * biHeight_w;
    bf.bfSize = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER) + bi.biSizeImage;

    // write outfile's BITMAPFILEHEADER
    fwrite(&bf, sizeof(BITMAPFILEHEADER), 1, outptr);

    // write outfile's BITMAPINFOHEADER
    fwrite(&bi, sizeof(BITMAPINFOHEADER), 1, outptr);

    // iterate over infile's scanlines
    for (int i = 0; i < biHeight_r; i++)
    {
        //printf("------------- i: %i\n", i);

        // create dynamic array
        BYTE *line = malloc(sizeof(BYTE) * (biWidth_w * (sizeof(RGBTRIPLE)) + padding_w));
        int count = 0;

        if (line == NULL)
        {
            fprintf(stderr, "malloc failed\n");
            return -1;
        }


        // iterate over pixels in scanline
        for (int j = 0; j < biWidth_r; j++)
        {
            //printf("------------- j: %i\n", j);

            // temporary storage
            RGBTRIPLE triple;

            // read RGB triple from infile
            //printf("inptr before pos: %li\n", ftell(inptr));
            fread(&triple, sizeof(RGBTRIPLE), 1, inptr);
            //printf("inptr after pos: %li\n", ftell(inptr));

            // write RGB triple to outfile n times
            for (int l = 0; l < n; l++)
            {
                //printf("------------- l: %i\n", l);

                //printf("triple.rgbtBlue: %hhu\n", triple.rgbtBlue);
                //printf("triple.rgbtGreen: %hhu\n", triple.rgbtGreen);
                //printf("triple.rgbtRed: %hhu\n", triple.rgbtRed);

                line[count] = triple.rgbtBlue;
                count++;
                line[count] = triple.rgbtGreen;
                count++;
                line[count] = triple.rgbtRed;
                count++;

                //printf("outptr before pos: %li\n", ftell(outptr));
                fwrite(&triple, sizeof(RGBTRIPLE), 1, outptr);
                //printf("outptr after pos: %li\n", ftell(outptr));
            }
        }

        // skip over padding, if any
        fseek(inptr, padding_r, SEEK_CUR);

        // then add it back (to demonstrate how)
        for (int k = 0; k < padding_w; k++)
        {
            fputc(0x00, outptr);
            line[count] = 0x00;
            count++;
        }

        //printf("count: %i\n", count);

        //repeat scanline n-1 times
        for (int m = 0; m < (n - 1); m++)
        {
            //printf("------------- m: %i\n", m);

            for (int q = 0; q < count; q++)
            {
                fputc(line[q], outptr);
            }
        }

        free(line);
        //printf("------------- freed malloc\n");
    }

    // close infile
    fclose(inptr);
    //printf("------------- closed infile\n");

    // close outfile
    fclose(outptr);
    //printf("------------- closed outfile\n");

    // success
    //printf("------------- success\n");
    return 0;
}

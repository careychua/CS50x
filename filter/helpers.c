#include "helpers.h"
#include <math.h>
#include <stdio.h>

// Convert image to grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
    int n = height;
    int m = width;

    // iterate through every row of image
    for (int i = 0; i < n; i++)
    {
        // iterate through every pixel of every row of the image
        for (int j = 0; j < m; j++)
        {
            int avg = round((image[i][j].rgbtRed + image[i][j].rgbtGreen + image[i][j].rgbtBlue) / 3.0);

            image[i][j].rgbtRed = avg;
            image[i][j].rgbtGreen = avg;
            image[i][j].rgbtBlue = avg;
        }
    }
}

// Convert image to sepia
void sepia(int height, int width, RGBTRIPLE image[height][width])
{
    int n = height;
    int m = width;

    // iterate through every row of image
    for (int i = 0; i < n; i++)
    {
        // iterate through every pixel of every row of the image
        for (int j = 0; j < m; j++)
        {
            int red = round(0.393 * image[i][j].rgbtRed + 0.769 * image[i][j].rgbtGreen + 0.189 * image[i][j].rgbtBlue);
            int green = round(0.349 * image[i][j].rgbtRed + 0.686 * image[i][j].rgbtGreen + 0.168 * image[i][j].rgbtBlue);
            int blue = round(0.272 * image[i][j].rgbtRed + 0.534 * image[i][j].rgbtGreen + 0.131 * image[i][j].rgbtBlue);

            if (red > 255)
            {
                image[i][j].rgbtRed = 255;
            }
            else
            {
                image[i][j].rgbtRed = red;
            }

            if (green > 255)
            {
                image[i][j].rgbtGreen = 255;
            }
            else
            {
                image[i][j].rgbtGreen = green;
            }

            if (blue > 255)
            {
                image[i][j].rgbtBlue = 255;
            }
            else
            {
                image[i][j].rgbtBlue = blue;
            }
        }
    }
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
    int n = height;
    int m = width;

    // iterate through every row of image
    for (int i = 0; i < n; i++)
    {
        //copy row to temp array
        RGBTRIPLE temp[m];
        for (int k = 0; k < m; k++)
        {
            temp[k].rgbtRed = image[i][k].rgbtRed;
            temp[k].rgbtGreen = image[i][k].rgbtGreen;
            temp[k].rgbtBlue = image[i][k].rgbtBlue;
        }

        // iterate through every pixel of every row starting from the end of the image
        int count = 0;
        for (int j = m - 1; j >= 0; j--)
        {
            image[i][j].rgbtRed = temp[count].rgbtRed;
            image[i][j].rgbtGreen = temp[count].rgbtGreen;
            image[i][j].rgbtBlue = temp[count].rgbtBlue;

            count++;
        }
    }
}

// Blur image
void blur(int height, int width, RGBTRIPLE image[height][width])
{
    int n = height;
    int m = width;
    RGBTRIPLE temp[n][m];

    // copy image to temp
    for (int i = 0; i < n; i++)
    {
        for (int j = 0; j < m; j++)
        {
            temp[i][j] = image[i][j];
        }
    }

    // iterate through every row of image
    for (int i = 0; i < n; i++)
    {
        // printf("i: %i\n", i);
        int top_x = i - 1;
        int btm_x = i + 1;

        // iterate through every pixel of every row of the image
        for (int j = 0; j < m; j++)
        {
            // printf("j: %i\n", j);
            int left_x = j - 1;
            int right_x = j + 1;
            float count = 0;
            int avg_red = 0;
            int avg_green = 0;
            int avg_blue = 0;

            // populate average grid for x (i,j)
            for (int k = top_x; k <= btm_x; k++)
            {
                // printf("k: %i\n", k);
                if (k >= 0 && k < n)
                {
                    // calculate per grid
                    for (int l = left_x; l <= right_x; l++)
                    {
                        // printf("l: %i\n", l);
                        if (l >= 0 && l < m)
                        {
                            avg_red += temp[k][l].rgbtRed;
                            avg_green += temp[k][l].rgbtGreen;
                            avg_blue += temp[k][l].rgbtBlue;

                            count++;
                        }
                    }
                }
            }

            if (count > 0)
            {
                image[i][j].rgbtRed = round(avg_red / count);
                image[i][j].rgbtGreen = round(avg_green / count);
                image[i][j].rgbtBlue = round(avg_blue / count);
            }
        }
    }
}

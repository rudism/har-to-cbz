# HAR to CBZ

## Usage

1. Navigate to your comic bookshelf in Firefox
2. Open Developer Tools by pressing F12
3. Go to Network tab and click Images filter
4. Open your comic, click through all pages
   - You should see all page images listed in the Developer Tools Network window
5. Click HAR in the Developer Tools and select Save All As HAR
6. Run this script on the HAR file you saved
   ```
   perl convert.pl /path/to/file.har
   ```
7. Your file will be named `comic.cbz`

Should work under the following conditions:
- Comic site loads full image files via standard requests
- Image files are numbered sequentially and end with `.jpg` (can have non-numerics on either side of the number)

It will pad numbers with leading zeros and if duplicates are found, it will use the one with the largest file size to avoid using corrupt partial images.

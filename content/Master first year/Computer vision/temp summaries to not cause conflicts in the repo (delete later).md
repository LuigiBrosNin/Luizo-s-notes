## 3. Edge Detection
Edges seen as sharp brightness changes
Important for segmentation, recognition and measurement

Brightness changes and therefore edges are detected with threshold over the 1st derivative

in 2D, we calculate the **gradient** (vector of partial derivatives) that detects **direction of the edge**
- Magnitude = strength of edge
- Direction = towards brighter side
We approximate the gradient by estimating derivatives with
- Differences (pixel difference)
- Kernels (same principle, using correlation kernels)

Noise causes false positives, so we smooth the image when detecting edges

Prewitt/Sobel ops make so we take into consideration the surrounding pixels to evaluate the edge
Prewitt operator -> take 8 surrounding pixels 
Sobel operator -> likewise but central pixels weight 2x
## 3. Edge Detection
**Edges** seen as <u>sharp brightness changes</u>

Brightness changes and therefore edges are detected with threshold over the 1st derivative
### Gradient approximation
in 2D, we calculate the **gradient** (vector of partial derivatives) that detects **direction of the edge**
- Magnitude = strength of edge
- Direction = towards brighter side
We approximate the gradient by estimating derivatives with
- **Differences** (pixel difference)
- **Kernels** (same principle, using correlation kernels)
### Noise workarounds
**Noise** causes false positives, so we smooth the image when detecting edges

Prewitt/Sobel ops make so we take into consideration the surrounding pixels to evaluate the edge
**Prewitt** operator -> take 8 surrounding pixels 
**Sobel** operator -> likewise but central pixels weight 2x

### Non-Maxima Suppression (NMS)
strategy of finding the local maxima in the derivative
- We need to find the gradient magnitude from the approximation
- We use Lerp from the discrete grid's closest points
To get rid of noise we apply a threshold
### Canny’s Edge Detector 
Standard criteria
1. Good **detection** -> extract edges even in noisy images
2. Good **localization** -> minimize found edge and true edge distance
3. **One response** to one edge -> one single edge pixel detected at each true edge

**Canny's Pipeline**
1. Gaussian smoothing
2. Gradient computation
3. Non-maxima suppression
4. **Hysteresis** thresholding -> approach relying on a higher $(T_h)$ and a lower $(T_l)$threshold.

### 2nd derivative edge detection methods
Zero crossing = get point at 0 of 2nd derivative
**Laplacian operator** (sum of second-order derivatives) to approx derivatives
$$\nabla^2 I=\frac{\partial^2 I}{\partial x^{2}​}+\frac{\partial^2 I}{\partial y^{2}}​$$
### Laplacian of Gaussian (LOG)
Pipeline
1. Gaussian smoothing
2. Apply Laplacian
3. Find zero-crossings
4. Get actual edge from where the abs value of LOG is smaller

Parameter **sigma** controls smoothing degree and scale of features to detect (we blur more if edges are "bigger")

### Comparison
![[Pasted image 20250519164759.png]]
## 4. Local Features
find **Corresponding Points** (Local invariant features) between 2+ images of a scene
##
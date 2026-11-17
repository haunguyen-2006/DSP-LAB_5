// ============================================================
// DIGITAL SIGNAL PROCESSING - LAB 5 (ADDITIONAL EXERCISES)
// EXERCISE 3.7: CONVOLUTION USING THE Z-TRANSFORM
// ============================================================
// Given:
//   x1(n) = (1/3)^n,       n >= 0
//        = (1/2)^(-n),     n < 0
//   x2(n) = (1/2)^n u(n)
//
// This script:
//   1. Computes the convolution numerically over a sufficiently
//      wide finite interval.
//   2. Compares it with the analytical two-sided expression.
//   3. Displays x1(n), x2(n), and y(n).
//
// Analytical result:
//   y(n) = (4/3)(1/2)^(-n),                       n < 0
//        = (10/3)(1/2)^n - 2(1/3)^n,              n >= 0
//
// Z-transform information:
//   X1(z) = z/(z - 1/3) + z/(2 - z)
//   X2(z) = z/(z - 1/2)
//   Y(z)  = X1(z) X2(z)
//   ROC: 1/2 < |z| < 2
// ============================================================

clear;
clc;

mprintf("============================================================\n");
mprintf("EXERCISE 3.7 - CONVOLUTION\n");
mprintf("============================================================\n");

// ------------------------------------------------------------
// 1. Define the input sequences for display
// ------------------------------------------------------------

n1 = -10:10;
x1 = zeros(1, length(n1));

for i = 1:length(n1)
    if n1(i) >= 0 then
        x1(i) = (1/3)^n1(i);
    else
        x1(i) = (1/2)^(-n1(i));
    end
end

n2 = 0:15;
x2 = (1/2).^n2;

// ------------------------------------------------------------
// 2. Compute the convolution numerically
// ------------------------------------------------------------
// The original sequences are infinite. K=60 truncates the tails
// far enough away that the displayed output samples are accurate
// to normal double-precision plotting/reporting needs.

K = 60;
nOut = -10:15;
yConv = zeros(1, length(nOut));

for i = 1:length(nOut)
    n = nOut(i);
    accumulator = 0;

    for k = -K:K
        m = n - k;

        // x2(m) is zero for m < 0. The upper limit K truncates
        // only a negligible tail for the displayed output range.
        if m >= 0 & m <= K then
            if k >= 0 then
                x1k = (1/3)^k;
            else
                x1k = (1/2)^(-k);
            end

            x2m = (1/2)^m;
            accumulator = accumulator + x1k * x2m;
        end
    end

    yConv(i) = accumulator;
end

// ------------------------------------------------------------
// 3. Calculate the analytical result for comparison
// ------------------------------------------------------------

yTheory = zeros(1, length(nOut));

for i = 1:length(nOut)
    n = nOut(i);

    if n < 0 then
        yTheory(i) = (4/3) * (1/2)^(-n);
    else
        yTheory(i) = (10/3) * (1/2)^n - 2 * (1/3)^n;
    end
end

maxError = max(abs(yConv - yTheory));

// ------------------------------------------------------------
// 4. Display numerical and analytical results
// ------------------------------------------------------------

mprintf("\nConvolution result (n, numerical, analytical):\n");
mprintf("------------------------------------------------------------\n");

for i = 1:length(nOut)
    mprintf("%4d   % .12f   % .12f\n", nOut(i), yConv(i), yTheory(i));
end

mprintf("\nMaximum absolute difference = %.3e\n", maxError);
mprintf("\nZ-transform expressions:\n");
mprintf("X1(z) = z/(z - 1/3) + z/(2 - z)\n");
mprintf("X2(z) = z/(z - 1/2)\n");
mprintf("Y(z)  = X1(z) * X2(z)\n");
mprintf("ROC   = 1/2 < |z| < 2\n");

// ------------------------------------------------------------
// 5. Plot the input and output sequences
// ------------------------------------------------------------

scf(1);
clf();

subplot(3, 1, 1);
plot2d3(n1, x1);
xtitle("Exercise 3.7 - x1(n)", "n", "Amplitude");
xgrid(1);

subplot(3, 1, 2);
plot2d3(n2, x2);
xtitle("Exercise 3.7 - x2(n)", "n", "Amplitude");
xgrid(1);

subplot(3, 1, 3);
plot2d3(nOut, yConv);
a = gca();
a.auto_clear = "off";
plot(nOut, yTheory, "r--");
a.auto_clear = "on";
xtitle("Convolution y(n): numerical and analytical results", "n", "Amplitude");
legend(["Numerical convolution"; "Analytical result"]);
xgrid(1);

mprintf("\nExercise 3.7 completed.\n");
mprintf("============================================================\n");

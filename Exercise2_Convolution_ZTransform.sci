// ============================================================
// DIGITAL SIGNAL PROCESSING - LAB 5
// EXERCISE 2: CONVOLUTION USING Z-TRANSFORM AND INVERSE Z-TRANSFORM
// ============================================================
// The script evaluates all three cases in the handout.
// For the right-sided infinite sequences in (b) and (c),
// N samples are calculated. Each displayed sample is exact,
// because y(n) only depends on input samples from 0 through n.
// ============================================================

clear;
clc;

mprintf("==================================================\n");
mprintf("EXERCISE 2 - CONVOLUTION\n");
mprintf("==================================================\n");

// ------------------------------------------------------------
// Part (a)
// x1(n) = {1, 2, 3, 4, 5}, origin at the first sample
// x2(n) = {1, 1, 1},     origin at the first sample
// ------------------------------------------------------------

x1a = [1 2 3 4 5];
x2a = [1 1 1];

// Linear convolution using the finite-sum definition.
Na1 = length(x1a);
Na2 = length(x2a);
ya = zeros(1, Na1 + Na2 - 1);

for i = 1:Na1
    for j = 1:Na2
        ya(i+j-1) = ya(i+j-1) + x1a(i) * x2a(j);
    end
end

na = 0:(length(ya)-1);

mprintf("\nPART (a)\n");
disp("x1(n) = ");
disp(x1a);
disp("x2(n) = ");
disp(x2a);
disp("Linear convolution [n, y(n)]:");
disp([na' ya']);

// ------------------------------------------------------------
// Part (b)
// x1(n) = (1/5)^n u(n)
// x2(n) = 2^n u(n)
// y(n) = sum from k=0 to n of (1/5)^k * 2^(n-k)
// Closed form: y(n) = (10/9)*2^n - (1/9)*(1/5)^n
// ------------------------------------------------------------

N = 15;
nb = 0:(N-1);
x1b = (1/5) .^ nb;
x2b = 2 .^ nb;
yb = zeros(1, N);

// Evaluate the convolution sum for n = 0, 1, ..., N-1.
for i = 1:N
    for k = 0:(i-1)
        yb(i) = yb(i) + x1b(k+1) * x2b(i-k);
    end
end

// Closed-form result obtained from the Z-transform pair.
ybFormula = (10/9) * (2 .^ nb) - (1/9) * ((1/5) .^ nb);
errorB = max(abs(yb - ybFormula));

mprintf("\nPART (b)\n");
disp("First N samples of x1(n):");
disp(x1b);
disp("First N samples of x2(n):");
disp(x2b);
disp("Convolution samples [n, y(n)]:");
disp([nb' yb']);
mprintf("Maximum difference from the closed-form result: %g\n", errorB);

// ------------------------------------------------------------
// Part (c)
// x1(n) = n*u(n)
// x2(n) = 2^n*u(n-1)
// y(n) = sum from k=0 to n-1 of k*2^(n-k), for n >= 1
// Closed form: y(n) = 2^(n+1) - 2*n - 2, for n >= 0
// ------------------------------------------------------------

nc = 0:(N-1);
x1c = nc;
x2c = zeros(1, N);

// x2(0)=0; x2(n)=2^n for n>=1.
if N >= 2 then
    x2c(2:N) = 2 .^ (1:(N-1));
end

yc = zeros(1, N);

// Evaluate y(n) = sum x1(k)*x2(n-k).
for i = 1:N
    for k = 0:(i-1)
        yc(i) = yc(i) + x1c(k+1) * x2c(i-k);
    end
end

// Closed-form result for verification.
ycFormula = 2 .^ (nc+1) - 2*nc - 2;
errorC = max(abs(yc - ycFormula));

mprintf("\nPART (c)\n");
disp("First N samples of x1(n):");
disp(x1c);
disp("First N samples of x2(n):");
disp(x2c);
disp("Convolution samples [n, y(n)]:");
disp([nc' yc']);
mprintf("Maximum difference from the closed-form result: %g\n", errorC);

// ------------------------------------------------------------
// Plot the convolution results for parts (a), (b), and (c).
// ------------------------------------------------------------

scf(1);
clf();

subplot(3,1,1);
plot2d3(na, ya);
xtitle("Exercise 2(a) - Finite-Length Convolution", "Sample index n", "y(n)");
xgrid(1);

subplot(3,1,2);
plot2d3(nb, yb);
xtitle("Exercise 2(b) - Convolution of Two Right-Sided Sequences", "Sample index n", "y(n)");
xgrid(1);

subplot(3,1,3);
plot2d3(nc, yc);
xtitle("Exercise 2(c) - Convolution with a Delayed Exponential", "Sample index n", "y(n)");
xgrid(1);

mprintf("\nExercise 2 completed.\n");

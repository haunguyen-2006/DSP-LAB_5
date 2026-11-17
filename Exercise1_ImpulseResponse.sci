// ============================================================
// DIGITAL SIGNAL PROCESSING - LAB 5
// EXERCISE 1: IMPULSE RESPONSE USING THE Z-TRANSFORM
// ============================================================
// Given:
//     y(n) - y(n-2) = x(n)
//
// Assuming a causal system with zero initial conditions:
//     H(z) = Y(z)/X(z) = 1/(1 - z^(-2))
//     h(n) = delta(n) + delta(n-2) + delta(n-4) + ...
//     ROC: |z| > 1 (causal interpretation)
//
// This script obtains h(n) by applying an impulse input and
// evaluating the difference equation recursively.
// ============================================================

clear;
clc;

mprintf("==================================================\n");
mprintf("EXERCISE 1 - IMPULSE RESPONSE\n");
mprintf("==================================================\n");

// Number of samples to display: n = 0, 1, ..., N-1.
N = 21;
n = 0:(N-1);

// Unit impulse input: delta(0)=1 and delta(n)=0 for n<>0.
x = zeros(1, N);
x(1) = 1;

// Zero initial conditions (initial rest).
h = zeros(1, N);

// Apply y(n) = y(n-2) + x(n).
for i = 1:N
    if i > 2 then
        previousTwo = h(i-2);
    else
        previousTwo = 0;
    end

    h(i) = previousTwo + x(i);
end

// Analytical impulse response for comparison.
hExpected = zeros(1, N);
for i = 1:N
    if modulo(n(i), 2) == 0 then
        hExpected(i) = 1;
    end
end

errorValue = max(abs(h - hExpected));

mprintf("System equation: y(n) - y(n-2) = x(n)\n");
mprintf("Transfer function: H(z) = 1/(1 - z^(-2))\n");
mprintf("Causal ROC: |z| > 1\n");
mprintf("Maximum difference from the analytical h(n): %g\n\n", errorValue);

disp("Impulse response samples [n, h(n)]:");
disp([n' h']);

// Plot the discrete-time impulse response.
scf(1);
clf();
plot2d3(n, h);
xtitle("Exercise 1 - Impulse Response h(n)", "Sample index n", "h(n)");
xgrid(1);

mprintf("Exercise 1 completed.\n");

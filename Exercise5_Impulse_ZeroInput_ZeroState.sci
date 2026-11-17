// ============================================================
// DIGITAL SIGNAL PROCESSING - LAB 5
// EXERCISE 5: IMPULSE, ZERO-INPUT, AND ZERO-STATE RESPONSES
// ============================================================
// Given:
//     y(n) = 2*y(n-1) - 3*y(n-2) + x(n) + x(n-1)
//
// Tasks:
//   a. Draw the block diagram (the summation terms are shown
//      in the difference equation above).
//   b. Determine the impulse response h(n).
//   c. Determine y_zi(n) when y(-1)=y(-2)=1.
//   d. Determine y_zs(n) when x(n)=2^n*u(n).
//
// The impulse response and zero-state response use zero initial
// conditions. The zero-input response uses the given nonzero
// initial conditions and x(n)=0.
// ============================================================

clear;
clc;

mprintf("==================================================\n");
mprintf("EXERCISE 5 - LTI SYSTEM RESPONSES\n");
mprintf("==================================================\n");

N = 16;
n = 0:(N-1);

// ------------------------------------------------------------
// 1. Impulse response h(n)
// ------------------------------------------------------------
// Apply x(n)=delta(n), with zero initial conditions.

delta = zeros(1, N);
delta(1) = 1;

h = zeros(1, N);
hPrevious1 = 0;  // h(n-1)
hPrevious2 = 0;  // h(n-2)
xPrevious = 0;   // delta(n-1)

for i = 1:N
    h(i) = 2*hPrevious1 - 3*hPrevious2 + delta(i) + xPrevious;

    hPrevious2 = hPrevious1;
    hPrevious1 = h(i);
    xPrevious = delta(i);
end

// ------------------------------------------------------------
// 2. Zero-input response y_zi(n)
// ------------------------------------------------------------
// x(n)=0, y(-1)=1, and y(-2)=1.

yzi = zeros(1, N);
yziPrevious1 = 1;  // y(-1)
yziPrevious2 = 1;  // y(-2)

for i = 1:N
    yzi(i) = 2*yziPrevious1 - 3*yziPrevious2;

    yziPrevious2 = yziPrevious1;
    yziPrevious1 = yzi(i);
end

// ------------------------------------------------------------
// 3. Zero-state response y_zs(n)
// ------------------------------------------------------------
// x(n)=2^n*u(n), with zero initial conditions.

x = 2 .^ n;
yzs = zeros(1, N);
yzsPrevious1 = 0;  // y(-1)=0 for zero-state response
yzsPrevious2 = 0;  // y(-2)=0 for zero-state response
xPrevious = 0;     // x(-1)=0

for i = 1:N
    xCurrent = x(i);

    yzs(i) = 2*yzsPrevious1 - 3*yzsPrevious2 + xCurrent + xPrevious;

    yzsPrevious2 = yzsPrevious1;
    yzsPrevious1 = yzs(i);
    xPrevious = xCurrent;
end

// Total response for the given initial conditions and input.
yTotal = yzi + yzs;

// ------------------------------------------------------------
// 4. Display numerical results
// ------------------------------------------------------------

mprintf("System equation: y(n)=2*y(n-1)-3*y(n-2)+x(n)+x(n-1)\n");
mprintf("Initial conditions for zero-input response: y(-1)=1, y(-2)=1\n");
mprintf("Input for zero-state response: x(n)=2^n*u(n)\n\n");

disp("Impulse response, zero-input response, and zero-state response:");
disp("Columns: [n, h(n), y_zi(n), y_zs(n), total response]");
disp([n' h' yzi' yzs' yTotal']);

mprintf("\nFirst samples for checking:\n");
mprintf("h(n):     1, 3, 3, -3, -15, -21, ...\n");
mprintf("y_zi(n): -1, -5, -7, 1, 23, 43, ...\n");
mprintf("y_zs(n):  1, 5, 13, 23, 31, 41, ...\n");

// ------------------------------------------------------------
// 5. Plot the responses
// ------------------------------------------------------------

scf(1);
clf();

subplot(2,2,1);
plot2d3(n, h);
xtitle("Exercise 5 - Impulse Response h(n)", "n", "h(n)");
xgrid(1);

subplot(2,2,2);
plot2d3(n, yzi);
xtitle("Exercise 5 - Zero-Input Response", "n", "y_zi(n)");
xgrid(1);

subplot(2,2,3);
plot2d3(n, yzs);
xtitle("Exercise 5 - Zero-State Response", "n", "y_zs(n)");
xgrid(1);

subplot(2,2,4);
plot2d3(n, yTotal);
xtitle("Exercise 5 - Total Response", "n", "y(n)");
xgrid(1);

mprintf("\nExercise 5 completed.\n");

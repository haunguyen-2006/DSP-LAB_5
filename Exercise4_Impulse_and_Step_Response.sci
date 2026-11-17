// ============================================================
// DIGITAL SIGNAL PROCESSING - LAB 5
// EXERCISE 4: LTI SYSTEM - IMPULSE AND STEP RESPONSES
// ============================================================
// Given:
//     y(n) = 0.7*y(n-1) + x(n)
//
// Assuming initial rest:
//     H(z) = 1/(1 - 0.7*z^(-1))
//     h(n) = (0.7)^n u(n)
//     For x(n)=u(n):
//     y(n) = [1 - (0.7)^(n+1)]/(1 - 0.7)
//          = [1 - (0.7)^(n+1)]/0.3
//
// The script calculates both responses recursively and compares
// them with their analytical expressions.
// ============================================================

clear;
clc;

mprintf("==================================================\n");
mprintf("EXERCISE 4 - IMPULSE AND STEP RESPONSES\n");
mprintf("==================================================\n");

N = 21;
n = 0:(N-1);

// Impulse input: delta(n).
xImpulse = zeros(1, N);
xImpulse(1) = 1;

// Unit-step input: u(n).
xStep = ones(1, N);

h = zeros(1, N);
yStep = zeros(1, N);

// Initial rest: y(-1)=0 for both simulations.
hPrevious = 0;
yPrevious = 0;

for i = 1:N
    // Impulse response.
    h(i) = 0.7 * hPrevious + xImpulse(i);
    hPrevious = h(i);

    // Step response.
    yStep(i) = 0.7 * yPrevious + xStep(i);
    yPrevious = yStep(i);
end

// Analytical results.
hExpected = 0.7 .^ n;
yStepExpected = (1 - (0.7 .^ (n+1))) / 0.3;

errorH = max(abs(h - hExpected));
errorStep = max(abs(yStep - yStepExpected));

mprintf("System equation: y(n) = 0.7*y(n-1) + x(n)\n");
mprintf("Transfer function: H(z) = 1/(1 - 0.7*z^(-1))\n");
mprintf("Impulse response: h(n) = (0.7)^n*u(n)\n");
mprintf("Step response: y(n) = [1-(0.7)^(n+1)]/0.3\n\n");

disp("Impulse response [n, h(n)]:");
disp([n' h']);

disp("Step response for x(n)=u(n), [n, y(n)]:");
disp([n' yStep']);

mprintf("Maximum impulse-response verification error: %g\n", errorH);
mprintf("Maximum step-response verification error: %g\n", errorStep);

// Plot h(n) and the step response.
scf(1);
clf();

subplot(2,1,1);
plot2d3(n, h);
xtitle("Exercise 4 - Impulse Response h(n)", "Sample index n", "h(n)");
xgrid(1);

subplot(2,1,2);
plot2d3(n, yStep);
xtitle("Exercise 4 - Step Response for x(n)=u(n)", "Sample index n", "y(n)");
xgrid(1);

mprintf("\nExercise 4 completed.\n");

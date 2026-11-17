// ============================================================
// DIGITAL SIGNAL PROCESSING - LAB 5 (ADDITIONAL EXERCISES)
// EXERCISE 3.20: POLE-ZERO PATTERN AND Z-TRANSFORM
// ============================================================
// Given:
//   x1(n) = r^n sin(omega0*n) u(n),   0 < r < 1
//
// This script:
//   (a) Draws the pole-zero pattern of X1(z).
//   (b) Builds X2(z) from that pole-zero pattern using unity gain.
//   (c) Compares X1(z) and X2(z), then recovers the correct gain
//       from the known sample x1(1) = r*sin(omega0).
//
// The exact transform is:
//   X1(z) = [r*sin(omega0)] z /
//           [z^2 - 2*r*cos(omega0)*z + r^2]
//   ROC: |z| > r
//
// Pole-zero pattern:
//   zero: z = 0
//   poles: z = r*exp(+/-j*omega0)
//
// A pole-zero pattern alone does not determine the multiplicative
// gain. The unity-gain expression X2(z) therefore differs from
// X1(z) by the factor r*sin(omega0), unless that factor is 1.
// ============================================================

clear;
clc;

mprintf("============================================================\n");
mprintf("EXERCISE 3.20 - POLE-ZERO PATTERN\n");
mprintf("============================================================\n");

// ------------------------------------------------------------
// 1. Select numerical values for the parameters
// ------------------------------------------------------------
// The exercise gives a range for r but does not specify numerical
// values. These representative values can be changed as needed.

r = 0.8;
omega0 = %pi/4;

if r <= 0 | r >= 1 then
    error("Parameter r must satisfy 0 < r < 1.");
end

if omega0 <= 0 | omega0 >= %pi then
    error("Choose omega0 between 0 and pi (radians).");
end

// ------------------------------------------------------------
// 2. Generate x1(n) = r^n sin(omega0*n) u(n)
// ------------------------------------------------------------

N = 30;
n = 0:N;
x1 = (r.^n) .* sin(omega0 * n);

// ------------------------------------------------------------
// 3. Determine the poles, zero, and gain
// ------------------------------------------------------------

pole1 = r * exp(%i * omega0);
pole2 = r * exp(-%i * omega0);
poles = [pole1, pole2];
zero1 = 0;

// The gain is determined from x1(1) = r*sin(omega0).
// In the vector x1, n=0 is stored at index 1 and n=1 at index 2.
K = x1(2);

mprintf("\nChosen parameters:\n");
mprintf("r       = %.6f\n", r);
mprintf("omega0  = %.6f radians (%.2f degrees)\n", omega0, omega0*180/%pi);
mprintf("\nPole locations:\n");
mprintf("p1 = %.6f + j(%.6f)\n", real(pole1), imag(pole1));
mprintf("p2 = %.6f + j(%.6f)\n", real(pole2), imag(pole2));
mprintf("Zero  = 0\n");
mprintf("Gain K = r*sin(omega0) = %.6f\n", K);
mprintf("ROC   = |z| > %.6f\n", r);

// ------------------------------------------------------------
// 4. Plot the pole-zero pattern
// ------------------------------------------------------------

theta = linspace(0, 2*%pi, 500);
unitCircleReal = cos(theta);
unitCircleImag = sin(theta);

scf(1);
clf();

plot(unitCircleReal, unitCircleImag, "k--");
a = gca();
a.auto_clear = "off";
plot(real(poles), imag(poles), "rx");
plot(real(zero1), imag(zero1), "bo");
a.auto_clear = "on";

isoview("on");
a = gca();
a.data_bounds = [-1.1, -1.1; 1.1, 1.1];
xtitle("Exercise 3.20 - Pole-Zero Pattern", "Real axis", "Imaginary axis");
legend(["Unit circle"; "Poles"; "Zero at origin"]);
xgrid(1);

// ------------------------------------------------------------
// 5. Form X1(z) and X2(z) from the pole-zero pattern
// ------------------------------------------------------------
// Unity-gain expression inferred from the pole-zero locations:
//   X2(z) = z / [(z-p1)(z-p2)]
// The original signal has gain K = r*sin(omega0):
//   X1(z) = K*X2(z)

w = linspace(-%pi, %pi, 1001);
z = exp(%i * w);
denominator = z.^2 - 2*r*cos(omega0).*z + r^2;

X2 = z ./ denominator;
X1_from_formula = K * X2;

// Evaluate the exact closed-form X1(z) independently.
X1_exact = (r*sin(omega0).*z) ./ denominator;

// Correct X2 by applying the gain recovered from x1(1).
X2_corrected = K * X2;

errorUnityGain = max(abs(X1_exact - X2));
errorCorrected = max(abs(X1_exact - X2_corrected));

mprintf("\nTransform expressions:\n");
mprintf("X1(z) = K*z / [z^2 - 2*r*cos(omega0)*z + r^2]\n");
mprintf("X2(z) = z / [z^2 - 2*r*cos(omega0)*z + r^2]  (unity gain)\n");
mprintf("X1(z) = K * X2(z), where K = %.6f\n", K);
mprintf("\nMaximum |X1 - X2| with unity gain = %.6e\n", errorUnityGain);
mprintf("Maximum |X1 - K*X2|             = %.6e\n", errorCorrected);

if abs(K - 1) < 1d-12 then
    mprintf("For these parameters, the unity-gain X2(z) equals X1(z).\n");
else
    mprintf("X1(z) and the unity-gain X2(z) are not identical.\n");
    mprintf("The pole-zero pattern gives the pole/zero locations, but not the gain.\n");
    mprintf("Use x1(1) = r*sin(omega0) to determine the missing gain.\n");
end

// ------------------------------------------------------------
// 6. Plot x1(n) and compare the magnitudes on the unit circle
// ------------------------------------------------------------

scf(2);
clf();

subplot(2, 1, 1);
plot2d3(n, x1);
xtitle("x1(n) = r^n sin(omega0*n) u(n)", "n", "Amplitude");
xgrid(1);

subplot(2, 1, 2);
plot(w, abs(X1_exact), "b-");
a = gca();
a.auto_clear = "off";
plot(w, abs(X2), "r--");
a.auto_clear = "on";
xtitle("Magnitude on the Unit Circle", "Frequency (rad/sample)", "Magnitude");
legend(["|X1(e^jw)|"; "|X2(e^jw)|, unity gain"]);
xgrid(1);

mprintf("\nExercise 3.20 completed.\n");
mprintf("============================================================\n");

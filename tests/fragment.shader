#version 410 core

uniform vec2 resolution;
uniform float iTime;
vec2 fragCoord = gl_FragCoord.xy;
out vec4 theColor;
// iTime
// resolution
// theColor


// Verbesserter Audio-Reaktiver Neon-Japanischer Wellen-Shader mit dynamischeren Wellen
#define PI 3.14159265359

vec3 neonColors[7] = vec3[7](
    vec3(1.0, 0.2, 0.6),    // Neon Pink
    vec3(0.0, 1.0, 0.0),    // Neon Grün
    vec3(1.0, 1.0, 0.0),    // Neon Gelb
    vec3(1.0, 0.3, 0.0),    // Neon Orange
    vec3(0.0, 0.4, 1.0),    // Neon Blau
    vec3(0.8, 0.0, 1.0),    // Neon Lila
    vec3(1.0, 0.0, 0.2)     // Neon Rot
);

vec3 mixNeonColors(float t) {
    float scaledT = t * float(neonColors.length());
    int index = int(floor(scaledT));
    float fraction = fract(scaledT);
    vec3 color1 = neonColors[index % neonColors.length()];
    vec3 color2 = neonColors[(index + 1) % neonColors.length()];
    return mix(color1, color2, fraction);
}

float dynamicJapaneseWave(vec2 uv, float iTime, float beatIntensity) {
    // Dynamische Parameter
    float waveSpeed = 1.5 + sin(iTime * 0.3) * 0.5; // Geschwindigkeit variiert über die Zeit
    float waveAmplitude = 0.5 + sin(iTime * 0.5) * 0.3; // Amplitude variiert
    float waveFrequency = 3.0 + sin(iTime * 0.2) * 1.0; // Frequenz variiert
    float waveHeightOffset = sin(iTime * 0.1) * 0.3; // Wellenhöhe variiert

    float mainWave = sin(uv.x * waveFrequency - iTime * waveSpeed) * exp(-iTime * 0.02) * waveAmplitude;
    float smallWaves = sin(uv.x * (30.0 + sin(iTime * 0.4) * 10.0) - iTime * (4.0 + sin(iTime * 0.3))) * 0.05 * (1.0 - exp(-iTime * 0.2));
    float curve = sin(uv.x * PI + iTime * 0.2) * 0.2;
    float wave = mainWave + smallWaves + curve + waveHeightOffset;
    wave += exp(-iTime * 0.2) * sin(iTime * 2.0) * 0.2;
    return wave * (1.0 + beatIntensity * 0.5);
}

float detectBeat(float iTime) {
    float beatTime = 0.1;
    float intensity = 0.0;
    for (float t = 0.0; t < beatTime; t += 0.01) {
        float audioSample = texture(iChannel0, vec2(t, 0.25)).x;
        intensity += audioSample;
    }
    return smoothstep(0.0, 0.5, intensity / beatTime);
}

// Funktion für ein Gittermuster
float gridPattern(vec2 uv, float scale) {
    vec2 grid = abs(fract(uv * scale - 0.5) - 0.5) / fwidth(uv * scale);
    float line = min(grid.x, grid.y);
    return 1.0 - smoothstep(0.0, 1.0, line);
}

// Funktion für radiale Verzerrung
vec2 radialDistortion(vec2 uv, float strength) {
    float radius = length(uv);
    float angle = atan(uv.y, uv.x);
    radius = pow(radius, 1.0 + strength * sin(time));
    return vec2(cos(angle), sin(angle)) * radius;
}

void main() {
    vec2 uv = fragCoord / resolution.xy;
    uv = uv * 2.0 - 1.0;
    uv.x *= resolution.x / resolution.y;

    // Anwendung der radialen Verzerrung
    uv = radialDistortion(uv, 0.1);

    float beatIntensity = detectBeat(time);
    float iTime = time * (1.5 + beatIntensity); // Erhöhte Basisgeschwindigkeit

    float waveHeight = dynamicJapaneseWave(uv, iTime, beatIntensity);
    float waveIntensity = smoothstep(-0.2, 1.0, waveHeight);

    float colorIndex = (uv.x + waveHeight + iTime * 0.2) * 0.3; // Schnellerer Farbwechsel
    vec3 color = mixNeonColors(fract(colorIndex));

    color = pow(color, vec3(0.8));
    color *= 1.5 + beatIntensity * 0.7; // Verstärkte Reaktion auf den Beat

    float glow = 0.1 / (abs(uv.y - waveHeight * 0.5) + 0.02);
    color += glow * mixNeonColors(fract(colorIndex + 0.5)) * (2.0 + beatIntensity * 1.5);

    // Hinzufügen des Gittermusters zum Hintergrund
    float grid = gridPattern(uv, 20.0 + beatIntensity * 10.0);
    vec3 gridColor = mix(vec3(0.0), vec3(0.2), grid);

    vec3 bgColor = vec3(0.05, 0.05, 0.05) + gridColor;

    color = mix(bgColor, color, waveIntensity);

    // Hinzufügen von chromatischer Aberration
    float chroma = 0.005;
    vec3 chromaColor;
    chromaColor.r = texture(iChannel0, fragCoord / resolution.xy + vec2(chroma, 0.0)).r;
    chromaColor.g = texture(iChannel0, fragCoord / resolution.xy).g;
    chromaColor.b = texture(iChannel0, fragCoord / resolution.xy - vec2(chroma, 0.0)).b;
    color = mix(color, chromaColor, 0.5);

    color = pow(color, vec3(0.9));
    color = clamp(color * (1.2 + beatIntensity * 0.5), 0.0, 1.0);

    theColor = vec4(color, 1.0);
}
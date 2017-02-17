
#define PI 3.141562

float coscolor(float t, float f, float p, float a, float o)
{
    return o + a * cos(t * f * 2.0 * PI + p);
}

vec3 gradient(float t)
{
    // construct gradient from 3 cosines

    float r = coscolor(t, 2.0, -0.1, 0.4, 0.4);
    float g = coscolor(t, 0.5, 0.8, 0.4, 0.5);
    float b = coscolor(t, 1.0, 0.9, 0.6, 0.4);

    return vec3(r, g, b);
}

vec2 param(float t, float a)
{
    return vec2(cos(t), sin(t)) * a;
}

void main()
{
    float aspect = iResolution.x / iResolution.y;
    vec2 uv = gl_FragCoord.xy / iResolution.xy * 2.0 - 1.0;
    uv.x *= aspect;

    const float start = 0.0;
    const float end = 2.0 * PI;
    const float t_step = end * 0.05;

    float minDist = 100.0;

    for (float t = start; t <= end; t += t_step)
    {
        vec2 p = param(t + iGlobalTime * 0.1, 0.5 + 0.25 * sin(iGlobalTime));
        float d = distance(p, uv);
        minDist = min(minDist, d);
    }

    float k = 1.0 - step(0.02, minDist);

    float m = 1.0 - minDist;
    vec3 col = gradient(m * 10.0 + iGlobalTime * 2.0);
    //vec3 col = gradient((uv.x * 0.5 + 0.5));

    gl_FragColor = vec4(col, 1);
}
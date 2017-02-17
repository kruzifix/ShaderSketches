
#define PI 3.141562

float coscolor(float t, float f, float p, float a, float o)
{
    return o + a * cos(t * f * 2.0 * PI + p);
}

vec3 gradient(float t)
{
    // construct gradient from 3 cosines

    float r = coscolor(t, 0.8, 0.8, 0.2, 0.8);
    float g = coscolor(t, 1.5, 1.2, 0.4, 0.8);
    float b = coscolor(t, 2.0, 0.3, 0.4, 0.6);

    return vec3(r, g, b);
}

float circle(vec2 p, vec2 c, float r)
{
    return length(p - c) - r;
}

float sceneSDF(vec2 p)
{
    float t = iGlobalTime * 2.0;

    float dr = 0.2 + abs(0.03 * sin(t * 0.3));

    float c = circle(p, vec2(0), 0.3);
    const float n = 6.0;
    for (float i = 0.0; i < n; i++)
    {
        float alpha = i / n * 2.0 * PI - sin(t) * 0.1;
        float r = 0.3;
        c = min(c, circle(p, vec2(cos(alpha), sin(alpha)) * r, 0.15));
        float beta = alpha + sin(t + 0.3) * 0.1;
        r += dr;
        c = min(c, circle(p, vec2(cos(beta), sin(beta)) * r, 0.14));
        float gamma = beta + sin(t + 0.6) * 0.1;
        r += dr;
        c = min(c, circle(p, vec2(cos(gamma), sin(gamma)) * r, 0.13));
        float delta = gamma + sin(t - 0.3) * 0.1;
        r += dr;
        c = min(c, circle(p, vec2(cos(delta), sin(delta)) * r, 0.12));
    }
    return c;
}

void main()
{
#if 0
    float pause = floor(iGlobalTime / (2.0 * PI));
    if (mod(pause, 2.0) == 0.0)
    {
        gl_FragColor = vec4(0, 0, 0, 1);
        return;
    }
#endif

    float aspect = iResolution.x / iResolution.y;
    vec2 uv = gl_FragCoord.xy / iResolution.xy * 2.0 - 1.0;
    uv.x *= aspect;

    float c = sceneSDF(uv * 1.2);

    float t = 0.0;
    for (float h = -0.3; h < 0.3; h += 0.03)
    {
        t += smoothstep(h-0.003, h+0.003, c);
    }

    //vec3 col = vec3(step(0.0, c) * 0.5 + step(0.07, c) * 0.5);
    vec3 col = gradient(t * 0.098);

    col = pow(col, vec3(2.2));

    gl_FragColor = vec4(col, 1);
}

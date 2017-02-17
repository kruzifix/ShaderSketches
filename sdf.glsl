
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

void main()
{
    float aspect = iResolution.x / iResolution.y;
    vec2 uv = gl_FragCoord.xy / iResolution.xy * 2.0 - 1.0;
    uv.x *= aspect;

    float c = circle(uv, vec2(0), 0.4);
    const float n = 6.0;
    for (float i = 0.0; i < n; i++)
    {
        float alpha = i / n * 2.0 * PI + iGlobalTime * 0.3;
        c = min(c, circle(uv, vec2(cos(alpha), sin(alpha)) * 0.5, 0.1));
    }
    
    gl_FragColor = vec4(gradient(c + iGlobalTime * 0.2), 1);
}

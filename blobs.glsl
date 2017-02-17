
#define PI 3.141562

float coscolor(float t, float f, float p, float a, float o)
{
    return o + a * cos(t * f * 2.0 * PI + p);
}

vec3 gradient(float t)
{
    // construct gradient from 3 cosines

    float r = coscolor(t, 2.0, 0.0, 0.3, 0.7);
    float g = coscolor(t, 0.1, 1.2, 0.7, 0.5);
    float b = coscolor(t, 1.0, 3.0, 0.2, 0.5);

    return vec3(r, g, b);
}

float circle(vec2 p, vec2 c, float r)
{
    return length(p - c) - r;
}

float ring(vec2 p, vec2 c, float r, float w)
{
    return max(circle(p, c, r + w * 0.5), -circle(p, c, r - w * 0.5));
}

struct hit {
    float d;
    int i;
};

hit chit(float d, int i)
{
    hit h;
    h.d = d;
    h.i = i;
    return h;
}

hit uni(hit h1, hit h2)
{
    if (h1.d < h2.d)
    {
        return h1;
    }
    return h2;
}

void main()
{
    float aspect = iResolution.x / iResolution.y;
    vec2 uv = gl_FragCoord.xy / iResolution.xy * 2.0 - 1.0;
    uv.x *= aspect;

#if 0
    float pause = floor(iGlobalTime / (2.0 * PI));
    if (mod(pause, 2.0) == 0.0)
    {
        gl_FragColor = vec4(0, 0, 0, 1);
        return;
    }
#endif

    float gt = mod(iGlobalTime, 2.0 * PI);
    float a = smoothstep(0.2, 0.8, mod(gt, PI));
    float b = step(PI, gt);
    float t = (a + b) * PI;

    float s = 0.5 + 0.05 * sin(gt * 2.0);
    
    vec2 of = vec2(cos(t), sin(t));
    hit h0 = chit(ring(uv, of * 0.3, s, 0.03), 0);
    hit h1 = chit(ring(uv, -of * 0.3, s, 0.03), 1);
    
    vec2 uf = vec2(-sin(t), cos(t));
    hit h2 = chit(ring(uv, uf * 0.3, s, 0.03), 2);
    hit h3 = chit(ring(uv, -uf * 0.3, s, 0.03), 3);

    hit h4 = chit(ring(uv, vec2(0), 0.6 + 0.1 * cos(gt*2.0), 0.02), 6);

    hit res = uni(h0, uni(h1, uni(h2, h3)));
    res = uni(res, h4);

    float i = float(res.i) / 7.0;
    gl_FragColor = vec4(gradient(i * 2.0), 1);
}

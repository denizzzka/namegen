module namegen.elite;

//~ pure:
private:

const
{
    ubyte galaxiesNum = 8;
    ubyte galaxiesMask = 0x07;
    ushort systemsPerGalaxy = 256;

    ushort[3] seed = [0x5A4A, 0x0248, 0xB753];

    // Dots should be nullprint characters
    string otherDigrams =
        "ABOUSEITILETSTONLONUTHNO";

    string planetDigrams =
        "..LEXEGEZACEBISO"~
        "USESARMAINDIREA."~
        "ERATENBERALAVETI"~
        "EDORQUANTEISRION";

    string[] governments =
        [
            "Anarchy",
            "Feudal",
            "Multi-gov",
            "Dictatorship",
            "Communist",
            "Confederacy",
            "Democracy",
            "Corporate State",
        ];

    string[] economies =
        [
            "Rich Industrial",
            "Average Industrial",
            "Poor Industrial",
            "Mainly Industrial",
            "Mainly Agricultural",
            "Rich Agricultural",
            "Average Agricultural",
            "Poor Agricultural",
        ];
}

struct SystemInfo
{
    string name;
    string government;
    string economy;
}

struct GalaxySeed
{
    ushort[3] w;
    alias w this;

    void tweakSeed()
    {
        ushort t = w[0];
        t += w[1];
        t += w[2];

        w[0] = w[1];
        w[1] = w[2];
        w[2] = t;
    }
}

GalaxySeed createGalaxySeed(ubyte galaxyNum)
{
    assert(galaxyNum > 0);
    assert(galaxyNum <= 8);

    auto g = GalaxySeed(seed);

    while(galaxyNum > 1)
    {
        g[0].twist;
        g[1].twist;
        g[2].twist;

        galaxyNum--;
    }

    return g;
}

void twist(ref ushort x)
{
    x = rotatel((x >> 8) & 0xFF) * 256 + rotatel(x & 255);
}

ubyte rotatel(ubyte b) /// rotate 8 bit number leftwards
{
    b &= 0xFF;

    return (b & 127) << 1 | b >> 7;
}

bool isLongName(in GalaxySeed seed)
{
    return (seed.w[0] & 64) != 0;
}

auto wrapSeedValueToDigramsIndex(ushort w)
{
    return ((w >> 8) & 31) << 1;
}

string getPair(in GalaxySeed seed)
{
    size_t idx = seed.w[2].wrapSeedValueToDigramsIndex;
    auto dg = planetDigrams[idx .. idx + 2];

    import std.string: replace;

    return dg.replace(".", "");
}

string makeName(ref GalaxySeed currSeed)
{
    string name;

    const longName = currSeed.isLongName;

    foreach(_; 0 .. 3)
    {
        name ~= getPair(currSeed);
        currSeed.tweakSeed;
    }

    if(longName)
        name ~= getPair(currSeed);

    currSeed.tweakSeed;

    return name;
}

unittest
{
    for(ubyte gal = 1; gal <= galaxiesNum; gal++)
    {
        auto currSeed = createGalaxySeed(gal);

        foreach(i; 0 .. 256)
        {
            string name = makeName(currSeed);

            if(gal == 1)
            {
                assert(i != 0 || name == "TIBEDIED", name);
                assert(i != 7 || name == "LAVE", name);
            }

            if(gal == 2)
            {
                assert(i != 2 || name == "BEEDBEON", name);
            }
        }
    }
}

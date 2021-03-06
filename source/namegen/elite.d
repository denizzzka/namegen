/// Acornsoft Elite space trading video game planet name generator
module namegen.elite;

pure:

const
{
    ubyte galaxiesNum = 8;
    ubyte galaxiesMask = 0x07;
    ushort systemsPerGalaxy = 256;

    ushort[3] seed = [0x5A4A, 0x0248, 0xB753];

    string otherDigrams =
        "ABOUSEITILETSTONLONUTHNO";

    // Dots should be nullprint characters
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

struct GalaxySeed
{
    ushort[3] w;
    alias w this;

    void tweakSeed() pure
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
    assert(galaxyNum < 8);

    auto g = GalaxySeed(seed);

    while(galaxyNum > 0)
    {
        g[0].twist;
        g[1].twist;
        g[2].twist;

        galaxyNum--;
    }

    return g;
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
    for(ubyte gal = 0; gal < galaxiesNum; gal++)
    {
        auto currSeed = createGalaxySeed(gal);

        foreach(i; 0 .. systemsPerGalaxy)
        {
            string name = makeName(currSeed);

            if(gal == 0)
            {
                assert(i != 0 || name == "TIBEDIED", name);
                assert(i != 7 || name == "LAVE", name);
            }

            if(gal == 1)
            {
                assert(i != 2 || name == "BEEDBEON", name);
            }
        }
    }
}

private:

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

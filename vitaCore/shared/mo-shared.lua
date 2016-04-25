--[[
Project: vitaCore
File: mo-shared.lua
Author(s):	Sebihunter
]]--

gMonopolyField = {
[1] = {name="Start", pos = {2251.3161621094,-3427.2077636719,2.7015814781189},rot=305, xPos=0, yPos=1},
[2] = {name="Grove Street", pos = {2245.2192382813,-3427.2077636719,2.7009019851685},rot=305, xPos=0, yPos=1},
[3] = {name="Community Chest (!)", pos = {2240.8503417969,-3427.2077636719,2.7004837989807},rot=305, xPos=0, yPos=1, func="community"},
[4] = {name="Auto Circle", pos = {2236.677734375,-3427.2077636719,2.6999883651733},rot=305, xPos=0, yPos=1},
[5] = {name="Taxes", pos = {2231.7595214844,-3427.2077636719,2.6995174884796},rot=305, xPos=0, yPos=1},
[6] = {name="Aircraft Graveyard", pos = {2226.8344726563,-3427.2077636719,2.6990456581116},rot=305, xPos=0, yPos=1},
[7] = {name="Seville Boulevard", pos = {2221.9384765625,-3427.2077636719,2.6985769271851},rot=305, xPos=0, yPos=1},
[8] = {name="Chance (?)", pos = {2217.3571777344,-3427.2077636719,2.7017865180969},rot=305, xPos=0, yPos=1, func="chance"},
[9] = {name="Harrygold Parkway", pos = {2212.1975097656,-3427.2077636719,2.701292514801},rot=305, xPos=0, yPos=1},
[10] = {name="Windy Street", pos = {2207.4873046875,-3427.2077636719,2.7008414268494},rot=305, xPos=0, yPos=1},
 
[11] = {name="Police Department", pos = {2200.8195800781,-3424.8134765625,2.7002744674683},rot=215, xPos=1, yPos=0},
[12] = {name="Freeway North", pos = {2200.8195800781,-3418.9685058594,2.7002680301666},rot=215, xPos=1, yPos=0},
[13] = {name="Power Station", pos = {2200.8195800781,-3414.8276367188,2.7002539634705},rot=215, xPos=1, yPos=0},
[14] = {name="Scenic Route", pos = {2200.8195800781,-3410.0085449219,2.7002410888672},rot=215, xPos=1, yPos=0},
[15] = {name="Main Street", pos = {2200.8195800781,-3405.3049316406,2.7002286911011},rot=215, xPos=1, yPos=0},
[16] = {name="Airport L.S.", pos = {2200.8195800781,-3400.9331054688,2.7002167701721},rot=215, xPos=1, yPos=0},
[17] = {name="Verbatim Road", pos = {2200.8195800781,-3395.7651367188,2.7002029418945},rot=215, xPos=1, yPos=0},
[18] = {name="Community Chest (!)", pos = {2200.8195800781,-3390.9545898438,2.7001900672913},rot=215, xPos=1, yPos=0, func="community"},
[19] = {name="Venturas Strip", pos = {2200.8195800781,-3385.4660644531,2.7001752853394},rot=215, xPos=1, yPos=0},
[20] = {name="Julius Thruway", pos = {2200.8195800781,-3381.4343261719,2.7001645565033},rot=215, xPos=1, yPos=0},

[21] = {name="Bank Robbery", pos = {2201.3889160156,-3374.1142578125,2.7001616954803},rot=125, xPos=0, yPos=-1},
[22] = {name="6th Street", pos = {2208.0278320313,-3374.1142578125,2.7008452415466},rot=125, xPos=0, yPos=-1},
[23] = {name="Chance (?)", pos = {2212.7568359375,-3374.1142578125,2.7012503147125},rot=125, xPos=0, yPos=-1, func="chance"},
[24] = {name="Dix Road", pos = {2217.1350097656,-3374.1142578125,2.7017652988434},rot=125, xPos=0, yPos=-1},
[25] = {name="Saints Boulevard", pos = {2222.0075683594,-3374.1142578125,2.6985836029053},rot=125, xPos=0, yPos=-1},
[26] = {name="Airport S.F.", pos = {2226.5554199219,-3374.1142578125,2.6990189552307},rot=125, xPos=0, yPos=-1},
[27] = {name="Broadway", pos = {2231.3342285156,-3374.1142578125,2.6994767189026},rot=125, xPos=0, yPos=-1},
[28] = {name="Market Boulevard", pos = {2236.1594238281,-3374.1142578125,2.6999387741089},rot=125, xPos=0, yPos=-1},
[29] = {name="Dam", pos =  {2241.09765625,-3374.1142578125,2.7004115581512},rot=125, xPos=0, yPos=-1},
[30] = {name="Fifth Ave", pos = {2245.8081054688,-3374.1142578125,2.7008626461029},rot=125, xPos=0, yPos=-1},
 
[31] = {name="Back To Jail", pos = {2253.0546875,-3375.0617675781,2.701566696167},rot=35, xPos=-1, yPos=0},
[32] = {name="Rodeo Drive", pos = {2253.0546875,-3382.0124511719,2.7015714645386},rot=35, xPos=-1, yPos=0},
[33] = {name="Sunset Street", pos = {2253.0546875,-3386.60546875,2.7015817165375},rot=35, xPos=-1, yPos=0},
[34] = {name="Community Chest (!)", pos = {2253.0546875,-3391.248046875,2.7015635967255},rot=35, xPos=-1, yPos=0, func="community"},
[35] = {name="Temple Drive", pos = {2253.0546875,-3395.8657226563,2.7015566825867},rot=35, xPos=-1, yPos=0},
[36] = {name="Airport L.V.", pos = {2253.0546875,-3400.806640625,2.7015504837036},rot=35, xPos=-1, yPos=0},
[37] = {name="Chance (?)", pos = {2253.0546875,-3405.0739746094,2.7015452384949},rot=35, xPos=-1, yPos=0, func="chance"},
[38] = {name="San Peeso Street", pos = {2253.0546875,-3410.3564453125,2.7015385627747},rot=35, xPos=-1, yPos=0},
[39] = {name="Rent", pos = {2253.0546875,-3415.033203125,2.7015328407288},rot=35, xPos=-1, yPos=0},
[40] = {name="Vinevood Boulevard", pos = {2253.0546875,-3419.6354980469,2.7015271186829},rot=35, xPos=-1, yPos=0}
}

gMonopolyChance = {
{text="Go to 'Saints Boulevard' and collect 4000$ if you pass 'GO'."}, 
{text="You receive 3000$."}, 
{text="Pay 200$ or take a !-card."}, 
{text="Pay 300$."}, 
{text="Go back to 'Grove Street'."}, 
{text="Go to 'Aircraft Graveyard' and collect 4000$ if you pass 'GO'."}, 
{text="Go back three spaces."}, 
{text="Go to jail. Go directly to Jail. Do not pass 'GO'. Do not collect 4000$."}, 
{text="Get out of jail free - this card may be kept until needed."}, 
{text="Advance to 'GO'."}, 
{text="Go to 'Freeway North' and collect 4000$ if you pass 'GO'."}, 
{text="Go to 'Vinewood Boulevard'."}, 
{text="Pay every player 1000$."},
{text="Go to the next Airport. The owner gets double rent. You may buy this property if there is no owner yet."}, 
{text="Pay 500$ for each house, and 2000$ for each hotel."},
{text="You receive 1000$."}
}

gMonopolyChest = {
{text="Pay 800$ for each house and 2300$ for each hotel."}, 
{text="You receive 2000$."}, 
{text="You receive 500$."}, 
{text="You receive 4000$."}, 
{text="You receive 400$."}, 
{text="You receive 900$."}, 
{text="Pay 2000$."}, 
{text="Pay 1000$."}, 
{text="You receive 1$."}, 
{text="You receive 200$."}, 
{text="Get out of jail free - this card may be kept until needed."}, 
{text="Pay 5000$."}, 
{text="Go to jail. Go directly to Jail. Do not pass 'GO'. Do not collect 4000$."},
{text="You receive 1000$ from every player."}, 
{text="Advance to 'GO'."},
{text="Pay 3000$."}
}

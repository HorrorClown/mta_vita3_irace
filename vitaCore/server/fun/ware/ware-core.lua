--[[
Project: vitaCore
File: ware-core.lua
Author(s):	Sebihunter
]]--

wareArenaObjectBottom = createObject(13607, 259.3999023438, 359.1000976563, 57.299999237061)
wareArenaObjectWalls = createObject(13623, 259.3999023438, 359.1000976563, 67.300003051758)
setElementCollisionsEnabled ( wareArenaObjectWalls, true )
setElementDoubleSided ( wareArenaObjectWalls, true )
setElementDimension(wareArenaObjectBottom, gGamemodeFUN+100)
setElementDimension(wareArenaObjectWalls, gGamemodeFUN+100)

wareBossRunning = false

wareTimers = {}

local wareWinnerTable = false

wareWallCollision = {}
wareWallCollision[1] = createObject( 18449, 243.89999389648, 317.5, 58.799999237061, 270, 0, 0 )
wareWallCollision[2] = createObject( 18449, 254.80000305176, 317, 58.799999237061, 269.99450683594, 0, 5 )
wareWallCollision[3] = createObject( 18449, 260.70001220703, 317, 58.799999237061, 269.98901367188, 0, 10.998779296875 )
wareWallCollision[4] = createObject( 18449, 267.79998779297, 318.29998779297, 58.799999237061, 269.98901367188, 0, 16.997314453125 )
wareWallCollision[5] = createObject( 18449, 271.89999389648, 319.10000610352, 58.799999237061, 269.98901367188, 0, 24.995849609375 )
wareWallCollision[6] = createObject( 18449, 275.39999389648, 319.39999389648, 58.799999237061, 269.98901367188, 0, 36.993896484375 )
wareWallCollision[7] = createObject( 18449, 286.20001220703, 326.39999389648, 58.799999237061, 269.98901367188, 0, 50.990966796875 )
wareWallCollision[8] = createObject( 18449, 292.5, 332.5, 58.799999237061, 269.98901367188, 0, 64.987548828125 )
wareWallCollision[9] = createObject( 18449, 298.19921875, 343.8994140625, 58.799999237061, 269.98901367188, 0, 74.981689453125 )
wareWallCollision[10] = createObject( 18449, 300.39999389648, 352.39999389648, 58.799999237061, 269.98901367188, 0, 84.981689453125 )
wareWallCollision[11] = createObject( 18449, 300.7998046875, 360.8994140625, 58.799999237061, 269.98901367188, 0, 94.976806640625 )
wareWallCollision[12] = createObject( 18449, 299.8994140625, 367.7998046875, 58.799999237061, 269.98901367188, 0, 102.97485351563 )
wareWallCollision[13] = createObject( 18449, 298.5, 373.29998779297, 58.799999237061, 269.98901367188, 0, 112.97485351563 )
wareWallCollision[14] = createObject( 18449, 295.70001220703, 379.39999389648, 58.799999237061, 269.98901367188, 0, 120.97241210938 )
wareWallCollision[15] = createObject( 18449, 291.60000610352, 385.5, 58.799999237061, 269.98901367188, 0, 130.97045898438 )
wareWallCollision[16] = createObject( 18449, 288.79998779297, 388.60000610352, 58.799999237061, 269.98901367188, 0, 140.96801757813 )
wareWallCollision[17] = createObject( 18449, 284, 393.19921875, 58.799999237061, 269.98901367188, 0, 154.96215820313 )
wareWallCollision[18] = createObject( 18449, 274.10000610352, 398.10000610352, 58.799999237061, 269.98901367188, 0, 164.96215820313 )
wareWallCollision[19] = createObject( 18449, 267.79998779297, 399.89999389648, 58.799999237061, 269.98901367188, 0, 172.95971679688 )
wareWallCollision[20] = createObject( 18449, 258.70001220703, 400.5, 58.799999237061, 269.98901367188, 0, 182.95776367188 )
wareWallCollision[21] = createObject( 18449, 249.099609375, 399.19921875, 58.799999237061, 269.98901367188, 0, 194.95239257813 )
wareWallCollision[22] = createObject( 18449, 243.5, 397.70001220703, 58.799999237061, 269.98901367188, 0, 208.95239257813 )
wareWallCollision[23] = createObject( 18449, 237, 394.20001220703, 58.799999237061, 269.98901367188, 0, 216.94897460938 )
wareWallCollision[24] = createObject( 18449, 231.89999389648, 390.20001220703, 58.799999237061, 269.98901367188, 0, 224.94702148438 )
wareWallCollision[25] = createObject( 18449, 227.10000610352, 385.39999389648, 58.799999237061, 269.98901367188, 0, 234.94506835938 )
wareWallCollision[26] = createObject( 18449, 222, 377.10000610352, 58.799999237061, 269.98901367188, 0, 242.94262695313 )
wareWallCollision[27] = createObject( 18449, 218.10000610352, 366.29998779297, 58.799999237061, 269.98901367188, 0, 252.94067382813 )
wareWallCollision[28] = createObject( 18449, 217.80000305176, 360.5, 58.799999237061, 269.98901367188, 0, 262.93823242188 )
wareWallCollision[29] = createObject( 18449, 217.7998046875, 360.5, 58.799999237061, 269.98901367188, 0, 274.93579101563 )
wareWallCollision[30] = createObject( 18449, 218.80000305176, 350.5, 58.799999237061, 269.98901367188, 0, 278.93286132813 )
wareWallCollision[31] = createObject( 18449, 218.7998046875, 350.5, 58.799999237061, 269.98901367188, 0, 288.93188476563 )
wareWallCollision[32] = createObject( 18449, 221.69999694824, 342, 58.799999237061, 269.98901367188, 0, 296.92944335938 )
wareWallCollision[33] = createObject( 18449, 225, 335.79998779297, 58.799999237061, 269.98901367188, 0, 306.92749023438 )
wareWallCollision[34] = createObject( 18449, 229, 330.79998779297, 58.799999237061, 269.98901367188, 0, 314.92504882813 )
wareWallCollision[35] = createObject( 18449, 234, 326.2998046875, 58.799999237061, 269.98901367188, 0, 324.92065429688 )
wareWallCollision[36] = createObject( 18449, 239.2998046875, 322.69921875, 58.799999237061, 269.98901367188, 0, 332.91870117188 )
wareWallCollision[37] = createObject( 18449, 244.30000305176, 320.39999389648, 58.799999237061, 269.98901367188, 0, 338.91870117188 )
wareWallCollision[38] = createObject( 18449, 244.2998046875, 320.3994140625, 58.799999237061, 269.98901367188, 0, 346.91528320313 )
wareWallCollision[39] = createObject( 18449, 257.20001220703, 317.60000610352, 58.799999237061, 269.98901367188, 0, 350.66528320313 )

for i, element in ipairs(wareWallCollision) do
	setElementInterior(element, 1)
	setElementDimension(element, gGamemodeFUN+100)
end

local wareArena = {
	createObject ( 1409, 2478.3000488281, -1668, 120.90000152588 ),
	createObject ( 9596, 251, 343.39999389648, 42.400001525879, 0, 0, 177.99499511719 ),
	createObject ( 9596, 251, 343.3994140625, 42.400001525879, 0, 0, 87.989501953125 ),
	createObject ( 9596, 251, 343.3994140625, 42.400001525879, 0, 0, 357.98400878906 ),
	createObject ( 9596, 251, 343.3994140625, 42.400001525879, 0, 0, 267.978515625 ),
	createObject ( 9596, 132.5, 346.29998779297, 42.400001525879, 0, 0, 267.97302246094 ),
	createObject ( 9596, 132.5, 346.2998046875, 42.400001525879, 0, 0, 357.97302246094 ),
	createObject ( 9596, 251, 343.3994140625, 42.400001525879, 0, 0, 87.984008789063 ),
	createObject ( 9596, 253.89999389648, 461.89999389648, 42.400001525879, 0, 0, 267.978515625 ),
	createObject ( 9596, 253.8994140625, 461.8994140625, 42.400001525879, 0, 0, 177.97302246094 ),
	createObject ( 9596, 368.89999389648, 340.5, 42.400001525879, 0, 0, 177.96752929688 ),
	createObject ( 9596, 368.8994140625, 340.5, 42.400001525879, 0, 0, 57.967529296875 ),
	createObject ( 9596, 248.10000610352, 224.80000305176, 42.400001525879, 0, 0, 357.98950195313 ),
	createObject ( 9596, 248.099609375, 224.7998046875, 42.400001525879, 0, 0, 87.989501953125 ),
	createObject ( 9596, 135.30000305176, 465.20001220703, 42.400001525879, 0, 0, 267.96752929688 ),
	createObject ( 9596, 135.2998046875, 465.19921875, 42.400001525879, 0, 0, 177.96203613281 ),
	createObject ( 9596, 135.2998046875, 465.19921875, 42.400001525879, 0, 0, 357.95654296875 ),
	createObject ( 9596, 253.8994140625, 461.8994140625, 42.400001525879, 0, 0, 357.96752929688 ),
	createObject ( 9596, 253.8994140625, 461.8994140625, 42.400001525879, 0, 0, 87.967529296875 ),
	createObject ( 9596, 132.5, 346.2998046875, 42.400001525879, 0, 0, 267.96752929688 ),
	createObject ( 9596, 132.5, 346.2998046875, 42.400001525879, 0, 0, 177.96203613281 ),
	createObject ( 9596, 129.60000610352, 227.69999694824, 42.400001525879, 0, 0, 267.95654296875 ),
	createObject ( 9596, 248.099609375, 224.7998046875, 42.400001525879, 0, 0, 267.98400878906 ),
	createObject ( 9596, 248.099609375, 224.7998046875, 42.400001525879, 0, 0, 177.98400878906 ),
	createObject ( 9596, 129.599609375, 227.69921875, 42.400001525879, 0, 0, 177.95104980469 ),
	createObject ( 9596, 129.599609375, 227.69921875, 42.400001525879, 0, 0, 87.945556640625 ),
	createObject ( 9596, 129.599609375, 227.69921875, 42.400001525879, 0, 0, 357.94555664063 ),
	createObject ( 9596, 366, 221.80000305176, 42.400001525879, 0, 0, 357.98400878906 ),
	createObject ( 9596, 368.8994140625, 340.5, 42.400001525879, 0, 0, 357.96752929688 ),
	createObject ( 9596, 368.8994140625, 340.5, 42.400001525879, 0, 0, 267.96752929688 ),
	createObject ( 9596, 366, 221.7998046875, 42.400001525879, 0, 0, 267.978515625 ),
	createObject ( 9596, 366, 221.7998046875, 42.400001525879, 0, 0, 87.973022460938 ),
	createObject ( 9596, 366, 221.7998046875, 42.400001525879, 0, 0, 177.97302246094 ),
	createObject ( 9596, 372.5, 458.89999389648, 42.400001525879, 0, 0, 87.967529296875 ),
	createObject ( 9596, 372.5, 458.8994140625, 42.400001525879, 0, 0, 357.96752929688 ),
	createObject ( 9596, 372.5, 458.8994140625, 42.400001525879, 0, 0, 267.96752929688 ),
	createObject ( 9596, 132.5, 346.2998046875, 42.400001525879, 0, 0, 87.967529296875 ),
	createObject ( 9596, 372.5, 458.8994140625, 42.400001525879, 0, 0, 177.96203613281 ),
	createObject ( 18228, 396.89999389648, 202.19999694824, 54.5, 0, 0, 190 ),
	createObject ( 18228, 357.89999389648, 174.60000610352, 54.5, 0, 0, 169.99755859375 ),
	createObject ( 18228, 320.39999389648, 168.5, 54.5, 0, 0, 129.99694824219 ),
	createObject ( 18228, 279, 169.10000610352, 54.5, 0, 0, 129.99572753906 ),
	createObject ( 18228, 239.89999389648, 173, 54.5, 0, 0, 129.99572753906 ),
	createObject ( 18228, 204.60000610352, 174, 54.5, 0, 0, 129.99572753906 ),
	createObject ( 18228, 167.60000610352, 173.60000610352, 54.5, 0, 0, 129.99572753906 ),
	createObject ( 18228, 134.19999694824, 179.80000305176, 54.5, 0, 0, 119.99572753906 ),
	createObject ( 18228, 104, 210.60000610352, 54.5, 0, 0, 89.99267578125 ),
	createObject ( 18228, 86.400001525879, 250.89999389648, 54.5, 0, 0, 67.989013671875 ),
	createObject ( 18228, 83.300003051758, 294, 54.5, 0, 0, 57.988891601563 ),
	createObject ( 18228, 82.5, 334.79998779297, 54.5, 0, 0, 47.98583984375 ),
	createObject ( 18228, 82.900001525879, 379.5, 54.5, 0, 0, 47.982788085938 ),
	createObject ( 18228, 85.5, 418.89999389648, 54.5, 0, 0, 47.982788085938 ),
	createObject ( 18228, 89.300003051758, 464.5, 54.5, 0, 0, 47.982788085938 ),
	createObject ( 18228, 105.59999847412, 482.5, 54.5, 0, 0, 7.9827880859375 ),
	createObject ( 18228, 130.19999694824, 507.20001220703, 54.5, 0, 0, 357.98156738281 ),
	createObject ( 18228, 172.5, 515.59997558594, 54.5, 0, 0, 325.978515625 ),
	createObject ( 18228, 215.69999694824, 517.5, 54.5, 0, 0, 325.97534179688 ),
	createObject ( 18228, 254.39999389648, 515, 54.5, 0, 0, 319.97534179688 ),
	createObject ( 18228, 294.70001220703, 517, 54.5, 0, 0, 319.97131347656 ),
	createObject ( 18228, 336.20001220703, 517.5, 54.5, 0, 0, 319.97131347656 ),
	createObject ( 18228, 375.60000610352, 516.70001220703, 54.5, 0, 0, 319.97131347656 ),
	createObject ( 18228, 391.70001220703, 494.10000610352, 54.5, 0, 0, 279.97131347656 ),
	createObject ( 18228, 406.60000610352, 462.20001220703, 54.5, 0, 0, 239.97009277344 ),
	createObject ( 18228, 423.70001220703, 428, 54.5, 0, 0, 249.96887207031 ),
	createObject ( 18228, 424, 385.10000610352, 54.5, 0, 0, 229.96643066406 ),
	createObject ( 18228, 425.29998779297, 342, 54.5, 0, 0, 229.9658203125 ),
	createObject ( 18228, 421.70001220703, 298.10000610352, 54.5, 0, 0, 229.9658203125 ),
	createObject ( 18228, 417.29998779297, 259.10000610352, 54.5, 0, 0, 229.9658203125 ),
	createObject ( 18228, 412.5, 228.10000610352, 54.5, 0, 0, 229.9658203125 ),
	createObject ( 17031, 89.199996948242, 280.39999389648, 47.700000762939 ),
	createObject ( 17031, 108.80000305176, 212.39999389648, 47.700000762939, 0, 0, 50 ),
	createObject ( 17031, 182, 178.60000610352, 47.700000762939, 0, 0, 79.998779296875 ),
	createObject ( 17031, 227.80000305176, 178.19999694824, 47.700000762939, 0, 0, 79.996948242188 ),
	createObject ( 17031, 268.10000610352, 171.89999389648, 47.700000762939, 0, 0, 79.996948242188 ),
	createObject ( 17031, 320.29998779297, 173.10000610352, 47.700000762939, 0, 0, 83.996948242188 ),
	createObject ( 17031, 381.5, 193.19999694824, 47.700000762939, 0, 0, 123.99597167969 ),
	createObject ( 17031, 407, 236.10000610352, 47.700000762939, 0, 0, 153.99169921875 ),
	createObject ( 17031, 413.20001220703, 292.29998779297, 47.700000762939, 0, 0, 163.98986816406 ),
	createObject ( 17031, 420.20001220703, 348.5, 47.700000762939, 0, 0, 163.98742675781 ),
	createObject ( 17031, 420.60000610352, 400.39999389648, 47.700000762939, 0, 0, 163.98742675781 ),
	createObject ( 17031, 406, 453.5, 47.700000762939, 0, 0, 203.98742675781 ),
	createObject ( 17031, 363.29998779297, 507.20001220703, 47.700000762939, 0, 0, 253.98315429688 ),
	createObject ( 17031, 305.5, 511.39999389648, 47.700000762939, 0, 0, 263.98193359375 ),
	createObject ( 17031, 257.89999389648, 509.60000610352, 47.700000762939, 0, 0, 263.9794921875 ),
	createObject ( 17031, 204.19999694824, 509.5, 47.700000762939, 0, 0, 263.9794921875 ),
	createObject ( 17031, 154.60000610352, 514.5, 47.700000762939, 0, 0, 293.9794921875 ),
	createObject ( 17031, 112, 479.5, 47.700000762939, 0, 0, 323.97766113281 ),
	createObject ( 17031, 92.300003051758, 435.89999389648, 47.700000762939, 0, 0, 353.97583007813 ),
	createObject ( 17031, 88.5, 387.29998779297, 47.700000762939, 0, 0, 353.97399902344 ),
	createObject ( 17031, 87.800003051758, 335.5, 47.700000762939, 0, 0, 353.97399902344 ),
	createObject ( 726, 187.39999389648, 395.79998779297, 52.599998474121 ),
	createObject ( 726, 187.3994140625, 395.7998046875, 52.599998474121 ),
	createObject ( 726, 188.19999694824, 398.29998779297, 44.799999237061 ),
	createObject ( 726, 181.60000610352, 392.39999389648, 44.799999237061 ),
	createObject ( 726, 203.80000305176, 293.39999389648, 50.5 ),
	createObject ( 726, 207.69999694824, 287.70001220703, 44 ),
	createObject ( 726, 206.10000610352, 291.79998779297, 55.200000762939 ),
	createObject ( 3286, 250.89999389648, 279.70001220703, 57.099998474121 ),
	createObject ( 3286, 254.5, 279.70001220703, 57.099998474121 ),
	createObject ( 3403, 243.30000305176, 275.5, 55.400001525879, 0, 0, 270 ),
	createObject ( 13002, 336.20001220703, 400.79998779297, 57.200000762939, 0.49969482421875, 2, 339.98254394531 ),
	createObject ( 9596, 368.8994140625, 340.5, 42.400001525879, 0, 0, 87.967529296875 ),
	createObject ( 12922, 321.39999389648, 389.79998779297, 56, 0, 0, 317 ),
	createObject ( 16108, 231.19999694824, 451.10000610352, 55.799999237061, 2.9998779296875, 359.49932861328, 111.02621459961 ),
	createObject ( 16406, 134.69999694824, 332.20001220703, 54.799999237061 ),
	createObject ( 17061, 167.19999694824, 263.5, 52.5 ),
	createObject ( 17060, 183.19999694824, 272.10000610352, 52.400001525879 ),
	createObject ( 17059, 189.60000610352, 267, 52.400001525879, 0, 0, 90 ),
	createObject ( 17324, 202.5, 433.39999389648, 52.299999237061, 0, 0, 20 ),
	createObject ( 17457, 149.69999694824, 280, 54.400001525879, 0, 0, 320 ),
	createObject ( 726, 258.5, 276, 37.900001525879 ),
	createObject ( 726, 262.39999389648, 275.29998779297, 31.60000038147 ),
	createObject ( 726, 350.29998779297, 302.39999389648, 50.700000762939 ),
	createObject ( 726, 354.79998779297, 312.39999389648, 41.099998474121 ),
	createObject ( 726, 351.5, 305, 31.60000038147 ),
	createObject ( 726, 285.60000610352, 460.29998779297, 47.299999237061 ),
	createObject ( 726, 293.79998779297, 455, 41.799999237061 ),
	createObject ( 726, 283.29998779297, 449, 44.299999237061 ),
	createObject ( 17053, 318.79998779297, 248, 52.400001525879, 0, 0, 300 ),
	createObject ( 17039, 332.60000610352, 261.70001220703, 52.5, 0, 0, 60 ),
	createObject ( 17011, 136, 338.89999389648, 50.900001525879 ),
	createObject ( 17000, 306.89999389648, 228.19999694824, 51.900001525879 ),
	createObject ( 3402, 246.39999389648, 254.60000610352, 52.099998474121 ),
	createObject ( 14826, 315.70001220703, 410.10000610352, 53.400001525879 ),
	createObject ( 3066, 253, 457, 51.799999237061 ),
	createObject ( 925, 341.20001220703, 363.5, 53.400001525879 ),
	createObject ( 3577, 243.19999694824, 280.29998779297, 53.299999237061 ),
	createObject ( 3722, 141.19999694824, 285.5, 56.5, 0, 0, 320 ),
	createObject ( 10811, 114.40000152588, 424.29998779297, 60.799999237061, 0, 0, 310 ),
	createObject ( 12913, 347.20001220703, 347.79998779297, 54.599998474121 ),
	createObject ( 10675, 347.79998779297, 262, 55.799999237061 ),
	createObject ( 16076, 346.79998779297, 340.20001220703, 56.299999237061 ),
	createObject ( 683, 333.20001220703, 240.19999694824, 50.799999237061 ),
	createObject ( 683, 355.5, 351.70001220703, 50.799999237061 ),
	createObject ( 683, 384.79998779297, 432.10000610352, 50.799999237061 ),
	createObject ( 683, 243.5, 474.89999389648, 50.799999237061 ),
	createObject ( 683, 195.89999389648, 422.70001220703, 50.799999237061 ),
	createObject ( 683, 130.60000610352, 332.10000610352, 50.799999237061 ),
	createObject ( 683, 156, 272, 50.799999237061 ),
	createObject ( 683, 184.89999389648, 266.79998779297, 50.799999237061 ),
	createObject ( 683, 230.39999389648, 249.89999389648, 50.799999237061 )
}

for i, element in ipairs(wareArena) do
	setElementDimension(element, gGamemodeFUN+100)
end

function startFunWare()
	for i, element in ipairs(wareWallCollision) do
		setElementDimension(element, gGamemodeFUN)
	end
	for i, element in ipairs(wareArena) do
		setElementDimension(element, gGamemodeFUN)
	end	
	setElementDimension(wareArenaObjectBottom, gGamemodeFUN)
	setElementDimension(wareArenaObjectWalls, gGamemodeFUN)

	g_isWareRunning = false
	g_hasWareEnded = false	
	wareRunningGame = false
	wareBossRunning = false
	myWareGames = false
	setElementData(gElementFUN , "mapname", "VitaWare")
	wareGameCount = 0
	wareMaxGames = 30
	wareTimers = {}	
	
	wareTimers[#wareTimers+1] = setTimer(function()
		startFunWareInternal()
	end, 5000, 1)	
end
addEvent("startFunWare", true)
addEventHandler("startFunWare", getRootElement(), startFunWare)

function endFunWare()
	for i, element in ipairs(wareWallCollision) do
		setElementDimension(element, gGamemodeFUN+100)
	end
	for i, element in ipairs(wareArena) do
		setElementDimension(element, gGamemodeFUN+100)
	end	
	setElementDimension(wareArenaObjectBottom, gGamemodeFUN+100)
	setElementDimension(wareArenaObjectWalls, gGamemodeFUN+100)	
	
	for i,v in ipairs(wareTimers) do
		if v and isTimer(v) then killTimer(v) end
	end
end
addEvent("endFunWare", true)
addEventHandler("endFunWare", getRootElement(), endFunWare)

function joinFunWare(player)
	local x = math.random(-20,20)
	local y = math.random(-20,20)
	setPlayerNametagShowing ( player, true )
	callClientFunction(player, "wareClient", true)
	if wareBossRunning == false then
		spawnPlayer(player, 259.3999023438+x, 359.1000976563+y, 54+2,0,getElementData(player, "Skin"))
		setElementData(player, "state", "alive")
	else
		setElementData(player, "state", "dead")
		setCameraMatrix ( player, 259.3999023438,359.1000976563,150 ,259.3999023438,359.1000976563,54 )
	end
	setElementDimension(player, gGamemodeFUN)
	setElementFrozen(player, true)
	if wareBossRunning == false then
		wareTimers[#wareTimers+1] = setTimer(function(player)
			setElementFrozen(player, false)
		end, 1000, 1,player)
	end
	setCameraTarget(player, player)
	setElementData(player, "wareScore", 0)
	setElementData(player, "wareWon", false)	
	setElementData(player, "wareGameCount", wareGameCount)
	setElementData(player, "mapname", "VitaWare")
	callClientFunction(player, "showGUIComponents", "mapdisplay", "money")
	if g_isWareRunning == false then
		setElementData(player, "wareText", "Waiting for game to start...")
	end
	if g_hasWareEnded == true then
		callClientFunction(player, "endWareClient", wareWinnerTable )
	end
	showPlayerHudComponent ( player, "ammo", true )
	showPlayerHudComponent ( player, "armour", true )
	showPlayerHudComponent ( player, "breath", true )
	showPlayerHudComponent ( player, "health", true )
	showPlayerHudComponent ( player, "money", true )
	showPlayerHudComponent ( player, "weapon", true )
	callClientFunction(player, "resetWaterLevel")
end
addEvent("joinFunWare", true)
addEventHandler("joinFunWare", getRootElement(), joinFunWare)

function quitFunWare(player)
	setPlayerNametagShowing ( player, false )
	showPlayerHudComponent ( player, "ammo", false )
	showPlayerHudComponent ( player, "armour", false )
	showPlayerHudComponent ( player, "breath", false )
	showPlayerHudComponent ( player, "health", false )
	showPlayerHudComponent ( player, "money", false )
	showPlayerHudComponent ( player, "weapon", false )	
	callClientFunction(player, "hideGUIComponents", "mapdisplay", "money")
	setElementData(player, "mapname", false)
	setElementData(player, "wareMaths", false)
	setElementData(player, "wareText", false)
	callClientFunction(player, "wareClient", false)
	callClientFunction(player, "blockCarfade", false)
	toggleControl ( player, "fire", true )
	if wareBossRunning then
		triggerEvent ( "onPlayerWasted", player )
	end	
end
addEvent("quitFunWare", true)
addEventHandler("quitFunWare", getRootElement(), quitFunWare)

function startFunWareInternal()
	g_isWareRunning = true
	wareGameCount = 0
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		setElementData(player, "wareText", "~Welcome to Vita Ware~\nthe rules are easy:\ndo what it tells you to do!")
		callClientFunction(player, "playSound", "./files/audio/ware/game_prologue.mp3" )
	end
	
	wareTimers[#wareTimers+1] = setTimer(function()
		startNewWareGame()
	end, 13000, 1)
	wareTimers[#wareTimers+1] = setTimer(function()
		for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
			setElementData(player, "wareText", false)
		end	
	end, 12000, 1)	
end

function endFunWareInternal()
	outputDebugString("WARE: Ending")
	wareWinnerTable = {}
	for i, player in ipairs(getGamemodePlayers(gGamemodeFUN)) do
		wareWinnerTable[#wareWinnerTable+1] = {}
		wareWinnerTable[#wareWinnerTable].name = removeColorCoding(getPlayerName(player))
		wareWinnerTable[#wareWinnerTable].score = getElementData(player, "wareScore")
		wareWinnerTable[#wareWinnerTable].player = player
	end
	table.sort(wareWinnerTable,
		function(a, b)
			return a.score > b.score
		end
	)

	g_hasWareEnded = true
	for i, player in pairs(getGamemodePlayers(gGamemodeFUN)) do
		setElementData(player, "wareText", "~Goodbye Vita Ware~\nvote for the next gamemode starts shortly")
		callClientFunction(player, "playSound", "./files/audio/ware/game_ending.mp3" )	
		callClientFunction(player, "endWareClient", wareWinnerTable )	
		
		if getElementData(player, "wareScore") >= 30 then
			addPlayerArchivement(player, 73)
		end
	end
	wareTimers[#wareTimers+1] = setTimer(function()
		unloadModeFUN()
		startVoteFUN()
	end, 15000, 1)
end

function wastedFunWare(player, killer, weapon)
	if player and killer and weapon then
		for i,v in ipairs(getGamemodePlayers(getPlayerGameMode(player))) do
			triggerClientEvent ( v, "addKillmessage", v, player, killer, getWeaponNameFromID(weapon))
		end		
	end
	setElementData(player, "state", "dead")
	if wareBossRunning then return end
	wareTimers[#wareTimers+1] = setTimer( function(player)
		if isElement(player) == false or getElementData(player, "gameMode") ~= gGamemodeFUN then return end
		local x = math.random(-20,20)
		local y = math.random(-20,20)
		spawnPlayer(player, 259.3999023438+x, 359.1000976563+y, 54+2,0,getElementData(player, "Skin"))
		setElementDimension(player, gGamemodeFUN)
		setCameraTarget(player, player)
		setElementData(player, "state", "alive")
	end, 100, 1, player)	
end
addEvent("wastedFunWare", true)
addEventHandler("wastedFunWare", getRootElement(), wastedFunWare)